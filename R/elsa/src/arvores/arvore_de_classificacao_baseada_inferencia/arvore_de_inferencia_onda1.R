################################################################################
### Carregar pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(partykit, MLmetrics, caret, ggparty)
################################################################################
### Carregar dados (ajuste o caminho do arquivo)
source("./src/data_kNN_v2.R")  # Verifique se esta etapa está importando 'data' corretamente
################################################################################
### Pré-processamento
dadosOnda1 <- dadosOnda1kNN_inp
View(dadosOnda1kNN_inp)   
glimpse(dadosOnda1kNN_inp)
table(dadosOnda1kNN_inp$hip)
summary(dadosOnda1kNN_inp)

dadosOnda1$hip <- ifelse(dadosOnda1$hip == 0, 'N', 'S')
dadosOnda1$hip <- as.factor(dadosOnda1$hip)
dadosOnda1$hip <- relevel(dadosOnda1$hip, ref="S")
################################################################################
flag <- caret::createDataPartition(dadosOnda1$hip, p=0.6, list=F)
train <- dadosOnda1[flag, ]
dim(train)
test <- dadosOnda1[-flag, ]
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

#############################################################