if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(caret, dplyr, readxl, rpart, rpart.plot, unbalanced, MLmetrics)
source("./src/data_kNN.R")

################################################################################
### Garantindo reprodutibilidade com a mesma semente
set.seed(123)
################################################################################
dadosOnda2 <- data.frame(hipertensao = data$hip_onda2,
                         potassio = data$pot_onda2,
                         sodio = data$sod_onda2,
                         razao_albumina_creatinina = data$albCreat_onda2,
                         PAS = data$PAS_onda2,
                         PAD = data$PAD_onda2,
                         taxa_filtracao_glomerular = data$filt_onda2
)

length(dadosOnda2$hipertensao)
table(dadosOnda2$hipertensao)
################################################################################
flag <- caret::createDataPartition(dadosOnda2$hipertensao, p=0.6, list = F)
train <- dadosOnda2[flag, ]
dim(train)
test <- dadosOnda2[-flag, ]
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