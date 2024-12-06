if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey, smotefamily, ROSE)
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1
)

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

################################################################################
### Usando o modelo Oversampling e Undersampling Combinados
### Construcao do modelo
mod <- glm(hip ~ pot + sod,
           family = binomial(link = 'logit'), data = dados_balanceados_smote)
### Ausencia de outliers/Pontos de alavancagem
plot(mod, which = 5)
summary(stdres(mod))
### Verificando multicolinearidade
pairs.panels(dados_balanceados_smote)
vif(mod)

### Calculo do logito
logito <- mod$linear.predictors
### Analise da relaco linear
# Potassio
ggplot(dados_balanceados_smote, aes(logito, pot)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
# Sodio
ggplot(dados_balanceados_smote, aes(logito, sod)) +
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
            family = binomial(link = 'logit'), data = dados_balanceados_smote)
mod3 <- glm(hip ~ sod,
            family = binomial(link = 'logit'), data = dados_balanceados_smote)

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
ClassLog(mod, dados_balanceados_smote$hip)