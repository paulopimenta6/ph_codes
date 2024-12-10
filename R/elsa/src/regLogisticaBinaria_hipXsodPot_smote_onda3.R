if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey)
source("./src/dadosRegLogistica.R")

dadosOnda3 <- data.frame(hip = dataGLM$hip_onda3,
                         pot = dataGLM$pot_onda3,
                         sod = dataGLM$sod_onda3
)
################################################################################
View(dadosOnda3)
glimpse(dadosOnda3)
################################################################################
table(dadosOnda3$hip)
summary(dadosOnda3$hip)
################################################################################
mod <- glm(hip ~ pot + sod, 
           data = dadosOnda3, 
           family = binomial(link = 'logit')
)
################################################################################
###summary(mod)
################################################################################
plot(mod, which = 5)
summary(stdres(mod))
################################################################################
###Ausencia de multicolinearidade
pairs.panels(dadosOnda3)
### Multicolinearidade: r > 0.9 (ou 0.8)
vif(mod)
### Multicolinearidade: VIF > 10
################################################################################
###Teste de Box-Tidwell
intolog_pot <- dadosOnda3$pot*log(dadosOnda3$pot)
intolog_sod <- dadosOnda3$sod*log(dadosOnda3$sod)

dadosOnda3$intolog_pot <- intolog_pot
dadosOnda3$intolog_sod <- intolog_sod
################################################################################
modint <- glm(hip ~ pot + sod + dadosOnda3$intolog_pot + dadosOnda3$intolog_sod, 
              data = dadosOnda3, 
              family = binomial(link = 'logit'),
              weights = ifelse(dadosOnda3$hip == "S", 2, 1)
)
################################################################################
summary(modint)
################################################################################
logito <- modint$linear.predictors
################################################################################
#### Analise da relacao linear

ggplot(dadosOnda3, aes(logito, sod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()

ggplot(dadosOnda3, aes(logito, pot)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
################################################################################
### Considerando o modelo original inicial e a probabilidade calculada para sodio e potassio
dadosOnda3$prob_predita_mod <- predict(mod, type = "response")

# Visualizando as probabilidades em relação a 'pot'
ggplot(dadosOnda3, aes(x = pot, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Potássio (pot)", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()

# Visualizando as probabilidades em relação a 'sod'
ggplot(dadosOnda3, aes(x = sod, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Sódio (sod)", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()
################################################################################
### Analise do modelo
### Overall effects
Anova(mod, type = 'II', test = "Wald")

### Efeitos especificos
summary(mod)

## Obtencao das razoes de chance com IC 95% (usando erro padrao = SPSS)
exp(cbind(OR = coef(mod), confint.default(mod)))
################################################################################
### Modelos somente com uma variável independente
mod2 <- glm(hip ~ sod,
            family = binomial(link = 'logit'), data = dadosOnda3)

mod3 <- glm(hip ~ pot,
            family = binomial(link = 'logit'), data = dadosOnda3)
################################################################################
summary(mod2) #Sumario do modelo somente com sodio
################################################################################
summary(mod3) #sumario do modelo somente com potassio
################################################################################
### Pseudo R-quadrado
PseudoR2(mod, which = "Nagelkerke")
### Tabela de classificacao
ClassLog(mod, dadosOnda3$hip)
################################################################################