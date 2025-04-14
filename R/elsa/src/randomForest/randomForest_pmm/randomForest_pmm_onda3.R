### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/mice_inputation_v2.R")  # Verifique se esta etapa está importando 'data' corretamente

###Passo 1: Carregar os pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(caret, ROSE, pROC, pscl, car, dplyr, ggplot2, randomForest, hmeasure)

View(dadosOnda3Mice_inp)   
glimpse(dadosOnda3Mice_inp)

table(dadosOnda3Mice_inp$hip)
summary(dadosOnda3Mice_inp)

################################################################################
### A amostra esta balanceada
### > table(dadosOnda3Mice_inp$hip)
### 0    1 
### 2813 2248
################################################################################
dadosOnda3Mice_inp$hip <- ifelse(dadosOnda3Mice_inp$hip == "0", 'N', 'S')
dadosOnda3Mice_inp$hip <- as.factor(dadosOnda3Mice_inp$hip)
################################################################################
###Passo 4: Checagem das categorias de referencia
dadosOnda3Mice_inp$hip <- relevel(dadosOnda3Mice_inp$hip, ref = "S")
################################################################################

### Particionando os dados
### Passo 3: Dividir em treino e teste
flag <- caret::createDataPartition(dadosOnda3Mice_inp$hip, p = 0.7, list = FALSE)
train <- dadosOnda3Mice_inp[flag, ]
dim(train)
test  <- dadosOnda3Mice_inp[-flag, ]
dim(test)

set.seed(123)
rf <- randomForest(data = train, hip ~ ., 
                   ntree = 500, 
                   importance = TRUE)
rf

head(rf$votes)
head(rf$oob.times)
################################################################################
# Plotando a importância das variáveis
varImp(rf)
varImpPlot(rf)
################################################################################
#################################################################################
plot(rf, col = c(1, 2, 8), lwd = 3, main = "RF")  
legend("topright", 
       legend = c("OOB", "S", "N"), 
       col = c(1, 2, 8), 
       lty = 1,         # Define o tipo de linha (por padrão, linha contínua)
       lwd = 3,         # Mesma largura que as linhas do plot
       cex = 0.6,
       inset = c(0, 0.20)
)       # Reduz o tamanho do texto para não ocupar muito espaço
grid()
################################################################################
predictors <- setdiff(names(test), "hip")
################################################################################
prev.rf <- predict(rf, newdata = test[, predictors], type = "prob")

psim.rf <- prev.rf[,2]

# Métrica HMeasure
hmeasure_result <- HMeasure(test$hip, prev.rf[,1])$metric[[3]]
cat("Métrica HMeasure:", hmeasure_result, "\n")

# Matriz de Confusão
predicted <- predict(rf, newdata = test[, predictors], type = "response")
conf_matrix <- confusionMatrix(predicted, test$hip)
print(conf_matrix)

# AUC (Área sob a curva ROC)
roc_curve <- roc(test$hip, prev.rf[,2])
plot(roc_curve, col = "blue", main = "Curva ROC")
cat("AUC:", auc(roc_curve), "\n")

###############################################################################
###############################################################################
### Ajuste de Hiperparâmetros - TuneRF
# O código para ajustar os hiperparâmetros pode ser descomentado e ajustado da seguinte forma:
rf_tuned <- tuneRF(
  x = train[, predictors], 
  y = train$hip, 
  ntreeTry = 1000, 
  stepFactor = 1.5, 
  improve = 0.01, 
  trace = TRUE
)

# Verificando o resultado do ajuste
print(rf_tuned)

# A função tuneRF retorna os resultados em uma tabela, onde o valor ideal de mtry é aquele com menor erro
best_mtry <- rf_tuned[which.min(rf_tuned[, 2]), 1]
cat("Melhor valor de mtry:", best_mtry, "\n")

### Reajustando a arvore aleatoria
rf_final <- randomForest(
  data = train, 
  hip ~ ., 
  ntree = 1000, 
  mtry = best_mtry, 
  importance = TRUE
)

rf_final

head(rf_final$votes)
head(rf_final$oob.times)
#################################################################################
# Plotando a importância das variáveis
varImp(rf_final)
varImpPlot(rf_final, main = "Importancia das variáveis - Modelo Ajustado")
#################################################################################
plot(rf_final, col = c(1, 2, 8), lwd = 3, main = "RF Final")  
legend("topright", 
       legend = c("OOB", "S", "N"), 
       col = c(1, 2, 8), 
       lty = 1,         # Define o tipo de linha (por padrão, linha contínua)
       lwd = 3,         # Mesma largura que as linhas do plot
       cex = 0.6,
       inset = c(0, 0.25)
)       # Reduz o tamanho do texto para não ocupar muito espaço
grid()

# Previsões de probabilidade com rf_final
prev.rf.final <- predict(rf_final, newdata = test[, predictors], type = "prob")

# Probabilidade de ser classe positiva (classe de referência 'S')
psim.rf.final <- prev.rf.final[, 2]

# Métrica HMeasure
hmeasure_result <- HMeasure(test$hip, prev.rf.final[,1])$metric[[3]]
cat("Métrica HMeasure:", hmeasure_result, "\n")

# Matriz de Confusão
predicted <- predict(rf_final, newdata = test[, predictors], type = "response")
conf_matrix <- confusionMatrix(predicted, test$hip)
print(conf_matrix)

# AUC (Área sob a curva ROC)
roc_curve <- roc(test$hip, prev.rf.final[,2])
plot(roc_curve, col = "blue", main = "Curva ROC")
cat("AUC:", auc(roc_curve), "\n")