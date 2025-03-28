if (!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(caret, dplyr, readxl, rpart, rpart.plot, unbalanced, MLmetrics)
source("./src/data_kNN.R")

set.seed(123)  # Garantir reprodutibilidade

################################################################################
### Passo 1: Preparar dados originais (corrigir variáveis não numéricas)
dadosOnda2 <- data.frame(
  hipertensao = data$hip_onda2,
  potassio = data$pot_onda2,
  sodio = data$sod_onda2,
  PAS = data$PAS_onda2,
  PAD = data$PAD_onda2
)
### Verificar estrutura dos dados
str(dadosOnda2)  # Garantir que todas as variáveis preditoras são numéricas
################################################################################
### Passo 2: Aplicar SMOTE corretamente (sem amostragem prévia)
# Separar variáveis preditoras e resposta (sem amostragem aleatória desnecessária)
response <- as.factor(ifelse(dadosOnda2$hipertensao == 'N', 0, 1))
predictors <- dadosOnda2[, -which(names(dadosOnda2) == "hipertensao")]
################################################################################
### Garantir que todas as colunas preditoras são numéricas
predictors <- predictors %>% mutate(across(everything(), as.numeric))
################################################################################
# Aplicar SMOTE
tmp <- unbalanced::ubSMOTE(
  X = predictors, 
  Y = response,
  perc.over = 200, 
  k = 5, 
  perc.under = 150
)
################################################################################
### Combinar dados sintéticos
smote_data <- cbind(tmp$X, hipertensao = tmp$Y)
################################################################################
### Arredondar variáveis (apenas se necessário)
smote_data <- smote_data %>%
  mutate(
    potassio = round(potassio, 2),
    sodio = round(sodio, 2),
    PAS = round(PAS, 2),
    PAD = round(PAD, 2),
    hipertensao = ifelse(hipertensao == 0, "N", "S") %>% factor(levels = c("N", "S"))
  )
################################################################################
### Conferencia dos dados apos o balanceamento 
length(smote_data$hipertensao)
table(smote_data$hipertensao)
################################################################################
### Passo 3: Divisão treino-teste
flag <- caret::createDataPartition(smote_data$hipertensao, p = 0.6, list = FALSE)
train <- smote_data[flag, ]
test <- smote_data[-flag, ]
################################################################################
### Passo 4: Treino do modelo
mod <- rpart(hipertensao ~ ., data = train, method = "class")
################################################################################
# Plot da árvore
#rpart.plot(mod, type = 5, extra = 104, nn = TRUE)
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
### Passo 5: Avaliacao
test$probs <- predict(mod, newdata = test, type = "prob")[, "S"]  # Probabilidade da classe "S"
kprev <- factor(ifelse(test$probs >= 0.5, "S", "N"), levels = c("N", "S"))
################################################################################
# Métricas
conf_matrix <- caret::confusionMatrix(kprev, test$hipertensao, positive = "S")
print(conf_matrix)
cat("Acurácia:", MLmetrics::Accuracy(kprev, test$hipertensao))