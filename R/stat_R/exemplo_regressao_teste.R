# Vetores originais
a <- c(1, 2, 3, 4, 5, NA, 9)
b <- c(2, 3, 5, 6, NA, NA, NA)

# Removendo os NA de ambos os vetores
dados <- na.omit(data.frame(a, b))

# Realizando a regressão linear
modelo <- lm(b ~ a, data = dados)

# Coeficientes do modelo
coeficientes <- coef(modelo)

# Plot com a curva de ajuste
plot(dados$a, dados$b, pch = 16, col = "blue", main = "Regressão Linear", xlab = "a", ylab = "b")

# Adicionar a curva de ajuste ao plot
abline(modelo, col = "red")

# Obter a equação da função e o R²
eq <- paste("b =", format(coef(modelo)[1], digits = 2), "+", format(coef(modelo)[2], digits = 2), "* a",
            "\nR² =", format(summary(modelo)$r.squared, digits = 3))

# Adicionar a legenda no plot
legend("topright", legend = eq, bty = "n")
