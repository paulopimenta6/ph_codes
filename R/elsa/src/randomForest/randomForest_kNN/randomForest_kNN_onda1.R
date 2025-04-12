### Passo 0: Carregar dados
source("./src/data_kNN_v2.R")  # Verifique se 'data' está corretamente carregado

### Passo 1: Carregar os pacotes
if (!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(caret, ROSE, pROC, pscl, car, dplyr, ggplot2, randomForest, hmeasure)

View(dadosOnda1kNN_inp)   
glimpse(dadosOnda1kNN_inp)

table(dadosOnda1kNN_inp$hip)
summary(dadosOnda1kNN_inp)

set.seed(123)
### Passo 1: Balanceamento dos dados
dadosOnda1kNN_inp_balanced <- ROSE::ovun.sample(hip ~ ., data = dadosOnda1kNN_inp, method = "under", N = 1651 * 2)$data
dadosOnda1kNN_inp_balanced$hip <- ifelse(dadosOnda1kNN_inp_balanced$hip == '0', 'N', 'S')

### Variavel ja balanceada
table(dadosOnda1kNN_inp_balanced$hip)

### Atendendo ao requisito de transformar em factor a variavel dependente
class(dadosOnda1kNN_inp_balanced$hip)
dadosOnda1kNN_inp_balanced$hip <- as.factor(dadosOnda1kNN_inp_balanced$hip)
dadosOnda1kNN_inp_balanced$hip <- relevel(dadosOnda1kNN_inp_balanced$hip, ref = 'S')

### Particionando os dados
### Passo 3: Dividir em treino e teste
flag <- caret::createDataPartition(dadosOnda1kNN_inp_balanced$hip, p = 0.7, list = FALSE)
train <- dadosOnda1kNN_inp_balanced[flag, ]
dim(train)
test  <- dadosOnda1kNN_inp_balanced[-flag, ]
dim(test)

set.seed(123)
rf <- randomForest(data = train, hip ~ ., ntree = 500, importance = TRUE)
rf

train$votes <- rf$votes
train$oob.times <- rf$oob.times

head(train$votes)
head(train$oob.times)
################################################################################
varImp(rf)
varImpPlot(rf)
################################################################################
plot(rf, col = c(1, 2, 8), lwd = 3)
legend("topright", 
       legend = c("OOB", "N", "S"), 
       col = c(1, 2, 8), 
       lty = 1,         # Define o tipo de linha (por padrão, linha contínua)
       lwd = 3,         # Mesma largura que as linhas do plot
       cex = 0.6,       # Reduz o tamanho do texto para não ocupar muito espaço
       bty = "n")       # Remove a caixa em volta da legenda (opcional)
grid()
################################################################################
predictors <- setdiff(names(test), "hip")
prev.rf <- predict(rf, newdata = test[, predictors], type = "prob")

psim.rf <- prev.rf[,2]
HMeasure(test$hip, prev.rf[,1])$metric[[3]]
################################################################################
#rf_tuned <- tuneRF(
#  x = 
#)