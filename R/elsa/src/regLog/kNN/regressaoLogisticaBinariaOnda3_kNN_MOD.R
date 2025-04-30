### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/data/data_kNN_v2.R")  # Verifique se esta etapa está importando 'data' corretamente

if (!require(pacman)) install.packages("pacman")
library(pacman)

# Carregar pacotes necessários
pacman::p_load(caret, pROC, car, ResourceSelection, gains, ggplot2)

View(dadosOnda3kNN_inp)   
glimpse(dadosOnda3kNN_inp)

table(dadosOnda3kNN_inp$hip)
summary(dadosOnda3kNN_inp)

set.seed(123)
################################################################################
### Passo 3: Divisão em treino e teste
flag <- caret::createDataPartition(dadosOnda3kNN_inp$hip, p = 0.7, list = FALSE)
train <- dadosOnda3kNN_inp[flag, ]
test <- dadosOnda3kNN_inp[-flag, ]

################################################################################
### Passo 4: Ajuste do modelo completo e seleção de variáveis
fit <- glm(hip ~ ., data = train, family = binomial())
summary(fit)

################################################################################
### Passo 6: Previsões
predictors <- setdiff(names(test), "hip")
test$prob <- predict(fit, newdata = test[,predictors], type = "response")
test$pred <- ifelse(test$prob > 0.5, 1, 0)

################################################################################
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
pseudoR2 <- pR2(fit)
print(pseudoR2)

### Passo 9: Análise de Multicolinearidade (VIF)
vif_values <- vif(fit)
print(vif_values)

### Aplicando o teste de Hosmer-Lemeshow
### O argumento g define em quantos grupos (decisões de risco) os dados serão divididos, geralmente 10
test$hip <- as.numeric(as.character(test$hip))
hl_test <- hoslem.test(test$hip, test$prob, g = 5)
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
