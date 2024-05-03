lm1 <- lm(pressaoArterialSistolicaMediaOnda2 ~ pressaoArterialSistolicaMediaOnda1, na.action=na.omit)
summary(lm1)
plot(pressaoArterialSistolicaMediaOnda2 ~ pressaoArterialSistolicaMediaOnda1)
abline(lm1)

dados <- data.frame(PAS_onda2 = pressaoArterialSistolicaMediaOnda2, PAS_onda1 = pressaoArterialSistolicaMediaOnda1)
# Criar o gráfico usando ggplot
ggplot(dados, aes(x = pressaoArterialSistolicaMediaOnda2, y = pressaoArterialSistolicaMediaOnda1)) +
  geom_point() +  # Adiciona os pontos ao gráfico
  geom_smooth(method = "lm", se = FALSE) +  # Adiciona a linha de regressão
  labs(x = "Pressão Arterial Sistólica Onda 1", y = "Pressão Arterial Sistólica Onda 2", title = "Regressão Linear entre PAS Onda 1 e PAS Onda 2")  # Adiciona rótulos aos eixos e título ao gráfico


t.test(dados$PAS_onda2, dados$PAS_onda1)