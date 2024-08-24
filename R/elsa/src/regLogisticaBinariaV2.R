if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, VIM, broom, fpp)
source("./src/script_analise_dados_elsa_Var_Lib.R")

df_onda1 <- data.frame(HASOnda1 = presencaDeHipertensaoArterialSistemicaOnda1, sodOnda1 = sodioUrinaOnda1)
df_onda1 <- na.omit(df_onda1)
df_onda1$HASOnda1 <- factor(df_onda1$HASOnda1, label = c("N", "S"), levels = c(0, 1))

###Ajustando os dados desbalanceados
#### Valor de Lambda
lambda_onda1 <- BoxCox.lambda (df_onda1$sodOnda1, method=c("loglik"), lower=-3, upper= 3)

####Valores ajustados pela transformacao Box-Cox
df_onda1$sodOnda1Ajustada <- BoxCox(df_onda1$sodOnda1, lambda_onda1)

###GLM
model1 <- glm(HASOnda1 ~ sodOnda1Ajustada, 
             family = binomial(link="logit"), 
             data = df_onda1)#,
             #weights = ifelse(df_onda1$HASOnda1 == "S", 2, 1))

plot(model1, which = 5)
modelo_augmented <- augment(model1)
ggplot(modelo_augmented, aes(x = .cooksd, y = .std.resid)) +
  geom_point(aes(color = factor(HASOnda1)), alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  geom_vline(xintercept = 4 / nrow(df_onda1), linetype = "dashed", color = "blue") +
  labs(x = "Leverage", y = "Resíduos Padronizados", title = "Gráfico de Residuals vs Leverage") +
  theme_minimal()
summary(stdres(model1))

### Interacao entre a VI continua e o seu log nao significativa (Box-Tidwell)

intlog <- df_onda1$sodOnda1Ajustada * log(df_onda1$sodOnda1Ajustada)

df_onda1$intlog <- intlog

modint <- glm(HASOnda1 ~  sodOnda1Ajustada + intlog,
              family = binomial(link = 'logit'), data = df_onda1)

summary(modint)
