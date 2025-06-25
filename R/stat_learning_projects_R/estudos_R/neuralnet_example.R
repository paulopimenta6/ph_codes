# Exemplo de Rede Neural com neuralnet no R

# 1. Instalação e Carregamento de Pacotes
# Se você ainda não tem esses pacotes instalados, remova o '#' da linha abaixo e execute-a.
# install.packages(c("neuralnet", "caret", "dplyr"))

library(neuralnet)
library(caret) # Para one-hot encoding e pré-processamento
library(dplyr) # Para manipulação de dados

# 2. Criação de um Dataset de Exemplo
# Vamos simular um cenário onde queremos prever se um cliente 'Comprará' (1) ou não (0)
# com base em 'Idade', 'Renda' e 'Nivel_Educacao' (ordinal).

set.seed(123) # Para reprodutibilidade
dados <- data.frame(
  Idade = sample(18:60, 100, replace = TRUE),
  Renda = round(runif(100, 2000, 10000), 2),
  Nivel_Educacao = sample(c("Fundamental", "Medio", "Superior"), 100, replace = TRUE, prob = c(0.3, 0.4, 0.3)),
  Comprara = sample(c(0, 1), 100, replace = TRUE, prob = c(0.6, 0.4)) # Variável dependente binária
)

# Garantir que Nivel_Educacao seja um fator ordenado (opcional, mas boa prática para ordinais)
# No entanto, para one-hot encoding, a ordem não é estritamente necessária, mas semanticamente é bom.
# dados$Nivel_Educacao <- factor(dados$Nivel_Educacao, levels = c("Fundamental", "Medio", "Superior"), ordered = TRUE)

cat("\nDataset Original (primeiras 6 linhas):\n")
print(head(dados))

# 3. Pré-processamento dos Dados

# a) Normalização das Variáveis Numéricas (Idade, Renda)
# Usaremos a normalização Min-Max para escalar os dados entre 0 e 1.

# Função de normalização Min-Max
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

dados_normalizados <- dados %>%
  mutate(Idade_norm = normalize(Idade),
         Renda_norm = normalize(Renda))

cat("\nDataset com Variáveis Numéricas Normalizadas (primeiras 6 linhas):\n")
print(head(dados_normalizados))

# b) One-Hot Encoding para Variável Categórica Ordinal (Nivel_Educacao)
# Usaremos a função dummyVars do pacote caret.

dummy_model <- dummyVars(~ Nivel_Educacao, data = dados_normalizados)
dados_dummy <- predict(dummy_model, newdata = dados_normalizados)

# Combinar os dados one-hot com os dados normalizados e a variável dependente
dados_finais <- cbind(dados_normalizados %>% select(Idade_norm, Renda_norm, Comprara), dados_dummy)

cat("\nDataset Final para a Rede Neural (primeiras 6 linhas):\n")
print(head(dados_finais))

# 4. Divisão em Conjunto de Treino e Teste (Opcional, mas recomendado para avaliação)

# library(caTools) # Se não tiver, instale: install.packages("caTools")
# set.seed(123)
# split <- sample.split(dados_finais$Comprara, SplitRatio = 0.7)
# treino <- subset(dados_finais, split == TRUE)
# teste <- subset(dados_finais, split == FALSE)

# Para este exemplo simples, usaremos o dataset completo para o treinamento.
# Em um cenário real, você dividiria seus dados.

treino <- dados_finais

# 5. Treinamento da Rede Neural com neuralnet
# Usaremos a função de ativação logística (logistic.output = TRUE).
# A fórmula da rede neural deve incluir todas as variáveis preditoras.

# Construindo a fórmula dinamicamente
variaveis_preditoras <- names(treino)[!names(treino) %in% c("Comprara")]
formula_nn <- as.formula(paste("Comprara ~ ", paste(variaveis_preditoras, collapse = " + ")))

cat("\nFórmula da Rede Neural:\n")
print(formula_nn)

# Treinando a rede neural
# hidden = c(2) significa uma camada oculta com 2 neurônios.
# linear.output = FALSE é crucial para classificação binária com função logística.
# err.fct = "ce" (cross-entropy) é adequado para classificação binária.
# act.fct = "logistic" é a função de ativação para os neurônios da camada oculta.

nnet_model <- neuralnet(formula_nn,
                        data = treino,
                        hidden = c(2), # Exemplo: uma camada oculta com 2 neurônios
                        linear.output = FALSE, # Importante para classificação
                        err.fct = "ce", # Função de erro para classificação binária
                        act.fct = "logistic") # Função de ativação para neurônios ocultos

cat("\nResumo do Modelo da Rede Neural:\n")
print(nnet_model)

# 6. Visualização da Rede Neural
plot(nnet_model)

# 7. Previsões (Exemplo)
# Para fazer previsões, você precisa dos dados de entrada (sem a variável dependente).
# Se você tivesse um conjunto de teste, usaria ele aqui.

# Exemplo de previsão no conjunto de treinamento
predicoes_prob <- compute(nnet_model, treino %>% select(-Comprara))$net.result
predicoes_classe <- ifelse(predicoes_prob > 0.5, 1, 0)

cat("\nProbabilidades de Previsão (primeiras 10):\n")
print(head(predicoes_prob, 10))
cat("\nClasses Previstas (primeiras 10):\n")
print(head(predicoes_classe, 10))

# Comparar com os valores reais (primeiras 10)
cat("\nValores Reais (primeiras 10):\n")
print(head(treino$Comprara, 10))

# Avaliação (Exemplo simples com acurácia no conjunto de treinamento)
acuracia <- mean(predicoes_classe == treino$Comprara)
cat(paste0("\nAcurácia no conjunto de treinamento: ", round(acuracia, 4), "\n"))

# Observações:
# - A escolha do número de camadas ocultas e neurônios (hidden) é um hiperparâmetro
#   que geralmente é otimizado através de validação cruzada.
# - A função de ativação 'logistic' é usada por padrão na camada de saída quando
#   linear.output = FALSE e err.fct = 'ce', o que é ideal para variáveis dependentes binárias.
# - Lembre-se de que este é um exemplo simples. Em um projeto real, você faria
#   uma divisão de dados mais robusta (treino/validação/teste) e avaliaria o modelo
#   com métricas mais adequadas para classificação binária (precisão, recall, F1-score, AUC).


