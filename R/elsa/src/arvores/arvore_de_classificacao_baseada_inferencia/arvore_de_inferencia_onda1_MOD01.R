if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(partykit, MLmetrics, caret, dplyr, pROC, unbalanced)

################################################################################
source("./src/dadosRegLogistica.R") 
################################################################################

### Garantindo reprodutibilidade
set.seed(123)

################################################################################
### Passo 1: Preparação dos dados originais
dadosOnda1 <- data.frame(
  hipertensao = dataGLM$hip_onda1,
  potassio = dataGLM$pot_onda1,
  sodio = dataGLM$sod_onda1,
  razao_albumina_creatinina = dataGLM$albCreat_onda1,
  PAS = dataGLM$PAS_onda1,
  PAD = dataGLM$PAD_onda1,
  taxa_filtracao_glomerular = dataGLM$filt_onda1
)

# Verificação inicial
table(dadosOnda1$hipertensao)

################################################################################
### Passo 2: Divisão treino-teste ORIGINAL (antes do SMOTE!)
flag <- caret::createDataPartition(dadosOnda1$hipertensao, p = 0.6, list = FALSE)
train_original <- dadosOnda1[flag, ]
test_original <- dadosOnda1[-flag, ]

################################################################################
### Passo 3: Aplicar SMOTE APENAS nos dados de treino
set.seed(123) # Garantir reprodutibilidade no SMOTE

# Preparar variáveis para SMOTE
predictors_train <- train_original[, -which(names(train_original) == "hipertensao")]
response_train <- as.factor(ifelse(train_original$hipertensao == 'N', 0, 1))

# Aplicar SMOTE
tmp <- unbalanced::ubSMOTE(
  X = predictors_train, 
  Y = response_train,
  perc.over = 200, 
  k = 5, 
  perc.under = 105
)

# Combinar dados sintéticos
smote_data <- cbind(tmp$X, hipertensao = tmp$Y)

# Arredondar variáveis (ajuste conforme necessário)
smote_data <- smote_data %>%
  mutate(
    potassio = round(potassio, 2),
    sodio = round(sodio, 2),
    razao_albumina_creatinina = round(razao_albumina_creatinina, 2),
    PAS = round(PAS, 2),
    PAD = round(PAD, 2)
  )

# Converter resposta para fator
smote_data$hipertensao <- factor(
  ifelse(smote_data$hipertensao == 0, "N", "S"),
  levels = c("N", "S")
)

# Verificar balanceamento
table(smote_data$hipertensao)

################################################################################
### Passo 4: Treinar modelo
ct <- partykit::ctree(
  hipertensao ~ .,
  data = smote_data,
  control = partykit::ctree_control(maxdepth = 4) # Ajuste a profundidade
)

# Plot da árvore
plot(ct, type = "simple", main = "Árvore de Decisão - ELSA")

################################################################################
### Passo 5: Avaliar no teste ORIGINAL (sem dados sintéticos!)
test_original$prev_prob <- predict(ct, newdata = test_original, type = "prob")[, "S"]
test_original$pred_class <- factor(
  ifelse(test_original$prev_prob >= 0.5, "S", "N"),
  levels = c("N", "S")
)

################################################################################
### Passo 6: Métricas de avaliação
# Matriz de confusão
cat("Matriz de Confusão:\n")
conf_matrix <- confusionMatrix(
  test_original$pred_class,
  test_original$hipertensao,
  positive = "S"
)
print(conf_matrix)

# AUC-ROC
roc_obj <- pROC::roc(
  response = test_original$hipertensao,
  predictor = test_original$prev_prob,
  levels = c("N", "S")
)
cat("\nAUC-ROC:", auc(roc_obj), "\n")

# Gráfico ROC
plot(roc_obj, print.thres = "best", main = "Curva ROC")

# F1-Score
f1 <- MLmetrics::F1_Score(
  y_true = test_original$hipertensao,
  y_pred = test_original$pred_class,
  positive = "S"
)
cat("F1-Score:", f1, "\n")