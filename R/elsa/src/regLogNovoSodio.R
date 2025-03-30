if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2)
source("./src/script_analise_dados_elsa_Var_Lib.R")
################################################################################
dadosOnda1 <- data.frame(
  hip_onda1 = presencaDeHipertensaoArterialSistemicaOnda1,
  sod_onda1 = sodioUrinaOnda1
)
dadosOnda1 <- na.omit(dadosOnda1)
dadosOnda1$hip_onda1 <- ifelse(dadosOnda1$hip_onda1 == 0, 'N', 'S')
dadosOnda1$hip_onda1 <- factor(dadosOnda1$hip_onda1)
dadosOnda1$hip_onda1 <- relevel(dadosOnda1$hip_onda1, 'S')
################################################################################
View(dadosOnda1)
glimpse(dadosOnda1)

table(dadosOnda1$hip_onda1)
summary(dadosOnda1)
levels(dadosOnda1$hip_onda1)
################################################################################
## #Criacao de modelo
mod <- glm(hip_onda1 ~ sod_onda1, family = binomial(link = 'logit'), data = dadosOnda1)
plot(mod, which = 5)
summary(stdres(mod))

# Teste de Razão de Verossimilhança (Comparação entre Modelos)
mod_nulo <- glm(hip_onda1 ~ 1, data = dadosOnda1, family = binomial())

anova(mod_nulo, mod, test = "Chisq")
################################################################################
### Multicolinearidade: r > 0.9 (ou 0.8)
pairs.panels(dadosOnda1)

### Interacao entre a VI continua e o seu log nao significativa (Box-Tidwell)
intlog <- dadosOnda1$sod_onda1 * log(dadosOnda1$sod_onda1)
dadosOnda1$intlog <- intlog
modint <- glm(hip_onda1 ~ sod_onda1 + intlog, family = binomial(link = 'logit'), data = dadosOnda1)

summary(modint)
### Outra opcao:
#### Calculo do logito
logito <- mod$linear.predictors

dadosOnda1$logito <- logito

#### Analise da relacao linear
ggplot(dadosOnda1, aes(logito, sod_onda1)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Logito", y = "Sodio na onda 1") +
  theme_classic()
################################################################################
# Analise do modelo
## Overall effects
Anova(mod, type = 'II', test = "Wald")

## Efeitos especificos
summary(mod)

## Obtencao das razoes de chance com IC 95% (usando log-likelihood)
exp(cbind(OR = coef(mod), confint(mod)))

## Pseudo R-quadrado
PseudoR2(mod, which = "Nagelkerke")
################################################################################