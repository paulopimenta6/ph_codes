### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/data/data_kNN_v2.R")  # Verifique se esta etapa está importando 'data' corretamente

###Passo 1: Carregar os pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(C50, caret, dplyr, pROC, ROSE)

View(dadosOnda3kNN_inp)   
glimpse(dadosOnda3kNN_inp)

table(dadosOnda3kNN_inp$hip)
summary(dadosOnda3kNN_inp)

################################################################################
### exemplo de undersampling com ROSE
set.seed(123)  # Para reprodutibilidade

### esta sem grandes desbalanceamentos
### > table(dadosOnda3kNN_inp$hip)
### 0    1 
### 2277 2784 

# Verificando a nova distribuição das classes
table(dadosOnda3kNN_inp$hip)
################################################################################
###Passo 4: Checagem das categorias de referencia
dadosOnda3kNN_inp$hip <- ifelse(dadosOnda3kNN_inp$hip == "0", 'N', 'S')
dadosOnda3kNN_inp$hip <- as.factor(dadosOnda3kNN_inp$hip)
levels(dadosOnda3kNN_inp$hip)  #"N" e a categoria de referencia 
#dadosOnda3kNN_inp$hip <- relevel(dadosOnda3kNN_inp$hip, ref = "S")
################################################################################
### Agrupando as fracoes de treino e teste
flag <- caret::createDataPartition(dadosOnda3kNN_inp$hip, p=0.7, list = F) 
treino <- dadosOnda3kNN_inp[flag, ]
teste <- dadosOnda3kNN_inp[-flag, ]

### Primeiros elementos de treino
head(treino)

### Primeiros elementos de teste
head(teste)
################################################################################
### Modelo de arvore com C50
modeloC50 <- C5.0(hip ~ ., data = treino)
plot(modeloC50)

################################################################################
### Modelo com regras
modeloC50.com.regras <- C5.0(hip ~ ., data = treino, rules = TRUE)
summary(modeloC50.com.regras)

################################################################################
### Usando os dados de teste
pred.teste <- predict(modeloC50, newdata = teste, type="class")

################################################################################
### Criando matriz de confusao

# Garantindo que os fatores tenham os mesmos níveis
pred.teste <- factor(pred.teste, levels = levels(teste$hip))
hip_real <- factor(teste$hip, levels = levels(teste$hip))

# Criando a matriz de confusão
conf_matrix <- caret::confusionMatrix(pred.teste, hip_real, positive = "S")

# Exibindo os resultados
print(conf_matrix)

################################################################################
### Gerando curva ROC
prob.teste <- predict(modeloC50, newdata = teste, type = "prob")
roc_curve <- roc(teste$hip, prob.teste[, "S"])  # "S" é a classe positiva
plot(roc_curve, col = "blue", main = "Curva ROC - Modelo C5.0")
auc(roc_curve)