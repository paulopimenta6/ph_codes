if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey)
#source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1
)
################################################################################
View(dadosOnda1)
glimpse(dadosOnda1)
################################################################################
table(dadosOnda1$hip)
summary(dadosOnda1$hip)
################################################################################
freq <- table(dadosOnda1$hip)
peso_classes <- ifelse(dadosOnda1$hip == "S", freq["N"] / freq["S"], 1)
################################################################################
mod <- glm(hip ~ pot + sod, 
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
### Multicolinearidade: r > 0.9 (ou 0.8)
vif(mod)
### Multicolinearidade: VIF > 10
################################################################################
###Teste de Box-Tidwell
intolog_pot <- dadosOnda1$pot*log(dadosOnda1$pot)
intolog_sod <- dadosOnda1$sod*log(dadosOnda1$sod)

dadosOnda1$intolog_pot <- intolog_pot
dadosOnda1$intolog_sod <- intolog_sod
################################################################################
modint <- glm(hip ~ pot + sod + dadosOnda1$intolog_pot + dadosOnda1$intolog_sod, 
              data = dadosOnda1, 
              family = binomial(link = 'logit')
)
################################################################################
summary(modint)
################################################################################
logito <- modint$linear.predictors
################################################################################
#### Analise da relaca linear

ggplot(dadosOnda1, aes(logito, sod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()

ggplot(dadosOnda1, aes(logito, pot)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
################################################################################
### Considerando o modelo original inicial
dadosOnda1$prob_predita_mod <- predict(mod, type = "response")

# Visualizando as probabilidades em relação a 'pot'
ggplot(dadosOnda1, aes(x = pot, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Potássio (pot)", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()

# Visualizando as probabilidades em relação a 'sod'
ggplot(dadosOnda1, aes(x = sod, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Sódio (sod)", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()