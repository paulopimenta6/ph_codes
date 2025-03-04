################################################################################
### Carregar pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(partykit, MLmetrics, caret, dplyr, unbalanced, grid)

################################################################################
### Carregar dados (ajuste o caminho do arquivo)
source("./src/data_kNN.R")  # Verifique se esta etapa está importando 'data' corretamente

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

# Substituir vírgula por ponto e garantir que sejam numéricos
dadosOnda1 <- dadosOnda1 %>%
  mutate(across(-hipertensao, ~ as.numeric(gsub(",", ".", .x))))

################################################################################
### Amostragem e balanceamento
# Exemplo: pegar 50% dos dados originais
predictors <- dadosOnda1 %>%
  sample_frac(0.50)

# Separar a variável resposta, convertendo em fator binário (0/1)
response <- as.factor(ifelse(predictors$hipertensao == 'N', 0, 1))
predictors <- predictors %>% select(-hipertensao)

# Verificação de classes (todas devem ser numéricas)
if (any(sapply(predictors, class) != "numeric")) {
  stop("Variáveis preditoras não numéricas detectadas após conversão!")
}

# Aplicar SMOTE para balancear classes
tmp <- ubSMOTE(
  X = predictors,
  Y = response,
  perc.over = 500,  # oversampling
  k = 5,
  perc.under = 120  # undersampling
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
# Ajustar parâmetros de controle (por ex., limitar profundidade para evitar árvores muito grandes)
control <- ctree_control(
  minbucket = 150,
  maxdepth = 8    # você pode ajustar esse valor conforme necessário
)

ct <- ctree(hipertensao ~ ., data = train, control = control)

################################################################################
### Visualização
# Abra um dispositivo gráfico maior (por exemplo, em PDF ou janela) para evitar sobreposição
# Exemplo para PDF:
# pdf("arvore_decisao.pdf", width = 12, height = 8)

# No Windows, você pode usar:
windows(width = 16, height = 12)

plot(
  ct,
  type = "simple", 
  ip_args = list(gp = gpar(cex = 0.7)),  # Ajuste do tamanho de fonte dos nós internos
  tp_args = list(gp = gpar(cex = 0.62)),  # Ajuste do tamanho de fonte dos nós folha
  main = "Árvore de Decisão - ELSA"
)

# Se estiver salvando em PDF, lembre de fechar o dispositivo
# dev.off()

################################################################################
### Avaliação
# Previsões no conjunto de teste
test$classif <- predict(ct, newdata = test)
test$prev <- predict(ct, newdata = test, type = "prob")[, 2]

# Matriz de confusão e métricas
confusionMatrix(
  data = factor(ifelse(test$prev >= 0.5, "S", "N"), levels = c("N", "S")),
  reference = test$hipertensao,
  positive = "S"
)
