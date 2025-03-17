### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/data_kNN.R")  # Verifique se esta etapa está importando 'data' corretamente
  
###Passo 1: Carregar os pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2)


###Passo 2: Carregar o banco de dados
dadosOnda1 <- data.frame(
  hipertensao = data$hip_onda1,
  potassio = data$pot_onda1,
  sodio = data$sod_onda1,
  razao_albumina_creatinina = data$albCreat_onda1,
  PAS = data$PAS_onda1,
  PAD = data$PAD_onda1,
  taxa_filtracao_glomerular = data$filt_onda1
)

View(dadosOnda1)   
glimpse(dadosOnda1)

###Passo 3: Analise das frequencias das categorias da VD:
table(dadosOnda1$hipertensao)
summary(dadosOnda1)

###Passo 4: Checagem das categorias de referencia
levels(dadosOnda1$hipertensao)  #"N" e a categoria de referencia 

################################################################################
# Passo 5: Checagem dos pressupostos

## 1. Variavel dependente dicotomica (categorias mutuamente exclusivas)
## 2. Independencia das observacoes (sem medidas repetidas)


## Construcao do modelo:

mod <- glm(hipertensao ~ .,
           family = binomial(link = 'logit'), data = dadosOnda1)


## 3. Ausencia de outliers/ pontos de alavancagem

plot(mod, which = 5)

summary(stdres(mod))


## 4. Ausencia de multicolinearidade

pairs.panels(dadosOnda1)
### Multicolinearidade: r > 0.9 (ou 0.8)


vif(mod)
### Multicolinearidade: VIF > 10


## 5. Relacao linear entre cada VI continua e o logito da VD


### Interacao entre a VI continua e o seu log nao significativa (Box-Tidwell)

intlog1 <- dadosOnda1$potassio * log(dadosOnda1$potassio)
intlog2 <- dadosOnda1$sodio * log(dadosOnda1$sodio)
intlog3 <- dadosOnda1$razao_albumina_creatinina * log(dadosOnda1$razao_albumina_creatinina)
intlog4 <- dadosOnda1$PAS * log(dadosOnda1$PAS)
intlog5 <- dadosOnda1$PAD * log(dadosOnda1$PAD)

dadosOnda1$intlog1 <- intlog1
dadosOnda1$intlog2 <- intlog2
dadosOnda1$intlog3 <- intlog3
dadosOnda1$intlog4 <- intlog4
dadosOnda1$intlog5 <- intlog5

modint <- glm(hipertensao ~ .,
              family = binomial(link = 'logit'), data = dadosOnda1)

summary(modint)

#### Calculo do logito

logito <- mod$linear.predictors

dadosOnda1$logito <- logito


#### Analise da relacao linear

ggplot(dadosOnda1, aes(logito, potassio)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
