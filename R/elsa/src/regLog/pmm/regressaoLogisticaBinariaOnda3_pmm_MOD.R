### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/mice_inputation_v2.R")  # Verifique se esta etapa está importando 'data' corretamente

### Passo 1: Carregar os pacotes
if (!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(caret, ROSE, pROC, pscl, car, dplyr, ggplot2)

set.seed(123)

View(dadosOnda3Mice_inp)   
glimpse(dadosOnda3Mice_inp)

table(dadosOnda3Mice_inp$hip)
summary(dadosOnda3Mice_inp)

dadosOnda3Mice_inp$hip <- ifelse(dadosOnda3Mice_inp$hip == '0', 0, 1)

### Passo 3: Dividir em treino e teste
flag <- caret::createDataPartition(dadosOnda3Mice_inp$hip, p = 0.7, list = FALSE)
train <- dadosOnda3Mice_inp[flag, ]
test  <- dadosOnda3Mice_inp[-flag, ]

fit1 <- glm(data = train, hip ~ pot + sod + pas + pad, family = binomial())
summary(fit1)

### Passo 5: Previsão no conjunto de teste
predictors <- setdiff(names(test), c("hip"))
test$prob <- predict(fit1, newdata = test[,predictors], type = "response")
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
pseudoR2 <- pR2(fit1)
print(pseudoR2)

### Passo 9: Análise de Multicolinearidade (VIF)
vif_values <- vif(fit1)
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
