if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, VIM, fpp)
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dadosRegLogistica.R")

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
                            PAD = dataGLM$PAD_onda1_ajustado,
                            filtraGlo = dataGLM$filt_onda1)
summary(dataGLM_onda1)

levels(dataGLM$hip_onda1)
dataGLM$hip_onda1 <- relevel(dataGLM$hip_onda1, ref = "S")

model1 <- glm(hip ~ sod, 
             family = binomial(link="logit"), data = dataGLM_onda1, weights = ifelse(dataGLM_onda1$hip == "S", 2, 1))
summary(stdres(model1))
################################################################################
coluna <- dataGLM_onda1$sod
Q1 <- quantile(coluna, 0.25)
Q3 <- quantile(coluna, 0.75)
IQR <- Q3 - Q1
limite_inferior <- Q1 - 1.5 * IQR
limite_superior <- Q3 + 1.5 * IQR
outliers <- which(coluna < limite_inferior | coluna > limite_superior)
dataGLM_onda1_sem_outliers <- dataGLM_onda1[-outliers,]
################################################################################
model2 <- glm(hip ~ sod, 
              family = binomial(link="logit"), data = dataGLM_onda1_sem_outliers, weights = ifelse(dataGLM_onda1_sem_outliers$hip == "S", 2, 1))
summary(stdres(model2))
################################################################################
# Adicionar as previsões ao conjunto de dados original
dataGLM_onda1_sem_outliers$predicted_sod <- predict(logistic_model, type = "response")




dataGLM_onda1_sem_outliers$predicted_sod <- predict(model2, type = "response")

# Criar um gráfico para visualizar o modelo ajustado (Transmissão vs Peso)
ggplot(dataGLM_onda1_sem_outliers, aes(x = sod, y = predicted_sod)) +
  geom_point() +
  geom_smooth(method = "glm", method.args = list(family = binomial), se = FALSE, color = "red") +
  labs(title = "Modelo de Regressão Logística: Transmissão vs Peso",
       x = "Sodio",
       y = "Probabilidade de presença de hipertensão")

