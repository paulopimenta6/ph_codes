### Passo 0: Carregar dados
source("./src/data_kNN_v2.R")  # Verifique se 'data' está corretamente carregado

### Passo 1: Carregar os pacotes
if (!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(caret, ROSE, pROC, pscl, car, dplyr, ggplot2)

View(dadosOnda1kNN_inp)   
glimpse(dadosOnda1kNN_inp)

table(dadosOnda1kNN_inp$hip)
summary(dadosOnda1kNN_inp)

set.seed(123)
### Passo 2: Balanceamento dos dados
dadosOnda1kNN_inp_balanced <- ovun.sample(hip ~ ., data = dadosOnda1kNN_inp, method = "under", N = 1651 * 2)$data
dadosOnda1kNN_inp_balanced$hip <- ifelse(dadosOnda1kNN_inp_balanced$hip == '0', 0, 1)

### Passo 3: Dividir em treino e teste
flag <- caret::createDataPartition(dadosOnda1kNN_inp_balanced$hip, p = 0.7, list = FALSE)
train <- dadosOnda1kNN_inp_balanced[flag, ]
test  <- dadosOnda1kNN_inp_balanced[-flag, ]

### Passo 4: Ajuste do modelo e seleção de variáveis
fit <- glm(data = train, hip ~ ., family = binomial())
summary(fit)

fit1 <- glm(data = train, hip ~ pot + sod + albCreat + pas + pad, family = binomial())
summary(fit1)

fit2 <- glm(data = train, hip ~ pot + sod + pas + pad, family = binomial())
summary(fit2)

### Passo 5: Previsão no conjunto de teste
predictors <- setdiff(names(test), c("hip", "albCreat", "taxaFilt"))
test$prob <- predict(fit2, newdata = test[,predictors], type = "response")
test$pred <- ifelse(test$prob > 0.5, 1, 0)

# Transformar as colunas em fatores com os mesmos níveis
test$pred <- factor(test$pred, levels = c(0, 1))
test$hip  <- factor(test$hip, levels = c(0, 1))

### Passo 6: Avaliação do modelo - Matriz de Confusão
conf_matrix <- caret::confusionMatrix(test$pred, test$hip, positive = "1")
print(conf_matrix)

### Passo 7: Calcular a curva ROC usando as probabilidades preditas (test$prob)
roc_obj <- roc(test$hip, test$prob)
plot(roc_obj, col = "blue", lwd = 2, main = "Curva ROC")
auc_val <- auc(roc_obj)
cat("AUC:", auc_val, "\n")

### Passo 8: Pseudo R²
pseudoR2 <- pR2(fit2)
print(pseudoR2)

### Passo 9: Análise de Multicolinearidade (VIF)
vif_values <- vif(fit2)
print(vif_values)

################################################################################
### Aplicando o teste de Hosmer-Lemeshow
### O argumento g define em quantos grupos (decisões de risco) os dados serão divididos, geralmente 10
test$hip <- as.numeric(as.character(test$hip))
hl_test <- hoslem.test(test$hip, test$prob, g = 10)
print(hl_test)

################################################################################
# Criar grupos de risco
test$group <- cut(test$prob, breaks = quantile(test$prob, probs = seq(0, 1, by = 0.2)), include.lowest = TRUE)

# Observar as taxas médias preditas e observadas por grupo
calib_data <- test %>%
  group_by(group) %>%
  summarise(mean_prob = mean(prob),
            obs_rate = mean(as.numeric(as.character(hip))))

# Gráfico de calibração
ggplot(calib_data, aes(x = mean_prob, y = obs_rate)) +
  geom_point(size = 3, color = "blue") +
  geom_line(color = "red") +
  geom_abline(slope = 1, intercept = 0, linetype="dashed") +
  labs(title = "Gráfico de Calibração",
       x = "Probabilidade Média Predita",
       y = "Taxa de Eventos Observada") +
  theme_minimal()
