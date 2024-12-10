if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey, ROSE)
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1
)

### 2. Undersampling
### Reduz o número de observações da classe majoritária para se igualar à classe minoritária.
### Undersampling para balancear as classes
dados_balanceados_undersampling <- ovun.sample(hip ~ ., data = dadosOnda1, method = "under")$data
### Verifique a distribuição das classes
table(dados_balanceados_undersampling$hip)

################################################################################
### Construcao do modelo
mod <- glm(hip ~ pot + sod,
           family = binomial(link = 'logit'), data = dados_balanceados_undersampling)
### Ausencia de outliers/Pontos de alavancagem
plot(mod, which = 5)
summary(stdres(mod))
### Verificando multicolinearidade
pairs.panels(dados_balanceados_undersampling)
vif(mod)
### Interacao entre a VI cont?nua e o seu log nao significativa (Box-Tidwell)
intlog_pot <- dados_balanceados_undersampling$pot * log(dados_balanceados_undersampling$pot)
dados_balanceados_undersampling$intlog_pot <- intlog_pot

intlog_sod <- dados_balanceados_undersampling$sod * log(dados_balanceados_undersampling$sod)
dados_balanceados_undersampling$intlog_sod <- intlog_sod

modint <- glm(hip ~ pot + sod + intlog_pot + intlog_sod,
              family = binomial(link = 'logit'), data = dados_balanceados_undersampling)

summary(modint)
### Calculo do logito
logito <- mod$linear.predictors
################################################################################
### Analise da relaco linear
# Potassio
ggplot(dados_balanceados_undersampling, aes(logito, pot)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
# Sodio
ggplot(dados_balanceados_undersampling, aes(logito, sod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()

### Considerando o modelo original inicial e a probabilidade calculada para sodio e potassio
dados_balanceados_undersampling$prob_predita_mod <- predict(mod, type = "response")

# Visualizando as probabilidades em relação a 'pot'
ggplot(dados_balanceados_undersampling, aes(x = pot, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Potássio (pot)", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()

# Visualizando as probabilidades em relação a 'sod'
ggplot(dados_balanceados_undersampling, aes(x = sod, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Sódio (sod)", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()
################################################################################
### Analise do modelo
### Overall effects
Anova(mod, type = 'II', test = "Wald")
### Efeitos especificos
summary(mod)
### Obtencao das razoes de chance com IC 95% (usando erro padrao = SPSS)
exp(cbind(OR = coef(mod), confint.default(mod)))
### Criacao e analise de dois outros modelos usando somente potassio e somente sodio
mod2 <- glm(hip ~ pot,
            family = binomial(link = 'logit'), data = dados_balanceados_undersampling)
mod3 <- glm(hip ~ sod,
            family = binomial(link = 'logit'), data = dados_balanceados_undersampling)

### Overall effects
# Potassio
Anova(mod2, type="II", test="Wald")
# Sodio
Anova(mod3, type="II", test="Wald")
### Efeitos especificos
# Potassio
summary(mod2)
# Sodio
summary(mod3)
## Obtencao das raz?es de chance com IC 95% (usando erro padrao = SPSS)
# Potassio
exp(cbind(OR = coef(mod2), confint.default(mod2)))
# Sodio
exp(cbind(OR = coef(mod3), confint.default(mod3)))
# Tabela de classificacao
ClassLog(mod, dados_balanceados_undersampling$hip)