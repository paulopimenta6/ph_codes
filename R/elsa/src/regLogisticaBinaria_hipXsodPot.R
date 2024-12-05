if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey, smotefamily, ROSE)
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1
)
################################################################################
View(dadosOnda1)
glimpse(dadosOnda1)
################################################################################
table(dadosOnda1$hip)
summary(dadosOnda1$hip)
################################################################################
mod <- glm(hip ~ pot + sod, 
           data = dadosOnda1, 
           family = binomial(link = 'logit')
)
################################################################################
###summary(mod)
################################################################################
plot(mod, which = 5)
summary(stdres(mod))
################################################################################
###Ausencia de multicolinearidade
pairs.panels(dadosOnda1)
### Multicolinearidade: r > 0.9 (ou 0.8)
vif(mod)
### Multicolinearidade: VIF > 10
################################################################################
###Teste de Box-Tidwell
intolog_pot <- dadosOnda1$pot*log(dadosOnda1$pot)
intolog_sod <- dadosOnda1$sod*log(dadosOnda1$sod)

dadosOnda1$intolog_pot <- intolog_pot
dadosOnda1$intolog_sod <- intolog_sod
################################################################################
modint <- glm(hip ~ pot + sod + dadosOnda1$intolog_pot + dadosOnda1$intolog_sod, 
              data = dadosOnda1, 
              family = binomial(link = 'logit'),
              weights = ifelse(dadosOnda1$hip == "S", 2, 1)
)
################################################################################
summary(modint)
################################################################################
logito <- modint$linear.predictors
################################################################################
#### Analise da relacao linear

ggplot(dadosOnda1, aes(logito, sod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()

ggplot(dadosOnda1, aes(logito, pot)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
################################################################################
### Considerando o modelo original inicial e a probabilidade calculada para sodio e potassio
dadosOnda1$prob_predita_mod <- predict(mod, type = "response")

# Visualizando as probabilidades em relação a 'pot'
ggplot(dadosOnda1, aes(x = pot, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Potássio (pot)", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()

# Visualizando as probabilidades em relação a 'sod'
ggplot(dadosOnda1, aes(x = sod, y = prob_predita_mod)) +
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

## Obtencao das razoes de chance com IC 95% (usando erro padrao = SPSS)
exp(cbind(OR = coef(mod), confint.default(mod)))
################################################################################
### Modelos somente com uma variável independente
mod2 <- glm(hip ~ sod,
            family = binomial(link = 'logit'), data = dadosOnda1)

mod3 <- glm(hip ~ pot,
            family = binomial(link = 'logit'), data = dadosOnda1)
################################################################################
summary(mod2) #Sumario do modelo somente com sodio
################################################################################
summary(mod3) #sumario do modelo somente com potassio
################################################################################
### Pseudo R-quadrado
PseudoR2(mod, which = "Nagelkerke")
### Tabela de classificacao
ClassLog(mod, dadosOnda1$hip)


################################################################################
################################################################################
####### Balanceando as classes por aumento e reducao de amostragens ############
################################################################################
### 1. Oversampling
### Aplicar o SMOTE (Synthetic Minority Oversampling Technique)
### SMOTE cria exemplos sintéticos para a classe minoritária com base em seus vizinhos mais próximos.
### Aumenta o número de observações da classe minoritária replicando instâncias 
### existentes ou gerando novas instâncias sintéticas

resultado_smote <- SMOTE(X = dadosOnda1[, -which(names(dadosOnda1) == "hip")],  # Dados sem a variável de resposta
                         target = as.factor(dadosOnda1$hip),                    # Variável de resposta como fator
                         K = 3,                                                 # Número de vizinhos
                         dup_size = 1.5)                                        # Multiplicação para minoritárias

# Combinar os dados balanceados
dados_balanceados_smote <- data.frame(resultado_smote$syn_data)    # Dados sintéticos gerados pelo SMOTE
dados_balanceados_smote$hip <- as.factor(dados_balanceados_smote$class)  # Adicionar classe ajustada
dados_balanceados_smote$class <- NULL                              # Remover coluna 'class'

# Adicionar os dados originais majoritários e minoritários
dados_balanceados_smote <- rbind(dadosOnda1, dados_balanceados_smote)

# Verifique a nova distribuição
table(dados_balanceados_smote$hip)

### 2. Undersampling
### Reduz o número de observações da classe majoritária para se igualar à classe minoritária.
### Undersampling para balancear as classes
dados_balanceados_undersampling <- ovun.sample(hip ~ ., data = dadosOnda1, method = "under")$data
### Verifique a distribuição das classes
table(dados_balanceados_undersampling$hip)

### 3. Oversampling e Undersampling Combinados
### Combina as duas estratégias para criar um conjunto de dados mais balanceado.
dados_balanceados_both <- ovun.sample(hip ~ ., data = dadosOnda1, method = "both", p = 0.5)$data
### Verifique a distribuição das classes
table(dados_balanceados_both$hip)

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
           family = binomial(link = 'logit'), data = dados_balanceados_both)
### Ausencia de outliers/Pontos de alavancagem
plot(mod, which = 5)
summary(stdres(mod))
### Verificando multicolinearidade
pairs.panels(dados_balanceados_both)
vif(mod)
### Interacao entre a VI cont?nua e o seu log nao significativa (Box-Tidwell)
intlog_pot <- dados_balanceados_both$pot * log(dados_balanceados_both$pot)
dados_balanceados_both$intlog_pot <- intlog_pot

intlog_sod <- dados_balanceados_both$sod * log(dados_balanceados_both$sod)
dados_balanceados_both$intlog_sod <- intlog_sod

modint <- glm(hip ~ pot + sod + intlog_pot + intlog_sod,
              family = binomial(link = 'logit'), data = dados_balanceados_both)

summary(modint)
### Calculo do logito
logito <- mod$linear.predictors
### Analise da relaco linear
# Potassio
ggplot(dados_balanceados_both, aes(logito, pot)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
# Sodio
ggplot(dados_balanceados_both, aes(logito, sod)) +
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
            family = binomial(link = 'logit'), data = dados_balanceados_both)
mod3 <- glm(hip ~ sod,
            family = binomial(link = 'logit'), data = dados_balanceados_both)

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