if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(partykit, MLmetrics, caret, dplyr)
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

length(dadosOnda1$hipertensao)
table(dadosOnda1$hipertensao)
################################################################################
predictors <- dadosOnda1 ### Preservando o data frame original
predictors <- dplyr::sample_frac(predictors, .50) 

response <- ifelse(predictors$hipertensao == 'N', 0, 1) ### 0 para N e 1 para S
response <- as.factor(response)

predictors <- predictors[, -which(names(predictors) == "hipertensao")]

tmp <- unbalanced::ubSMOTE(predictors, response,
                           perc.over = 500, k = 5, perc.under = 120) # Melhor fit: 500, 120
smote_data <- cbind(tmp$X, tmp$Y)
names(smote_data)[which(names(smote_data)=='tmp$Y')] <- "hipertensao"

smote_data$potassio <- round(smote_data$potassio, 2)
smote_data$sodio <- round(smote_data$sodio, 2)
smote_data$razao_albumina_creatinina <- round(smote_data$razao_albumina_creatinina, 2)
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
ct <- ctree(data = train, hipertensao ~ .)
ct
plot(ct, 
     type = "simple", 
     ip_args = list(gp = gpar(cex = 0.9)),  # Ajusta o texto dos nós internos
     tp_args = list(gp = gpar(cex = 0.7)),  # Ajusta o texto dos nós terminais
     main = "Elsa")
################################################################################
var_importance <- varimp(ct)
sorted_importance <- sort(var_importance, decreasing = TRUE)

plot(sorted_importance, type = "o", col = "blue", pch = 16,
     xaxt = "n",  # Exclui o eixo x original
     xlab = "Variáveis", ylab = "Importância",
     main = "Importância das Variáveis")
### Adiciona nomes das variáveis ao eixo x
axis(1, at = 1:length(sorted_importance), labels = names(sorted_importance), las = 1)
################################################################################
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