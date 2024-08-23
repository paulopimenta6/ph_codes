if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, VIM, fpp)
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dadosRegLogistica.R")

###Analisando os dados
#view(presencaHipertensaoSistem_interp)
#glimpse(dataGLM_Hip_PAS_Onda1)

###Fazendo uma analise exploratoria
#table(dataGLM$hip_onda1)
#summary(dataGLM)

###Ajustando os dados desbalanceados
#### Valor de Lambda
lambda_pot_onda1 <- BoxCox.lambda (dataGLM$pot_onda1, method=c("loglik"), lower=-3, upper= 3) 
lambda_sod_onda1 <- BoxCox.lambda (dataGLM$sod_onda1, method=c("loglik"), lower=-3, upper= 3)
lambda_albCreat_onda1 <- BoxCox.lambda (dataGLM$albCreat_onda1, method=c("loglik"), lower=-3, upper= 3)
lambda_PAS_onda1 <- BoxCox.lambda (dataGLM$PAS_onda1, method=c("loglik"), lower=-3, upper= 3)
lambda_PAD_onda1 <- BoxCox.lambda (dataGLM$PAD_onda1, method=c("loglik"), lower=-3, upper= 3)
####Valores ajustados pela transformacao Box-Cox
dataGLM$pot_onda1_ajustado <- BoxCox(dataGLM$pot_onda1, lambda_pot_onda1)
dataGLM$sod_onda1_ajustado <- BoxCox(dataGLM$pot_onda1, lambda_sod_onda1)
dataGLM$albCreat_onda1_ajustado <- BoxCox(dataGLM$pot_onda1, lambda_albCreat_onda1)
dataGLM$PAS_onda1_ajustado <- BoxCox(dataGLM$pot_onda1, lambda_PAS_onda1)
dataGLM$PAD_onda1_ajustado <- BoxCox(dataGLM$pot_onda1, lambda_PAD_onda1)

dataGLM_onda1 <- data.frame(hip = dataGLM$hip_onda1, 
                            pot = dataGLM$pot_onda1_ajustado,
                            sod = dataGLM$sod_onda1_ajustado,
                            albCreat = dataGLM$albCreat_onda1_ajustado,
                            PAS = dataGLM$PAS_onda1_ajustado,
                            PAD = dataGLM$PAD_onda1_ajustado)
summary(dataGLM_onda1)

#levels(dataGLM$hip_onda1)
#dataGLM$hip_onda1 <- relevel(dataGLM$hip_onda1, ref = "S")
model <- glm(hip ~ pot + sod + albCreat + PAS + PAD, 
             family = binomial(link="logit"), data = dataGLM_onda1, weights = ifelse(dataGLM_onda1$hip == "S", 2, 1))
#fit <- step(model)
plot(model, which = 5)
summary(stdres(model))
################################################################################
