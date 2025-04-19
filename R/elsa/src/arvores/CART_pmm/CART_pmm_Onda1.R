### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/data/mice_inputation_v2.R")  # Verifique se esta etapa está importando 'data' corretamente

### Passo 1: Carregar os pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(caret, dplyr, rpart, rpart.plot, MLmetrics, ROSE)  # Certifique-se de carregar o pacote ROSE

View(dadosOnda1Mice_inp)   
glimpse(dadosOnda1Mice_inp)

table(dadosOnda1Mice_inp$hip)
summary(dadosOnda1Mice_inp)

################################################################################
### Exemplo de undersampling com ROSE
set.seed(123)  # Para reprodutibilidade
dadosOnda1Mice_inp_balanced <- ovun.sample(hip ~ ., data = dadosOnda1Mice_inp, method = "under", N = 1650 * 2)$data
# Verificando a nova distribuição das classes
table(dadosOnda1Mice_inp_balanced$hip)

################################################################################
### Passo 4: Checagem das categorias de referência
# Converte "0" para "N" e "1" para "S" e transforma em fator
dadosOnda1Mice_inp_balanced$hip <- ifelse(dadosOnda1Mice_inp_balanced$hip == "0", "N", "S")
dadosOnda1Mice_inp_balanced$hip <- as.factor(dadosOnda1Mice_inp_balanced$hip)
# Exibe os níveis atuais
levels(dadosOnda1Mice_inp_balanced$hip)  # Deve mostrar "N" e "S"
# Define "S" como a categoria de referência
#dadosOnda1Mice_inp_balanced$hip <- relevel(dadosOnda1Mice_inp_balanced$hip, ref = "S")

################################################################################
### Passo 3: Divisão treino-teste
flag <- caret::createDataPartition(dadosOnda1Mice_inp_balanced$hip, p = 0.7, list = FALSE)
train <- dadosOnda1Mice_inp_balanced[flag, ]
dim(train)
test <- dadosOnda1Mice_inp_balanced[-flag, ]
dim(test)
################################################################################
### Passo 4: Treino do modelo
mod <- rpart(hip ~ ., data = train, method = "class")

################################################################################
### Plot da árvore
rpart.plot::prp(mod, type = 5, extra = 104, nn = TRUE, fallen.leaves = TRUE, branch.lty = 5, cex = 0.55)

################################################################################
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
### Classificando novos elementos (variável test)
# Obtendo as probabilidades para cada classe
test$probs_all <- predict(mod, newdata = test, type = "prob")
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
cat("Acurácia:", MLmetrics::Accuracy(kprev, test$hip))
