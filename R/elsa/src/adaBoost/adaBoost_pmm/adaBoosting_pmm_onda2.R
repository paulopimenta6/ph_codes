### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/data/mice_inputation_v2.R")  # Verifique se esta etapa está importando 'data' corretamente

### Passo 1: Carregar os pacotes
if (!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(caret, ROSE, pROC, dplyr, ggplot2, MLmetrics, adabag)

View(dadosOnda2Mice_inp)   
glimpse(dadosOnda2Mice_inp)

table(dadosOnda2Mice_inp$hip)
summary(dadosOnda2Mice_inp)

################################################################################
### exemplo de undersampling com ROSE
set.seed(123)  # Para reprodutibilidade
dadosOnda2Mice_inp_balanced <- ovun.sample(hip ~ ., data = dadosOnda2Mice_inp, method = "under", N = 1921 * 2)$data
# Verificando a nova distribuição das classes
table(dadosOnda2Mice_inp_balanced$hip)
################################################################################
###Passo 4: Checagem das categorias de referencia
dadosOnda2Mice_inp_balanced$hip <- ifelse(dadosOnda2Mice_inp_balanced$hip == "0", 'N', 'S')
dadosOnda2Mice_inp_balanced$hip <- as.factor(dadosOnda2Mice_inp_balanced$hip)
levels(dadosOnda2Mice_inp_balanced$hip)  #"N" e a categoria de referencia 
#dadosOnda2Mice_inp_balanced$hip <- relevel(dadosOnda2Mice_inp_balanced$hip, ref = "S")
################################################################################
### Agrupando as fracoes de treino e teste
flag <- caret::createDataPartition(dadosOnda2Mice_inp_balanced$hip, p=0.7, list = F) 
train <- dadosOnda2Mice_inp_balanced[flag, ]
dim(train)
test <- dadosOnda2Mice_inp_balanced[-flag, ]
dim(test)
################################################################################
ctrl <- rpart::rpart.control(maxdepth = 2)
ini = Sys.time() # Pegando o tempo inicial
### adaboosting usa boorsampling
ada.mod <- boosting(data = train,
                    hip ~ .,
                    mfinal = 200,
                    control = ctrl)
fim = Sys.time()
tempo = fim - ini
################################################################################
importanceplot(ada.mod)
################################################################################
### Analise dos erros
errorevol.train <- errorevol(ada.mod, train)
errorevol.test <- errorevol(ada.mod, test)
################################################################################
### Analisando as curvas de erros de tain e test
ylim_max <- max(c(errorevol.train$error, errorevol.test$error))
ylim_min <- min(c(errorevol.train$error, errorevol.test$error))
plot(errorevol.train$error, type = "l",
     main = "Boosting x Number of trees",
     xlab = "Iterations",
     ylab = "Erro",
     col = "#E41A1C",   # tom de vermelho mais suave
     lwd = 2,
     cex.axis = 1.2,
     cex.lab = 1.2,
     cex.main = 1.4,
     ylim = c(ylim_min, ylim_max),
     bty = "n")         # remove borda da plotagem

lines(errorevol.test$error, col = "#377EB8", lwd = 2)  # azul agradável

legend("topright",
       legend = c("Train", "Test"),
       col = c("#E41A1C", "#377EB8"),
       lwd = 2,
       cex = 0.6,
       bty = "t")  # sem borda na legenda

abline(h = min(errorevol.test$error), col = "#377EB8", lty = 2, lwd = 2)
abline(h = min(errorevol.train$error), col = "#E41A1C", lty = 2, lwd = 2)
grid(col = "gray90", lty = "dotted")
################################################################################
min(errorevol.test$error)
which.min(errorevol.test$error)
################################################################################
predictors <- setdiff(names(test), "hip")
pred = predict(ada.mod, newdata = test[, predictors], newmfinal = which.min(errorevol.test$error))
psim.class <- pred$class
psim.prob <- pred$prob[,2]
################################################################################
MLmetrics::ConfusionMatrix(y_pred = psim.class, y_true = test$hip)
Accuracy(y_pred = psim.class, y_true = test$hip)
### AUC requer alvo numerico
alvo <- ifelse(test$hip == "S", 1, 0)
AUC(y_pred=psim.prob,y_true = alvo)
################################################################################
# Gerar objeto ROC
roc_obj <- roc(response = alvo, predictor = psim.prob)
plot(roc_obj,
     col = "#377EB8",
     lwd = 3,
     main = "ROC curve - AdaBoosting model",
     ylab = "Sensitivity",
     xlab = "Specificity",
     legacy.axes = TRUE,
     print.auc = TRUE,
     auc.polygon = FALSE,
     max.auc.polygon = FALSE,
     grid = FALSE,
     print.thres = FALSE,
     smooth = TRUE)  # <-- isso suaviza a curva e evita cruzamentos