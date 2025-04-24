### Passo 0: Carregar dados (ajuste o caminho do arquivo)
source("./src/data/mice_inputation_v2.R")  # Verifique se esta etapa está importando 'data' corretamente

###Passo 1: Carregar os pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(partykit, MLmetrics, caret, ggparty, ROSE)  # Certifique-se de carregar o pacote ROSE

View(dadosOnda2Mice_inp)   
glimpse(dadosOnda2Mice_inp)

table(dadosOnda2Mice_inp$hip)
summary(dadosOnda2Mice_inp)

################################################################################
### exemplo de undersampling com ROSE
set.seed(123)  # Para reprodutibilidade
dadosOnda2Mice_inp_balanced <- ovun.sample(hip ~ ., data = dadosOnda2Mice_inp, method = "under", N = 1921 * 2)$data
# Verificando a nova distribuição das classes
table(dadosOnda2Mice_inp_balanced$hip)
################################################################################
###Passo 4: Checagem das categorias de referencia
dadosOnda2Mice_inp_balanced$hip <- ifelse(dadosOnda2Mice_inp_balanced$hip == "0", 'N', 'S')
dadosOnda2Mice_inp_balanced$hip <- as.factor(dadosOnda2Mice_inp_balanced$hip)
levels(dadosOnda2Mice_inp_balanced$hip)  #"N" e a categoria de referencia 
#dadosOnda2Mice_inp_balanced$hip <- relevel(dadosOnda2Mice_inp_balanced$hip, ref = "S")
################################################################################
### Agrupando as fracoes de treino e teste
flag <- caret::createDataPartition(dadosOnda2Mice_inp_balanced$hip, p=0.7, list = F) 
train <- dadosOnda2Mice_inp_balanced[flag, ]
dim(train)
test <- dadosOnda2Mice_inp_balanced[-flag, ]
dim(test)
################################################################################
### Garantindo reprodutibilidade
set.seed(123)
################################################################################
ct <- partykit::ctree(data=train, hip ~ .) #, 
#control=ctree_control(minbucket = 50,  # Reduza para maior complexidade
#                      minsplit = 100), # Mínimo de observações para divisão
#                      maxdepth = 5)    # Profundidade máxima da árvore
ct
################################################################################
plot(ct, 
     type="simple", 
     ip_args = list(fill="white", gp = gpar(cex = 0.8)), 
     tp_args = list(fill=c('white'), gp = gpar(cex = 0.7)), 
     main = 'ELSA', 
     font = 1)
################################################################################
ggparty(ct) +
  geom_edge() +
  geom_edge_label() +
  geom_node_splitvar() +
  geom_node_plot(gglist = list(geom_bar(aes(x = "", fill = hip),
                                        position = position_fill()),
                               xlab("hip"))
  )
################################################################################
ggparty(ct, terminal_space = 0.3) +
  geom_edge() +
  geom_edge_label() +
  geom_node_splitvar() +
  geom_node_plot(gglist = list(
    geom_bar(aes(x = hip))))+ 
  ggtitle("Árvore inferencial - Onda 2") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
################################################################################
### Classificacao das variaveis alvo
test$classific <- predict(ct, newdata = test)
head(test$classific)

### matriz de confusao
confusionMatrix(data = test$classific,
                reference = test$hip,
                positive = "S")  # Ajuste se "S" for a classe de interesse

### Metricas de avalicao
# Converta para vetor, se necessário
y_true <- as.vector(test$hip)
y_pred <- as.vector(test$classific)

Accuracy(y_pred, y_true)         # Acurácia
Precision(y_pred, y_true, positive = "S")   # Precisão para classe S
Recall(y_pred, y_true, positive = "S")      # Revocação (Sensibilidade)
F1_Score(y_pred, y_true, positive = "S")    # F1 Score

### Distribuicao das predicoes
table(Predito = test$classific, Real = test$hip)

ggplot(test, aes(x = hip, fill = classific)) +
  geom_bar(position = "dodge") +
  labs(title = "Classificação da Árvore vs Real", x = "Classe Real - Onda 2", fill = "Predição")
