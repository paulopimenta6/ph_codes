if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, VIM)
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dadosRegLogistica.R")

###Analisando os dados
#view(presencaHipertensaoSistem_interp)
glimpse(dataGLM_Hip_PAS_Onda1)

###Fazendo uma analise exploratoria
#table(dataGLM_Hip_PAS_Onda1$hip_onda1)

###Um conjunto de dados geralmente é considerado desbalanceado quando uma das classes 
###representa menos de 10% a 20% do total de observações.
###Neste caso, a classe S representa aproximadamente 32.7% dos dados, enquanto a classe N representa 67.3%.

mod_Hip_PAS_Onda1 <- glm(data = dataGLM_Hip_PAS_Onda1, Hip ~ PAS, family = binomial(link = "logit"))
mod_Hip_PAS_Onda2 <- glm(data = dataGLM_Hip_PAS_Onda2, Hip ~ PAS, family = binomial(link = "logit"))
mod_Hip_PAS_Onda3 <- glm(data = dataGLM_Hip_PAS_Onda3, Hip ~ PAS, family = binomial(link = "logit"))

plot(mod_Hip_PAS_Onda1, which = 5)
plot(mod_Hip_PAS_Onda2, which = 5)
plot(mod_Hip_PAS_Onda3, which = 5)

mod_Hip_PAD_Onda1 <- glm(data = dataGLM_Hip_PAD_Onda1, Hip ~ PAD, family = binomial(link = "logit"))
mod_Hip_PAD_Onda2 <- glm(data = dataGLM_Hip_PAD_Onda2, Hip ~ PAD, family = binomial(link = "logit"))
mod_Hip_PAD_Onda3 <- glm(data = dataGLM_Hip_PAD_Onda3, Hip ~ PAD, family = binomial(link = "logit"))

plot(mod_Hip_PAD_Onda3, which = 5)
plot(mod_Hip_PAD_Onda1, which = 5)
plot(mod_Hip_PAD_Onda3, which = 5)

################################################################################
intlog_PAS1 <- dataGLM_Hip_PAS_Onda1$PAS*log(dataGLM_Hip_PAS_Onda1$PAS)
intlog_PAS2 <- dataGLM_Hip_PAS_Onda2$PAS*log(dataGLM_Hip_PAS_Onda2$PAS)
intlog_PAS3 <- dataGLM_Hip_PAS_Onda3$PAS*log(dataGLM_Hip_PAS_Onda3$PAS)

intlog_PAD1 <- dataGLM_Hip_PAD_Onda1$PAD*log(dataGLM_Hip_PAD_Onda1$PAD)
intlog_PAD2 <- dataGLM_Hip_PAD_Onda2$PAD*log(dataGLM_Hip_PAD_Onda2$PAD)
intlog_PAD3 <- dataGLM_Hip_PAD_Onda3$PAD*log(dataGLM_Hip_PAD_Onda3$PAD)

dataGLM_Hip_PAS_Onda1$intlog1 <- intlog_PAS1
dataGLM_Hip_PAS_Onda2$intlog2 <- intlog_PAS2
dataGLM_Hip_PAS_Onda3$intlog3 <- intlog_PAS3

dataGLM_Hip_PAD_Onda1$intlog1 <- intlog_PAD1
dataGLM_Hip_PAD_Onda2$intlog2 <- intlog_PAD2
dataGLM_Hip_PAD_Onda3$intlog3 <- intlog_PAD3