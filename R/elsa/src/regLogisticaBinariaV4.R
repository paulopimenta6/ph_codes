if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr,ggplot2, MASS)
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
dadosOnda1$hip <- relevel(dadosOnda1$hip, ref = "S")
################################################################################
# Considerando o modelo com a interação
glm1 <- glm(data = dadosOnda1, hip ~ sod + pot + sod:pot, family = binomial)
plot(glm1, which = 5)
title(main = "hip ~ sod + pot + sod:pot")
summary((glm1))
summary(stdres(glm1))
################################################################################
# Considerando o modelo sem a interação
glm2 <- glm(data = dadosOnda1, hip ~ sod + pot, family = binomial)
plot(glm2, which = 5)
title(main = "hip ~ sod + pot")
summary((glm2))
summary(stdres(glm2))
################################################################################
# Considerando o modelo somente com sódio
glm3 <- glm(data = dadosOnda1, hip ~ sod, family = binomial)
plot(glm3, which = 5)
title(main = "hip ~ sod")
summary((glm3))
summary(stdres(glm3))
################################################################################
# Considerando o modelo somente com potássio
glm4 <- glm(data = dadosOnda1, hip ~ pot, family = binomial)
plot(glm4, which = 5)
title(main = "hip ~ pot")
summary((glm4))
summary(stdres(glm4))
################################################################################
###Considerando o modelo nulo
glm_nulo <- glm(data = dadosOnda1, hip~1, family = binomial)

################################################################################
###O comportamento em principio não apresentou um padrao esperado, logo sera melhor remover os outliers para
###verificar o que pode ter influencia na amostra
outliers_pot <- boxplot(dadosOnda1$pot, plot=FALSE)$out
outlier_indices_pot <- which(dadosOnda1$pot %in% outliers_pot)

outliers_sod <- boxplot(dadosOnda1$sod, plot=FALSE)$out
outlier_indices_sod <- which(dadosOnda1$pot %in% outliers_pot)
################################################################################


################################################################################
###Comparando o modelo nulo com o modelo com interacao
anova(glm_nulo, glm1, test="Chisq")
###Comparando o modelo nulo com o modelo sem interacao
anova(glm_nulo, glm2, test="Chisq")
###Comparando o modelo sem interacao com o modelo com interacao
anova(glm2, glm1, test="Chisq")
################################################################################
coef(glm1) ###coeficiente na escala do preditor linear
exp(coef(glm1)) ###Exponenciando os coeficiente na escala do preditor linear
logit_values <- predict(glm1, type = "link")
predicted_probabilities <- predict(glm1, type = "response")
head(logit_values)
head(predicted_probabilities)
################################################################################

# Adicionando as probabilidades preditas ao dataframe
dadosOnda1$predicted_prob <- predict(glm1, type = "response")

# Criando o gráfico das probabilidades preditas
ggplot(dadosOnda1, aes(x = sod, y = predicted_prob, color = pot)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Probabilidades Preditas de Hipertensão (hip = 'S')",
       x = "Sódio (sod)", y = "Probabilidade Predita", color = "Potássio (pot)") +
  theme_minimal()

################################################################################