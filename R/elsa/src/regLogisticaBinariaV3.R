if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, VIM, fpp)
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dadosRegLogistica.R")

################################################################################
#coluna <- dataGLM$sod_onda1
#Q1 <- quantile(coluna, 0.25)
#Q3 <- quantile(coluna, 0.75)
#IQR <- Q3 - Q1
#limite_inferior <- Q1 - 1.5 * IQR
#limite_superior <- Q3 + 1.5 * IQR
#outliers <- which(coluna < limite_inferior | coluna > limite_superior)
#dataGLM_sem_outliers <- dataGLM[-outliers,]
################################################################################
model2 <- glm(hip_onda1 ~ sod_onda1, 
              family = binomial(link="logit"), data = dataGLM, weights = ifelse(dataGLM$hip_onda1 == "S", 2, 1))
summary(stdres(model2))
################################################################################
dataGLM$predicted_hip_onda1 <- predict(model2, type="response")
plot(predicted_hip_onda1 ~ sod_onda1, data = dataGLM)

# Criar um gráfico para visualizar o modelo ajustado (Transmissão vs Peso)
ggplot(dataGLM, aes(x = sod_onda1, y = predicted_hip_onda1)) +
  geom_point() +
  geom_smooth(method = "lm", method.args = list(family = binomial), se = FALSE, color = "red") +
  labs(title = "Modelo de Regressão Logística: HAS vs Sodio",
       x = "Concentração de sódio",
       y = "Probabilidade de Presença de hipertensão Sistêmica")
