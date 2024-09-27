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
################################################################################
dadosOnda1$logSod <- log(dadosOnda1$sod)
dadosOnda1$rootSod <- sqrt(dadosOnda1$sod)
#boxplot(dadosOnda1$sod)
#boxplot(logSod)
#boxplot(rootSod)
#hist(dadosOnda1$sod)
#hist(logSod)
#hist(rootSod)
###A transformacao em raiz quadradada ganhou das demais e aproxima os valores do sodio em quase uma distribuicao normal
dadosOnda1$logPot <- log(dadosOnda1$pot)
dadosOnda1$rootPot <- sqrt(dadosOnda1$pot)
#boxplot(dadosOnda1$pot)
#boxplot(logPot)
#boxplot(rootPot)
#hist(dadosOnda1$pot)
#hist(logPot)
#hist(rootPot)
################################################################################
################################################################################
###Combinacao sodRoot e potLog
################################################################################
################################################################################
###A transformação log e a melhor para o Potassio e o aproxima de uma distribuicao quase normal
################################################################################
m1nulo <- glm(data = dadosOnda1, (hip/ntotal)~1, family = binomial, weights = ntotal)
m1 <- glm(data = dadosOnda1, (hip/ntotal) ~ rootSod, family = binomial, weights = ntotal)
m2 <- glm(data = dadosOnda1, (hip/ntotal) ~ rootSod + logPot, family = binomial, weights = ntotal)
m3 <- glm(data = dadosOnda1, (hip/ntotal) ~ rootSod * logPot, family = binomial, weights = ntotal)
m4 <- glm(data = dadosOnda1, (hip/ntotal) ~ rootSod + logPot + rootSod * logPot, family = binomial, weights = ntotal)
################################################################################
###Anova com m1nulo e m1, m2, m3 e m4
anova(m1nulo, m1, test="Chisq")
################################################################################
anova(m1nulo, m2, test="Chisq")
################################################################################
anova(m1nulo, m3, test="Chisq")
################################################################################
anova(m1nulo, m4, test="Chisq")
################################################################################
###Anova para verificar se e possivel simplificar o modelo
anova(m1, test="Chisq")
################################################################################
anova(m2, test="Chisq")
################################################################################
anova(m3, test="Chisq")
################################################################################
anova(m4, test="Chisq")
################################################################################

################################################################################
################################################################################
###Combinacao rootSod e rootPot
################################################################################
################################################################################
###A transformação log e a melhor para o Potassio e o aproxima de uma distribuicao quase normal
################################################################################
m1nuloroot <- glm(data = dadosOnda1, (hip/ntotal)~1, family = binomial, weights = ntotal)
m1root <- glm(data = dadosOnda1, (hip/ntotal) ~ rootSod, family = binomial, weights = ntotal)
m2root <- glm(data = dadosOnda1, (hip/ntotal) ~ rootSod + rootPot, family = binomial, weights = ntotal)
m3root <- glm(data = dadosOnda1, (hip/ntotal) ~ rootSod * rootPot, family = binomial, weights = ntotal)
m4root <- glm(data = dadosOnda1, (hip/ntotal) ~ rootSod + rootPot + rootSod * rootPot, family = binomial, weights = ntotal)
################################################################################
###Anova com m1nulo e m1, m2, m3 e m4
anova(m1nuloroot, m1root, test="Chisq")
################################################################################
anova(m1nuloroot, m2root, test="Chisq")
################################################################################
anova(m1nuloroot, m3root, test="Chisq")
################################################################################
anova(m1nuloroot, m4root, test="Chisq")
################################################################################
###Anova para verificar se e possivel simplificar o modelo
anova(m1root, test="Chisq")
################################################################################
anova(m2root, test="Chisq")
################################################################################
anova(m3root, test="Chisq")
################################################################################
anova(m4root, test="Chisq")
################################################################################


################################################################################
################################################################################
###Combinacao logSod e logPot
################################################################################
################################################################################
###A transformação log e a melhor para o Potassio e o aproxima de uma distribuicao quase normal
################################################################################
m1nulolog <- glm(data = dadosOnda1, (hip/ntotal)~1, family = binomial, weights = ntotal)
m1log <- glm(data = dadosOnda1, (hip/ntotal) ~ logSod, family = binomial, weights = ntotal)
m2log <- glm(data = dadosOnda1, (hip/ntotal) ~ logSod + logPot, family = binomial, weights = ntotal)
m3log <- glm(data = dadosOnda1, (hip/ntotal) ~ logSod * logPot, family = binomial, weights = ntotal)
m4log <- glm(data = dadosOnda1, (hip/ntotal) ~ logSod + logPot + logSod * logPot, family = binomial, weights = ntotal)
################################################################################
###Anova com m1nulo e m1, m2, m3 e m4
anova(m1nulolog, m1log, test="Chisq")
################################################################################
anova(m1nulolog, m2log, test="Chisq")
################################################################################
anova(m1nulolog, m3log, test="Chisq")
################################################################################
anova(m1nulolog, m4log, test="Chisq")
################################################################################
###Anova para verificar se e possivel simplificar o modelo
anova(m1log, test="Chisq")
################################################################################
anova(m2log, test="Chisq")
################################################################################
anova(m3log, test="Chisq")
################################################################################
anova(m4log, test="Chisq")
################################################################################




