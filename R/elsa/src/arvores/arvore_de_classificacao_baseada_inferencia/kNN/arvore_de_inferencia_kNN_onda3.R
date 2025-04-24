################################################################################
### Carregar pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(partykit, MLmetrics, caret, ggparty)
################################################################################
### Carregar dados (ajuste o caminho do arquivo)
source("./src/data/data_kNN_v2.R")  # Verifique se esta etapa está importando 'data' corretamente
################################################################################
### Pré-processamento
dadosOnda3 <- dadosOnda3kNN_inp
View(dadosOnda3kNN_inp)   
glimpse(dadosOnda3kNN_inp)
table(dadosOnda3kNN_inp$hip)
summary(dadosOnda3kNN_inp)

dadosOnda3$hip <- ifelse(dadosOnda3$hip == 0, 'N', 'S')
dadosOnda3$hip <- as.factor(dadosOnda3$hip)
#dadosOnda3$hip <- relevel(dadosOnda3$hip, ref="S")
################################################################################
flag <- caret::createDataPartition(dadosOnda3$hip, p=0.6, list=F)
train <- dadosOnda3[flag, ]
dim(train)
test <- dadosOnda3[-flag, ]
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
  ) +
  ggtitle("Árvore inferencial - Onda 3") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold")) +
  ggtitle("Árvore inferencial - Onda 2") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
################################################################################
ggparty(ct, terminal_space = 0.3) +
  geom_edge() +
  geom_edge_label() +
  geom_node_splitvar() +
  geom_node_plot(gglist = list(
    geom_bar(aes(x = hip)))) +
  ggtitle("Árvore inferencial - Onda 3") +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold")) +
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
  labs(title = "Classificação da Árvore vs Real - Onda 3", x = "Classe Real", fill = "Predição")