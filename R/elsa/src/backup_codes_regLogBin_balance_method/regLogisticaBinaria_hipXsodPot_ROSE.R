if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey, ROSE)
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1
)

### 4. ROSE (Random OverSampling Examples)
### O ROSE é uma técnica que gera novas amostras sintéticas para balancear as classes. 
### Ele utiliza um processo de sobreamostragem aleatória para a classe minoritária 
### e subamostragem para a classe majoritária, combinados com um processo de geração 
### de amostras sintéticas próximas aos dados originais.

### Como funciona o ROSE?
# - Baseia-se na estimação de densidade de probabilidade para criar exemplos sintéticos.
# - Os exemplos são gerados adicionando pequenos valores de ruído a partir de uma distribuição normal ao redor das observações existentes.
# - O objetivo é melhorar a representatividade da classe minoritária no conjunto de dados.
### Vantagens do ROSE
# - Pode ser usado com variáveis contínuas ou categóricas.
# - Introduz uma variabilidade natural nos exemplos sintéticos, evitando duplicação exata de observações.
dados_balanceados_rose <- ROSE(hip ~ ., data = dadosOnda1, seed = 123)$data
table(dados_balanceados_rose$hip)

################################################################################
### Usando o modelo Oversampling e Undersampling Combinados
### Construcao do modelo
mod <- glm(hip ~ pot + sod,
           family = binomial(link = 'logit'), data = dados_balanceados_rose)
### Ausencia de outliers/Pontos de alavancagem
plot(mod, which = 5)
summary(stdres(mod))
### Verificando multicolinearidade
pairs.panels(dados_balanceados_rose)
vif(mod)
### Interacao entre a VI cont?nua e o seu log nao significativa (Box-Tidwell)
intlog_pot <- dados_balanceados_rose$pot * log(dados_balanceados_rose$pot)
dados_balanceados_rose$intlog_pot <- intlog_pot

intlog_sod <- dados_balanceados_rose$sod * log(dados_balanceados_rose$sod)
dados_balanceados_rose$intlog_sod <- intlog_sod

modint <- glm(hip ~ pot + sod + intlog_pot + intlog_sod,
              family = binomial(link = 'logit'), data = dados_balanceados_rose)

summary(modint)
### Calculo do logito
logito <- mod$linear.predictors
### Analise da relaco linear
# Potassio
ggplot(dados_balanceados_rose, aes(logito, pot)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
# Sodio
ggplot(dados_balanceados_rose, aes(logito, sod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
### Analise do modelo
### Overall effects
Anova(mod, type = 'II', test = "Wald")
### Efeitos especificos
summary(mod)
### Obtencao das razoes de chance com IC 95% (usando erro padrao = SPSS)
exp(cbind(OR = coef(mod), confint.default(mod)))
### Criacao e analise de dois outros modelos usando somente potassio e somente sodio
mod2 <- glm(hip ~ pot,
            family = binomial(link = 'logit'), data = dados_balanceados_rose)
mod3 <- glm(hip ~ sod,
            family = binomial(link = 'logit'), data = dados_balanceados_rose)

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
ClassLog(mod, dados_balanceados_rose$hip)