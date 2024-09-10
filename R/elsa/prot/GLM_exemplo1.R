# Gerar dados de exemplo
set.seed(123)
n <- 100
x <- rnorm(n)
y <- rbinom(n, 1, prob = plogis(0.5 * x))

# Ajustar o modelo binomial (logístico)
modelo_binomial <- glm(y ~ x, family = binomial)

# Gerar gráficos de diagnóstico
par(mfrow = c(1, 2))  # Configura dois gráficos lado a lado
plot(modelo_binomial, which = 2)  # Q-Q Plot
plot(modelo_binomial, which = 1)  # Resíduos vs Ajustados


# Carregar as bibliotecas necessárias
library(ggplot2)
library(qqplotr)

# Suponha que modelo_binomial seja o seu modelo
# Extraia os resíduos
residuos <- residuals(modelo_binomial, type = "pearson")  # ou outro tipo apropriado

# Criar o gráfico Q-Q sem a linha de referência
ggplot(data = data.frame(residuos), aes(sample = residuos)) +
  stat_qq_point(size = 2, color = "blue") +  # Pontos Q-Q
  labs(title = "Gráfico Q-Q sem Linha de Referência", 
       x = "Quantis Teóricos", 
       y = "Resíduos") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14),  # Centralizar o título
        axis.title = element_text(size = 12))  # Ajustar tamanho dos títulos dos eixos
