### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/data_kNN_v2.R")  # Verifique se esta etapa está importando 'data' corretamente

###Passo 1: Carregar os pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(caret, pROC)

set.seed(18)
################################################################################
dadosOnda1kNN_inp_balanced <- ovun.sample(hip ~ ., data = dadosOnda1kNN_inp, method = "under", N = 1651 * 2)$data
dadosOnda1kNN_inp_balanced$hip <- ifelse(dadosOnda1kNN_inp_balanced$hip == "0", 'N', 'S')
dadosOnda1kNN_inp_balanced$hip <- as.factor(dadosOnda1kNN_inp_balanced$hip)
levels(dadosOnda1kNN_inp_balanced$hip)  #"N" e a categoria de referencia 
dadosOnda1kNN_inp_balanced$hip <- relevel(dadosOnda1kNN_inp_balanced$hip, ref = "S")
levels(dadosOnda1kNN_inp_balanced$hip)  #"S" e a nova categoria de referenci
################################################################################
flag <- caret::createDataPartition(dadosOnda1kNN_inp_balanced$hip, p=0.7, list = F)
train <- dadosOnda1kNN_inp_balanced[flag, ]
dim(train)
test <- dadosOnda1kNN_inp_balanced[-flag, ]
dim(test)
################################################################################
fit1 <- glm(data = dadosOnda1kNN_inp_balanced, hip ~ ., family = binomial())
fit1 <- step(fit1, trace = 0)
summary(fit1)
################################################################################
test$prob <- predict(fit1, newdata = test, type="response")
################################################################################
test$pred <- ifelse(test$prob > 0.5, "S", "N")
test$pred <- factor(test$pred, levels = c("S", "N"))

confusionMatrix(test$pred, test$hip, positive = "S")
################################################################################
roc_obj <- pROC::roc(test$hip, test$prob, levels = c("N", "S"))
plot(roc_obj, col = "blue", main = "Curva ROC")
pROC::auc(roc_obj)
################################################################################

