if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey)
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1
)
################################################################################
View(dadosOnda1)
glimpse(dadosOnda1)
################################################################################
###Ocorre um desbalancemaento das classes
###S    N 
###1652 3409
###Isso significa que há quase 2x mais "N" em relacao a "S"
################################################################################
dadosOnda1$hip <- relevel(dadosOnda1$hip, ref = "S")
table(dadosOnda1$hip)
summary(dadosOnda1$hip)
################################################################################
freq <- table(dadosOnda1$hip)
peso_classes <- ifelse(dadosOnda1$hip == "S", freq["N"] / freq["S"], 1)
################################################################################
mod <- glm(hip ~ pot + sod, 
           data = dadosOnda1, 
           family = binomial(link = 'logit'), 
           weights = peso_classes)
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
              family = binomial(link = 'logit'), 
              weights = peso_classes)
################################################################################
summary(modint)