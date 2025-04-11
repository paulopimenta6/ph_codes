### Passo 0: Carregar dados
source("./src/data_kNN_v2.R")  # Verifique se 'data' está corretamente carregado

### Passo 1: Carregar os pacotes
if (!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(caret, ROSE, pROC, pscl, car, dplyr, ggplot2)

set.seed(18)

### Passo 2: Balanceamento dos dados
dadosOnda1kNN_inp_balanced <- ovun.sample(hip ~ ., data = dadosOnda1kNN_inp, method = "under", N = 1651 * 2)$data
dadosOnda1kNN_inp_balanced$hip <- ifelse(dadosOnda1kNN_inp_balanced$hip == "0", "N", "S")
dadosOnda1kNN_inp_balanced$hip <- factor(dadosOnda1kNN_inp_balanced$hip)
dadosOnda1kNN_inp_balanced$hip <- relevel(dadosOnda1kNN_inp_balanced$hip, ref = "S")

### Passo 3: Dividir em treino e teste
flag <- caret::createDataPartition(dadosOnda1kNN_inp_balanced$hip, p = 0.7, list = FALSE)
train <- dadosOnda1kNN_inp_balanced[flag, ]
test  <- dadosOnda1kNN_inp_balanced[-flag, ]

### Passo 4: Ajuste do modelo e seleção de variáveis
fit1 <- glm(data = train, hip ~ ., family = binomial())
fit1 <- step(fit1, trace = 0)
summary(fit1)

### Passo 5: Previsão no conjunto de teste
test$prob <- predict(fit1, newdata = test, type = "response")
test$pred <- ifelse(test$prob > 0.5, "S", "N")
test$pred <- factor(test$pred, levels = c("S", "N"))

### Passo 6: Avaliação do modelo - Matriz de Confusão
conf_matrix <- caret::confusionMatrix(test$pred, test$hip, positive = "S")
print(conf_matrix)

### Passo 7: Curva ROC e AUC
roc_obj <- roc(test$hip, test$prob, levels = c("N", "S"))
plot(roc_obj, col = "blue", main = "Curva ROC")
cat("AUC:", auc(roc_obj), "\n")

### Passo 8: Pseudo-R² (McFadden)
cat("Pseudo-R² (McFadden):\n")
print(pscl::pR2(fit1))

### Passo 9: Verificar multicolinearidade com VIF
cat("VIF das variáveis:\n")
print(car::vif(fit1))

### Passo 10: Análise dos resíduos
res <- residuals(fit1, type = "deviance")
plot(res, main = "Resíduos Deviance", ylab = "Resíduo", xlab = "Índice")
abline(h = 0, col = "red")

### Passo 11: Odds Ratio e Intervalos de Confiança
cat("Odds Ratio com IC 95%:\n")
print(exp(cbind(OddsRatio = coef(fit1), confint(fit1))))

### (Opcional) Validação cruzada com caret
ctrl <- trainControl(method = "cv", number = 10, classProbs = TRUE, summaryFunction = twoClassSummary)
modelo_cv <- train(hip ~ ., data = train, method = "glm", family = binomial(),
                   trControl = ctrl, metric = "ROC")
print(modelo_cv)

################################################################################
ggplot(test, aes(x = prob, fill = hip)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição das Probabilidades por Classe",
       x = "Probabilidade prevista",
       y = "Densidade") +
  theme_minimal()
