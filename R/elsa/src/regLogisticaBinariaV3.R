if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, VIM, fpp, car)
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1,
                         albCreat = dataGLM$albCreat_onda1,
                         pas = dataGLM$PAS_onda1,
                         pad = dataGLM$PAD_onda1,
                         filt = dataGLM$filt_onda1
)

###Transformacao de hip em variavel dummy para usar proporcao
dadosOnda1$hip <- ifelse(dadosOnda1$hip == "S", 1, 0)
dadosOnda1$ntotal <- 1
################################################################################
head(dadosOnda1)
str(dadosOnda1)
summary(dadosOnda1)
################################################################################
m1 <- glm(data = dadosOnda1, (hip/ntotal)~pot*sod*albCreat*pas*pad*filt, family = binomial, weights = ntotal, control = glm.control(maxit = 50))
m1_simples <- glm(data = dadosOnda1, (hip/ntotal) ~ pot + sod + albCreat + pas + pad + filt, family = binomial, weights = ntotal)
m1nulo <- glm((hip/ntotal)~1, family = binomial, weights = ntotal)

anova(m1nulo, m1, test="Chisq")
anova(m1, test="Chisq")
vif(m1)
anova(m1nulo, m1_simples, test="Chisq")
vif(m1_simples)
anova(m1_simples, test="Chisq")