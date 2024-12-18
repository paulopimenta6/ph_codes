if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey, unbalanced)
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1
)

################################################################################
predictors <- dadosOnda1 ### Preservando o data frame original
#predictors <- sample_frac(predictors, .20)
predictors <- sample_frac(predictors, .10)

response <- ifelse(predictors$hip == 'N', 0, 1) ### 0 para N e 1 para S
response <- as.factor(response)

predictors <- predictors[, -which(names(predictors) == "hip")]
#table(response)

tmp <- ubSMOTE(predictors, response,
               perc.over = 500, k = 5, perc.under = 120)
smote_data <- cbind(tmp$X, tmp$Y)
names(smote_data)[which(names(smote_data)=='tmp$Y')] <- "hip"

smote_data$pot <- round(smote_data$pot,2)
smote_data$sod <- round(smote_data$sod,2)
smote_data <- data.frame(potassio = smote_data$pot,
                         sodio = smote_data$sod,
                         hipertensao = smote_data$hip
)
table(smote_data$hipertensao)
################################################################################
mod <- glm(hipertensao ~ potassio + sodio,
           family = binomial(link = 'logit'), 
           data = smote_data)
################################################################################
### Ausencia de outliers/Pontos de alavancagem
plot(mod, which = 5)
summary(stdres(mod))
################################################################################
### Verificando multicolinearidade
pairs.panels(smote_data)
vif(mod)
################################################################################
### Calculo do logito
logito <- mod$linear.predictors
################################################################################
### Potassio
ggplot(smote_data, aes(logito, potassio)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
### Sodio
ggplot(smote_data, aes(logito, sodio)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()