if (!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(caret, dplyr, readxl, rpart, rpart.plot, unbalanced, MLmetrics)
source("./src/data_kNN.R")

set.seed(123)  # Garantir reprodutibilidade

################################################################################
### Passo 1: Preparar dados originais (corrigir variáveis não numéricas)
dadosOnda1 <- data.frame(
  hipertensao = data$hip_onda1,
  potassio = data$pot_onda1,
  sodio = data$sod_onda1,
  razao_albumina_creatinina = data$albCreat_onda1,
  PAS = data$PAS_onda1,
  PAD = data$PAD_onda1,
  taxa_filtracao_glomerular = as.numeric(as.character(data$filt_onda1))  # Corrigir se for fator/ordinal
)

# Verificar estrutura dos dados
str(dadosOnda1)  # Garantir que todas as variáveis preditoras são numéricas

################################################################################
### Passo 2: Aplicar SMOTE corretamente (sem amostragem prévia)
# Separar variáveis preditoras e resposta (sem amostragem aleatória desnecessária)
response <- as.factor(ifelse(dadosOnda1$hipertensao == 'N', 0, 1))
predictors <- dadosOnda1[, -which(names(dadosOnda1) == "hipertensao")]

# Garantir que todas as colunas preditoras são numéricas
predictors <- predictors %>% mutate(across(everything(), as.numeric))

# Aplicar SMOTE
tmp <- unbalanced::ubSMOTE(
  X = predictors, 
  Y = response,
  perc.over = 200, 
  k = 5, 
  perc.under = 150
)

# Combinar dados sintéticos
smote_data <- cbind(tmp$X, hipertensao = tmp$Y)

# Arredondar variáveis (apenas se necessário)
smote_data <- smote_data %>%
  mutate(
    potassio = round(potassio, 2),
    sodio = round(sodio, 2),
    razao_albumina_creatinina = round(razao_albumina_creatinina, 2),
    PAS = round(PAS, 2),
    PAD = round(PAD, 2),
    hipertensao = ifelse(hipertensao == 0, "N", "S") %>% factor(levels = c("N", "S"))
  )

################################################################################
### Passo 3: Divisão treino-teste
flag <- caret::createDataPartition(smote_data$hipertensao, p = 0.6, list = FALSE)
train <- smote_data[flag, ]
test <- smote_data[-flag, ]

################################################################################
### Passo 4: Treinar modelo
mod <- rpart(hipertensao ~ ., data = train, method = "class")

# Plot da árvore
#rpart.plot(mod, type = 5, extra = 104, nn = TRUE)
rpart.plot::prp(mod, type=5, extra=104, nn=T, fallen.leaves = TRUE, branch.lty = 5, cex = 0.55)

################################################################################
### Passo 5: Avaliação
test$probs <- predict(mod, newdata = test, type = "prob")[, "S"]  # Probabilidade da classe "S"
kprev <- factor(ifelse(test$probs >= 0.5, "S", "N"), levels = c("N", "S"))

# Métricas
conf_matrix <- caret::confusionMatrix(kprev, test$hipertensao, positive = "S")
print(conf_matrix)
cat("Acurácia:", MLmetrics::Accuracy(kprev, test$hipertensao))