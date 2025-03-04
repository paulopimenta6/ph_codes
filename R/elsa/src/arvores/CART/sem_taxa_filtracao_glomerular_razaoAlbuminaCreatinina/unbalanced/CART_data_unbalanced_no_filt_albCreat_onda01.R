if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(caret, dplyr, readxl, rpart, rpart.plot, unbalanced, MLmetrics)
source("./src/data_kNN.R")

################################################################################
### Garantindo reprodutibilidade com a mesma semente
set.seed(123)
################################################################################
### Passo 1: Preparar dados originais (corrigir variáveis não numéricas)
dadosOnda1 <- data.frame(hipertensao = data$hip_onda1,
                         potassio = data$pot_onda1,
                         sodio = data$sod_onda1,
                         PAS = data$PAS_onda1,
                         PAD = data$PAD_onda1
)
### Verificar estrutura dos dados
str(dadosOnda1)  # Garantir que todas as variáveis preditoras são numéricas
################################################################################
### Passo 3: Divisão treino-teste
flag <- caret::createDataPartition(dadosOnda1$hipertensao, p=0.6, list = F)
train <- dadosOnda1[flag, ]
dim(train)
test <- dadosOnda1[-flag, ]
dim(test)
################################################################################
### Passo 4: Treino do modelo
mod <- rpart(data = train, hipertensao~., method = "class")
################################################################################
### Plot da árvore
rpart.plot::prp(mod, type=5, extra=104, nn=T, fallen.leaves = TRUE, branch.lty = 5, cex = 0.55)
################################################################################
### Verificacao necessidade poda da arvore
rpart::printcp(mod)
################################################################################
### Verificando a importancia das variaveis
round(mod$variable.importance, 2)
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
### Passo 5: Avaliacao
test$probs <- predict(mod, newdata = test, type = "prob")[, "S"]  # Probabilidade da classe "S"
kprev <- factor(ifelse(test$probs >= 0.5, "S", "N"), levels = c("N", "S"))
################################################################################
# Métricas
conf_matrix <- caret::confusionMatrix(kprev, test$hipertensao, positive = "S")
print(conf_matrix)
cat("Acurácia:", MLmetrics::Accuracy(kprev, test$hipertensao))