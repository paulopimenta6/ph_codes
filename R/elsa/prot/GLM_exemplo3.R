# Instalar pacotes (se necessário)
# install.packages("ggplot2")
# install.packages("broom")

library(ggplot2)
library(broom)

# Ajustar o modelo binomial
set.seed(123)
n <- 100
x <- rnorm(n)
y <- rbinom(n, 1, prob = plogis(0.5 * x))
modelo_binomial <- glm(y ~ x, family = binomial)

# Extrair os resíduos padronizados
residuos <- augment(modelo_binomial, type.resid = "deviance")

# Calcular quantis teóricos e resíduos padronizados
qq_data <- qqnorm(residuos$.resid, plot.it = FALSE)
qq_data <- data.frame(
  quantis_teoricos = qq_data$x,
  residuos_padronizados = qq_data$y
)

# Criar o gráfico com ggplot2
ggplot(qq_data, aes(x = quantis_teoricos, y = residuos_padronizados)) +
  geom_point() +  # Pontos Q-Q
  geom_smooth(method = "loess", color = "red", se = FALSE) +  # Linha de ajuste flexível
  labs(title = "Q-Q plot com ajuste flexível", x = "Quantis Teóricos", y = "Resíduos Padronizados") +
  theme_minimal() +
  geom_ribbon(aes(ymin = -2, ymax = 2), fill = "lightgray", alpha = 0.2)  # Intervalo aceitável










