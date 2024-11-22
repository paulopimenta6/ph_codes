if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey, dbscan, fpp)
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pas = dataGLM$PAS_onda1,
                         pad = dataGLM$PAD_onda1)
################################################################################
################################################################################
#View(dadosOnda1)
glimpse(dadosOnda1)
################################################################################
table(dadosOnda1$hip)
summary(dadosOnda1$hip)
################################################################################
### Considerando a interação entre pas e pad: pas + pad
################################################################################
mod <- glm(hip ~ pas + pad, 
           data = dadosOnda1, 
           family = binomial(link = 'logit')
)
################################################################################
summary(mod)
################################################################################
plot(mod, which = 5)
summary(stdres(mod))
################################################################################
###Ausencia de multicolinearidade
pairs.panels(dadosOnda1)
### Multicolinearidade: r > 0.9
vif(mod)
### Multicolinearidade: VIF > 10
################################################################################
###Teste de Box-Tidwell
intolog_pas <- dadosOnda1$pas*log(dadosOnda1$pas)
intolog_pad <- dadosOnda1$pad*log(dadosOnda1$pad)

dadosOnda1$intolog_pas <- intolog_pas
dadosOnda1$intolog_pad <- intolog_pad
################################################################################
modint <- glm(hip ~ pad + pas + dadosOnda1$intolog_pas + dadosOnda1$intolog_pad, 
              data = dadosOnda1, 
              family = binomial(link = 'logit')
)
################################################################################
summary(modint)
################################################################################
logito <- modint$linear.predictors
################################################################################
#### Analise da relaca linear

ggplot(dadosOnda1, aes(logito, pas)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()

ggplot(dadosOnda1, aes(logito, pad)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
################################################################################
### Considerando o modelo original inicial e a probabilidade calculada para pas e pad
dadosOnda1$prob_predita_mod <- predict(mod, type = "response")

# Visualizando as probabilidades em relação a 'pas'
ggplot(dadosOnda1, aes(x = pas, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "PAS", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()

# Visualizando as probabilidades em relação a 'sod'
ggplot(dadosOnda1, aes(x = pad, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "PAD", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()
################################################################################
################################################################################


