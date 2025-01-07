if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(caret, dplyr, readxl, rpart, rpart.plot, MLmetrics)
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
### Criando o modelo
mod <- rpart(data = train, hipertensao~.)
################################################################################
### Plotando o modelo
prp(mod, type=5, extra=104, nn=T, fallen.leaves = TRUE, branch.lty = 5, cex = 0.58)
################################################################################
### Podando a arvore
printcp(mod)
################################################################################
round(mod$variable.importance, 2)
################################################################################
barplot(mod$variable.importance, col='lightgray',
        main = "Impotancia das variaveis", xlab = "variaveis",
        cex.lab = 1.3, cex.main = 1.4, cex.main = 1.3, 
        font.axis = 2)
################################################################################
### Classificando novos elementos (variavel test)
test$probs <- predict(mod, newdata = test, type="prob")
################################################################################
### probabilidade dos individuos de teste
head(round(test$probs, 3))
################################################################################
### Analise do modelo
### probabilidade de ser sim
psim <- test$probs[,2] 
kprev <- ifelse(psim>=0.50, "S", "N")
kprev <- as.factor(kprev)
confusionMatrix(kprev, test$hipertensao)

