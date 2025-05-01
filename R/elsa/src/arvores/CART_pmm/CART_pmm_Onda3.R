### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/data/mice_inputation_v2.R")  # Verifique se esta etapa está importando 'data' corretamente

### Passo 1: Carregar os pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(caret, dplyr, rpart, rpart.plot, MLmetrics, ROSE)  # Certifique-se de carregar o pacote ROSE

View(dadosOnda3Mice_inp)   
glimpse(dadosOnda3Mice_inp)

table(dadosOnda3Mice_inp$hip)
summary(dadosOnda3Mice_inp)
################################################################################
### Exemplo de undersampling com ROSE
set.seed(123)  # Para reprodutibilidade

### Esta com pouco desbalanceamento
### > table(dadosOnda3Mice_inp$hip)
### 0    1 
### 2813 2248 

# Verificando a nova distribuição das classes
table(dadosOnda3Mice_inp$hip)
################################################################################
### Passo 4: Checagem das categorias de referência
# Converte "0" para "N" e "1" para "S" e transforma em fator
dadosOnda3Mice_inp$hip <- ifelse(dadosOnda3Mice_inp$hip == "0", "N", "S")
dadosOnda3Mice_inp$hip <- as.factor(dadosOnda3Mice_inp$hip)
# Exibe os níveis atuais
levels(dadosOnda3Mice_inp$hip)  # Deve mostrar "N" e "S"
# Define "S" como a categoria de referência
#dadosOnda3Mice_inp$hip <- relevel(dadosOnda3Mice_inp$hip, ref = "S")
################################################################################
### Passo 3: Divisão treino-teste
flag <- caret::createDataPartition(dadosOnda3Mice_inp$hip, p = 0.7, list = FALSE)
train <- dadosOnda3Mice_inp[flag, ]
dim(train)
test <- dadosOnda3Mice_inp[-flag, ]
dim(test)
################################################################################
### Passo 4: Treino do modelo
mod <- rpart(hip ~ ., data = train, method = "class")
################################################################################
### Plot da árvore
rpart.plot::prp(mod, type = 5, extra = 104, nn = TRUE, fallen.leaves = TRUE, branch.lty = 5, cex = 0.55)
###############################################################################
### Verificação da necessidade de poda da árvore
rpart::printcp(mod)
################################################################################
### Verificando a importância das variáveis
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
predictors <- setdiff(names(test), "hip")
################################################################################
### Classificando novos elementos (variável test)
# Obtendo as probabilidades para cada classe
test$probs_all <- predict(mod, newdata = test[, predictors], type = "prob")
# Visualizando as primeiras linhas
head(round(test$probs_all, 3))
################################################################################
### Passo 5: Avaliação
# Extraindo a probabilidade da classe "S"
test$probs <- test$probs_all[, "S"]

# Definindo a predição com threshold de 0.5
kprev <- factor(ifelse(test$probs >= 0.5, "S", "N"), levels = c("N", "S"))

# Garantir que a variável real também possua os mesmos níveis e ordem
test$hip <- factor(test$hip, levels = c("N", "S"))
################################################################################
# Métricas
conf_matrix <- caret::confusionMatrix(kprev, test$hip, positive = "S")
print(conf_matrix)