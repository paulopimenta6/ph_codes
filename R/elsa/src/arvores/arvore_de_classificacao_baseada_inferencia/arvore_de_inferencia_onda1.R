################################################################################
### Carregar pacotes
if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(partykit, MLmetrics, caret, ggparty)
################################################################################
### Carregar dados (ajuste o caminho do arquivo)
source("./src/data_kNN.R")  # Verifique se esta etapa está importando 'data' corretamente
################################################################################
### Pré-processamento
dadosOnda1 <- data.frame(
  hipertensao = data$hip_onda1,
  potassio = data$pot_onda1,
  sodio = data$sod_onda1,
  razao_albumina_creatinina = data$albCreat_onda1,
  PAS = data$PAS_onda1,
  PAD = data$PAD_onda1,
  taxa_filtracao_glomerular = data$filt_onda1
)
dadosOnda1$hipertensao <- relevel(dadosOnda1$hipertensao, ref="S")
################################################################################
flag <- caret::createDataPartition(dadosOnda1$hipertensao, p=0.6, list=F)
train <- dadosOnda1[flag, ]
dim(train)
test <- dadosOnda1[-flag, ]
dim(test)
################################################################################
### Garantindo reprodutibilidade
set.seed(123)
################################################################################
ct <- partykit::ctree(data=train, hipertensao ~ .) #, 
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
  geom_node_plot(gglist = list(geom_bar(aes(x = "", fill = hipertensao),
                                            position = position_fill()),
                                            xlab("hipertensao"))
                 )
################################################################################
ggparty(ct, terminal_space = 0.3) +
  geom_edge() +
  geom_edge_label() +
  geom_node_splitvar() +
  geom_node_plot(gglist = list(
    geom_bar(aes(x = hipertensao))))

#############################################################