if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, VIM, fpp, nortest)
source("./src/script_analise_dados_elsa_Var_Lib.R")

################################################################################
# Exemplo de data frame com NA's
#df <- data.frame(
#  x = c(1, 2, NA, 4),
#  y = c(NA, 2, 3, 4)
#)
# Aplicando na.omit()
#df_clean <- na.omit(df)
#print(df_clean)
################################################################################
df_onda1 <- data.frame(HASOnda1 = presencaDeHipertensaoArterialSistemicaOnda1, sodOnda1 = sodioUrinaOnda1)
df_onda1 <- na.omit(df_onda1)
df_onda1$HASOnda1 <- factor(df_onda1$HASOnda1, label = c("N", "S"), levels = c(0, 1))
###Ajustando os dados desbalanceados
#### Valor de Lambda
lambda_onda1 <- BoxCox.lambda (df_onda1$sodOnda1, method=c("loglik"), lower=-4, upper= 4)
####Valores ajustados pela transformacao Box-Cox
df_onda1$sodOnda1Ajustada <- BoxCox(df_onda1$sodOnda1, lambda_onda1)
glimpse(df_onda1)
summary(df_onda1)
###GLM
model <- glm(HASOnda1 ~ sodOnda1Ajustada, 
             family = binomial(link="logit"), data = df_onda1)
fit <- step(model)
plot(model, which = 5)
summary(stdres(model))

### Interacao entre a VI continua e o seu log nao significativa (Box-Tidwell)

intlog <- df_onda1$sodOnda1Ajustada * log(df_onda1$sodOnda1Ajustada)

df_onda1$intlog <- intlog

modint <- glm(HASOnda1 ~  sodOnda1Ajustada + intlog,
              family = binomial(link = 'logit'), data = df_onda1)

summary(modint)
