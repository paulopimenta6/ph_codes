# Exemplo de dados
dados <- data.frame(
  resposta = c("S", "N", "S", "N", "S", "N", "S", "N"),
  preditor = c(2.5, 1.2, 3.8, 1.5, 4.2, 1.0, 5.1, 0.8)
)

# Convertendo a variável resposta em fator com "N" como referência
dados$resposta <- factor(dados$resposta, levels = c("N", "S"))

# Ajuste do modelo
modelo <- glm(resposta ~ preditor, data = dados, family = binomial)

# Probabilidades preditas
dados$prob_pred <- predict(modelo, type = "response")

# Criando um intervalo para o preditor
novo_preditor <- seq(min(dados$preditor), max(dados$preditor), length.out = 100)

# Calculando as probabilidades
probabilidades <- predict(modelo, newdata = data.frame(preditor = novo_preditor), type = "response")

# Plotando a curva sigmoide
plot(novo_preditor, probabilidades, type = "l", col = "blue", lwd = 2,
     xlab = "Preditor", ylab = "Probabilidade de resposta = 'S'",
     main = "Curva Sigmoide da Regressão Logística")
