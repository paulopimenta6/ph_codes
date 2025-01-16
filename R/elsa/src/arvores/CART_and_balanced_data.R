if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(caret, dplyr, readxl, rpart, rpart.plot, unbalanced, MLmetrics)
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

length(dadosOnda1$hip)
table(dadosOnda1$hip)

################################################################################
predictors <- dadosOnda1 ### Preservando o data frame original
#predictors <- sample_frac(predictors, .10)
predictors <- sample_frac(predictors, .50) 

response <- ifelse(predictors$hipertensao == 'N', 0, 1) ### 0 para N e 1 para S
response <- as.factor(response)

predictors <- predictors[, -which(names(predictors) == "hipertensao")]

tmp <- unbalanced::ubSMOTE(predictors, response,
               perc.over = 500, k = 5, perc.under = 120) # Melhor fit: 500, 120
smote_data <- cbind(tmp$X, tmp$Y)
names(smote_data)[which(names(smote_data)=='tmp$Y')] <- "hipertensao"

smote_data$potassio <- round(smote_data$potassio, 2)
smote_data$sodio <- round(smote_data$sodio, 2)
razao_albumina_creatinina <- round(smote_data$razao_albumina_creatinina, 2)
smote_data$PAS <- round(smote_data$PAS, 2)
smote_data$PAD <- round(smote_data$PAD, 2)


smote_data <- data.frame(potassio = smote_data$potassio,
                         sodio = smote_data$sodio,
                         razao_albumina_creatinina = smote_data$razao_albumina_creatinina,
                         PAS = smote_data$PAS,
                         PAD = smote_data$PAD,
                         taxa_filtracao_glomerular = smote_data$taxa_filtracao_glomerular,
                         hipertensao = smote_data$hipertensao
)
smote_data$hipertensao <- ifelse(smote_data$hipertensao == 0, "N", "S")
smote_data$hipertensao <- as.factor(smote_data$hipertensao)
table(smote_data$hipertensao)
################################################################################
flag <- caret::createDataPartition(smote_data$hipertensao, p=0.6, list = F)
train <- smote_data[flag, ]
dim(train)
test <- smote_data[-flag, ]
dim(test)
################################################################################
### Criando o modelo
mod <- rpart(data = train, hipertensao~.)
################################################################################
### Plotando o modelo
rpart.plot::prp(mod, type=5, extra=104, nn=T, fallen.leaves = TRUE, branch.lty = 5, cex = 0.55)
################################################################################
### Podando a arvore
rpart::printcp(mod)
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

### Classificando com base no limite de 0.20
kprev <- ifelse(psim>=0.50, "S", "N")
kprev <- as.factor(kprev)

### Matriz de confusão
MLmetrics::ConfusionMatrix(y_pred = kprev, y_true = test$hipertensao)
caret::confusionMatrix(data = kprev, reference = test$hipertensao)

### Acuracia do modelo
MLmetrics::Accuracy(y_pred = kprev, y_true = test$hipertensao)