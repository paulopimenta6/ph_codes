################################################################################
### Carregar pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(partykit, MLmetrics, caret, ggparty, ROSE)
################################################################################
### Carregar dados (ajuste o caminho do arquivo)
source("./src/data/data_kNN_v2.R")  # Verifique se esta etapa está importando 'data' corretamente
################################################################################
### Pré-processamento
dadosOnda1 <- dadosOnda1kNN_inp
View(dadosOnda1kNN_inp)   
glimpse(dadosOnda1kNN_inp)
table(dadosOnda1kNN_inp$hip)
summary(dadosOnda1kNN_inp)
################################################################################
### exemplo de undersampling com ROSE
set.seed(123)  # Para reprodutibilidade
dadosOnda1kNN_inp_balanced <- ovun.sample(hip ~ ., data = dadosOnda1kNN_inp, method = "under", N = 1651 * 2)$data
# Verificando a nova distribuição das classes
table(dadosOnda1kNN_inp_balanced$hip)
################################################################################
dadosOnda1kNN_inp_balanced$hip <- ifelse(dadosOnda1kNN_inp_balanced$hip == 0, 'N', 'S')
dadosOnda1kNN_inp_balanced$hip <- as.factor(dadosOnda1kNN_inp_balanced$hip)
#dadosOnda1kNN_inp_balanced$hip <- relevel(dadosOnda1kNN_inp_balanced$hip, ref="S")
################################################################################
flag <- caret::createDataPartition(dadosOnda1kNN_inp_balanced$hip, p=0.6, list=F)
train <- dadosOnda1kNN_inp_balanced[flag, ]
dim(train)
test <- dadosOnda1kNN_inp_balanced[-flag, ]
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
    geom_bar(aes(x = hip))))
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
  labs(title = "Classificação da Árvore vs Real", x = "Classe Real", fill = "Predição")
