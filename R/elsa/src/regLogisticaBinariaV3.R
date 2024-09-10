if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr,ggplot2, car, fpp, MASS)
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dadosRegLogistica.R")
source("./src/rdiagnostic.R")

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
idx1 <- which(dadosOnda1$pas<=160)
dadosOnda2 <- data.frame(hip = dadosOnda1$hip[idx1],
                         pas = dadosOnda1$pas[idx1],
                         ntotal = dadosOnda1$ntotal[idx1]
                         )
boxplot(dadosOnda2$pas)                        
################################################################################
head(dadosOnda2$pas)
str(dadosOnda2$pas)
boxplot(dadosOnda2$pas)
################################################################################
lambda <- BoxCox.lambda (dadosOnda2$pas, method=c("loglik"), lower=-3, upper= 3)
dadosOnda2$pas_boxcox <- BoxCox (dadosOnda2$pas, lambda) ## Transformação Box-Cox
attr(dadosOnda2$pas_boxcox, "lambda") <- NULL
################################################################################
boxplot(dadosOnda2$pas_boxcox)
################################################################################
m1 <- glm(data = dadosOnda2, (hip/ntotal)~pas_boxcox, family = binomial, weights = ntotal)
m1nulo <- glm(data = dadosOnda2, (hip/ntotal)~1, family = binomial, weights = ntotal)
################################################################################
summary(stdres(m1))
residuals_std <- rstandard(m1)
anova(m1nulo, m1, test="Chisq")
anova(m1, test="Chisq")
################################################################################
# Gerar gráficos de diagnóstico
par(mfrow = c(1, 3))  # Configura dois gráficos lado a lado
plot(m1, which = 2)  # Q-Q Plot
plot(m1, which = 1)  # Resíduos vs Ajustados
plot(m1, which = 5)





