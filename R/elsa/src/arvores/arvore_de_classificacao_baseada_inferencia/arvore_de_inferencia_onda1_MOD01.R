if (!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(partykit, MLmetrics, caret, dplyr, unbalanced)

################################################################################
### Carregar dados (ajuste o caminho do arquivo)
source("./src/data_kNN.R")  # Certifique-se de que a variável 'data' é importada corretamente

### Garantindo reprodutibilidade
set.seed(123)

################################################################################
### Pré-processamento
dadosOnda1 <- data.frame(
  hipertensao = data$hip_onda1,
  potassio = data$pot_onda1,
  sodio = data$sod_onda1,
  razao_albumina_creatinina = data$albCreat_onda1,
  PAS = data$PAS_onda1,
  PAD = data$PAD_onda1,
  taxa_filtracao_glomerular = data$filt_onda1
)

# Verificação crítica das variáveis (evitar classes mistas)
dadosOnda1 <- dadosOnda1 %>%
  mutate(across(-hipertensao, ~ as.numeric(gsub(",", ".", .x))))  # Corrige vírgulas decimais

################################################################################
### Amostragem e balanceamento
predictors <- dadosOnda1 %>% sample_frac(0.50)

# Separar resposta e converter para fator
response <- as.factor(ifelse(predictors$hipertensao == 'N', 0, 1))
predictors <- predictors %>% select(-hipertensao)

# Verificação final das classes (TODAS devem ser numéricas)
if (any(sapply(predictors, class) != "numeric")) {
  stop("Variáveis preditoras não numéricas detectadas após conversão!")
}

# Aplicar SMOTE
tmp <- ubSMOTE(
  X = predictors,
  Y = response,
  perc.over = 500, 
  k = 5, 
  perc.under = 120
)

# Reconstruir dados balanceados
smote_data <- cbind(tmp$X, hipertensao = tmp$Y) %>%
  mutate(
    hipertensao = factor(ifelse(hipertensao == 0, "N", "S")),
    across(c(potassio, sodio, razao_albumina_creatinina, PAS, PAD), ~ round(.x, 2))
  )

################################################################################
### Divisão treino-teste
flag <- createDataPartition(smote_data$hipertensao, p = 0.6, list = FALSE)
train <- smote_data[flag, ]
test <- smote_data[-flag, ]

################################################################################
### Modelagem
ct <- ctree(hipertensao ~ ., data = train, control = ctree_control(minbucket = 50))

################################################################################
### Visualização
# Se necessário, inicie uma nova página de gráfico:
grid::grid.newpage()

plot(ct, 
     type = "simple", 
     ip_args = list(gp = gpar(cex = 0.7)),
     tp_args = list(gp = gpar(cex = 0.6)),
     main = "Árvore de Decisão - ELSA")

################################################################################
### Avaliação
test$classif <- predict(ct, newdata = test)
test$prev    <- predict(ct, newdata = test, type = "prob")[,2]

# Métricas finais
confusionMatrix(
  data = factor(ifelse(test$prev >= 0.5, "S", "N"), levels = c("N", "S")),
  reference = test$hipertensao,
  positive = "S"
)
