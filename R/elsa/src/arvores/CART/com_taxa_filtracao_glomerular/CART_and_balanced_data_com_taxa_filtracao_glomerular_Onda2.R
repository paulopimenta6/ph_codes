if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(caret, dplyr, readxl, rpart, rpart.plot, unbalanced, MLmetrics)
source("./src/dadosRegLogistica.R")

################################################################################
### Garantindo reprodutibilidade com a mesma semente
set.seed(123)
################################################################################
dadosOnda2 <- data.frame(hipertensao = dataGLM$hip_onda2,
                         potassio = dataGLM$pot_onda2,
                         sodio = dataGLM$sod_onda2,
                         razao_albumina_creatinina = dataGLM$albCreat_onda2,
                         PAS = dataGLM$PAS_onda2,
                         PAD = dataGLM$PAD_onda2,
                         taxa_filtracao_glomerular = dataGLM$filt_onda2
)

length(dadosOnda2$hip)
table(dadosOnda2$hip)

################################################################################
predictors <- dadosOnda2 ### Preservando o data frame original
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
mod <- rpart(data = train, hipertensao~., method = "class")
################################################################################
### Plotando o modelo
rpart.plot::prp(mod, type=5, extra=104, nn=T, fallen.leaves = TRUE, branch.lty = 5, cex = 0.55)
################################################################################
### Podando a arvore
rpart::printcp(mod)
################################################################################
round(mod$variable.importance, 2)
################################################################################
importance_df <- data.frame(Variable = names(mod$variable.importance), 
                            Importance = mod$variable.importance)

### Ordenar os dados para uma melhor visualização
importance_df <- importance_df[order(importance_df$Importance, decreasing = TRUE), ]

### Criar o gráfico de linhas usando a função plot
plot(importance_df$Importance, type = 'b', pch = 16, col = 'black',
     xaxt = 'n', ylab = "Importância", xlab = "Variáveis",
     main = "Importância das Variáveis")
### Adicionar os nomes das variáveis ao eixo X
axis(1, at = 1:length(importance_df$Variable), labels = importance_df$Variable, las = 1)
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