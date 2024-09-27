if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr,ggplot2)
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
glm1 <- glm(data = dadosOnda1, hip ~ sod + pot + sod:pot, family = binomial)
summary(glm1)
################################################################################
###Considerando o modelo nulo
glm_nulo <- glm(data = dadosOnda1, hip~1, family = binomial)
################################################################################
###Considerando o modelo sem a interacao
glm2 <- glm(data = dadosOnda1, hip ~ sod + pot, family = binomial)
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

# Pacotes necessários
library(ggplot2)
library(dplyr)

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

# Convertendo 'hip' para valores numéricos (0 = "N", 1 = "S")
dadosOnda1$hip_num <- ifelse(dadosOnda1$hip == "S", 1, 0)

# Criando o gráfico dos valores observados vs. preditos
ggplot(dadosOnda1, aes(x = predicted_prob, y = hip_num)) +
  geom_jitter(width = 0.05, height = 0.05, alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Valores Observados vs. Probabilidades Preditas",
       x = "Probabilidade Predita", y = "Valor Observado (0 = 'N', 1 = 'S')") +
  theme_minimal()

################################################################################

# Curvas de efeito marginal para sod e pot
effect_sod <- glm1$coefficients["sod"]
effect_pot <- glm1$coefficients["pot"]
effect_interaction <- glm1$coefficients["sod:pot"]

# Criando os gráficos
plot(dadosOnda1$sod, predict(glm1, newdata = dadosOnda1, type = "response"), 
     main = "Efeito do Sódio", xlab = "Sódio", ylab = "Probabilidade Predita")

plot(dadosOnda1$pot, predict(glm1, newdata = dadosOnda1, type = "response"), 
     main = "Efeito do Potássio", xlab = "Potássio", ylab = "Probabilidade Predita")

interaction_plot <- with(dadosOnda1, sod * pot)
plot(interaction_plot, predict(glm1, newdata = dadosOnda1, type = "response"), 
     main = "Interação entre Sódio e Potássio", 
     xlab = "Interação Sódio:Potássio", 
     ylab = "Probabilidade Predita")
