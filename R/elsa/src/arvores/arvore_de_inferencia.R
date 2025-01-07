if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(partykit, MLmetrics)
################################################################################
source("./src/dadosRegLogistica.R")
################################################################################
### Garantindo reprodutibilidade com a mesma semente
set.seed(123)
################################################################################
dadosOnda1 <- data.frame(hipertensao = dataGLM$hip_onda1,
                         potassio = dataGLM$pot_onda1,
                         sodio = dataGLM$sod_onda1,
                         razao_albumina_creatinina = dataGLM$albCreat_onda1,
                         PAS = dataGLM$PAS_onda1,
                         PAD = dataGLM$PAD_onda1,
                         taxa_filtracao_glomerular = dataGLM$filt_onda1
)
################################################################################
flag <- createDataPartition(dadosOnda1$hipertensao, p=0.6, list = F)
train <- dadosOnda1[flag, ]
dim(train)
test <- dadosOnda1[-flag, ]
dim(test)
################################################################################
ct <- ctree(data = train, hipertensao ~ .)
ct
plot(ct, 
     type = "simple", 
     ip_args = list(gp = gpar(cex = 0.9)),  # Ajusta o texto dos nós internos
     tp_args = list(gp = gpar(cex = 0.68)),  # Ajusta o texto dos nós terminais
     main = "Elsa")
################################################################################
var_importance <- varimp(ct)
sort(var_importance, decreasing = TRUE)
barplot(var_importance)
################################################################################
### Classificacao nas categorias da variavel alvo
test$classif <- predict(ct, newdata = test)
head(test$classif)
### Probabilidade de pertecer a categoria alvo
test$prev <- predict(ct, newdata = test, type = "prob")
head(test$prev)
### Podemos ver a que no pertence a observacao
test$caixa <- predict(ct, newdata = test, type = "node")
head(test$caixa)
################################################################################
psim <- test$prev[,2]
kprev <- ifelse(psim>=0.50, "S", "N")
kprev <- as.factor(kprev)
confusionMatrix(kprev, test$hipertensao)