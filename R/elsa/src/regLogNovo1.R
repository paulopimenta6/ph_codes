if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, ggplot2)
source("./src/script_analise_dados_elsa_Var_Lib.R")

dadosOnda1 <- data.frame(
  hip_onda1 = presencaDeHipertensaoArterialSistemicaOnda1,
  pot_onda1 = potassioOnda1
)

dadosOnda1 <- na.omit(dadosOnda1)
dadosOnda1$hip_onda1 <- as.integer(dadosOnda1$hip_onda1)

dplyr::glimpse(dadosOnda1)
mod <- glm(hip_onda1 ~ pot_onda1, data = dadosOnda1, family = binomial())
summary(mod)

plot(hip_onda1 ~ pot_onda1, data = dadosOnda1, col = "blue")
curve(exp(mod$coef[1] + mod$coef[2]*x)/(1+exp(mod$coef[1] + mod$coef[2]*x)),
      add = TRUE,
      col = "firebrick", lwd = 2)

ggplot(data = dadosOnda1, aes(pot_onda1, hip_onda1))+
                  geom_point(col = "aquamarine3", alpha=0.25)+
                  geom_smooth(method = "glm", method.args = list(family = "binomial"),
                              col = "firebrick", fill = "firebrick1")+
                  labs(x = "Potassio", y = "Probabilidade de ser Hipertenso")+
                  theme_bw()