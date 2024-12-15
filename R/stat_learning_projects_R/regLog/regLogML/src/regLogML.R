library("mlbench")
library("caret")
library("dplyr")

data(PimaIndiansDiabetes)
tabela <- as.data.frame(PimaIndiansDiabetes)

set.seed(7)
N = nrow(tabela)
sorteio <- sample(1:N, N*0.75, FALSE)

baseTreino <- tabela[sorteio, ]
baseTeste <- tabela[-sorteio, ]

### Treina o modelo
fit <- glm(diabetes ~ ., data = baseTreino, family = binomial(link = "logit"))
print(fit)

### Aplica modelo na base de treino
probabilitiesTr <- predict(fit, baseTreino[, 1:8], type = 'response')  
predictionsTr <-ifelse(probabilitiesTr > 0.5, 'pos', 'neg')

### Aplica modelo na base de teste
probabilitiesTst <- predict(fit, baseTeste[, 1:8], type = 'response')
logit <- log(probabilitiesTst/(1-probabilitiesTst))
df_plot <- data.frame(logit = logit, probability = probabilitiesTst)
predictionsTst <-ifelse(probabilitiesTst > 0.5, 'pos', 'neg')

### resultado do treino
resultadoTr <- caret::confusionMatrix(table(predictionsTr, baseTreino$diabetes))

### resultado do teste
resultadoTst <- caret::confusionMatrix(table(predictionsTst, baseTeste$diabetes))

################################################################################
### Resultado Treino
resultadoTr$table

################################################################################
### Resultado Teste
resultadoTst$table

################################################################################
### Resultado da Acuracia
resultadoTst$overall[1]

################################################################################
# Gráfico
library(ggplot2)
ggplot(df_plot, aes(x = logit, y = probability)) +
  geom_point(alpha = 0.6, color = "blue") +
  geom_line(stat = "smooth", method = "glm", formula = y ~ x, 
            method.args = list(family = binomial), color = "red") +
  labs(
    title = "Relação entre Logito e Probabilidade Predita",
    x = "Logito (log(prob / (1 - prob)))",
    y = "Probabilidade Predita"
  ) +
  theme_minimal()