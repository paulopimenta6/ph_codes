library("caret")
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1,
                         hip = dataGLM$hip_onda1
)

set.seed(123)
N = nrow(dadosOnda1)
sorteio <- sample(1:N, N*0.75, FALSE)
#sorteio <- createDataPartition(dadosOnda1$hip, p = 0.5, list = FALSE)

baseTreino <- dadosOnda1[sorteio, ]
baseTeste <- dadosOnda1[-sorteio, ]

fit <- glm(hip ~ sod + pot, data = dadosOnda1, family = binomial(link = "logit"))
print(fit)

### Aplica modelo na base de treino
probabilitiesTr <- predict(fit, baseTreino[, 1:2], type = 'response')  
predictionsTr <-ifelse(probabilitiesTr > 0.30, 'S', 'N')

### Aplica modelo na base de teste
probabilitiesTst <- predict(fit, baseTeste[, 1:2], type = 'response')
logit <- log(probabilitiesTst/(1-probabilitiesTst))
df_plot <- data.frame(logit = logit, probability = probabilitiesTst)
predictionsTst <-ifelse(probabilitiesTst > 0.30, 'S', 'N')

### resultado do treino
resultadoTr <- caret::confusionMatrix(table(predictionsTr, baseTreino$hip))

#u <- union(predictionsTr, baseTreino$hip)
#t <- table(factor(predictionsTr, u), factor(baseTreino$hip, u))
#confusionMatrix(t)

### resultado do teste
resultadoTst <- caret::confusionMatrix(table(predictionsTst, baseTeste$hip))

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