# Instalar pacotes (se necessário)
# install.packages("ggplot2")
# install.packages("broom")

library(ggplot2)
library(broom)  # Para extrair os resíduos do modelo

# Ajustar o modelo binomial
set.seed(123)
n <- 100
x <- rnorm(n)
y <- rbinom(n, 1, prob = plogis(0.5 * x))
modelo_binomial <- glm(y ~ x, family = binomial)

# Extrair os resíduos padronizados
residuos <- augment(modelo_binomial, type.resid = "deviance")

# Gráfico Q-Q plot com ggplot2
ggplot(residuos, aes(sample = .resid)) +
  stat_qq() +  # Q-Q plot
  stat_qq_line() +  # Linha teórica
  geom_smooth(method = "loess", color = "red", se = FALSE) +  # Linha de ajuste flexível
  labs(title = "Q-Q plot com ajuste flexível", x = "Quantis Teóricos", y = "Resíduos Padronizados") +
  theme_minimal() +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") +  # Linha 1:1
  geom_ribbon(aes(ymin = -2, ymax = 2), fill = "lightgray", alpha = 0.2)  # Intervalo aceitável

