############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoMetforminaOnda1Ajustada <- fazUsoContinuoMetforminaOnda1[which(!is.na(fazUsoContinuoMetforminaOnda1))]
fazUsoContinuoMetforminaOnda2Ajustada <- fazUsoContinuoMetforminaOnda2[which(!is.na(fazUsoContinuoMetforminaOnda2))]
fazUsoContinuoMetforminaOnda3Ajustada <- fazUsoContinuoMetforminaOnda3[which(!is.na(fazUsoContinuoMetforminaOnda3))]

idxFazUsoContinuoMetforminaOnda1 <- which(!is.na(fazUsoContinuoMetforminaOnda1))
idxFazUsoContinuoMetforminaOnda2 <- which(!is.na(fazUsoContinuoMetforminaOnda2))
idxFazUsoContinuoMetforminaOnda3 <- which(!is.na(fazUsoContinuoMetforminaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoMetforminaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoMetforminaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoMetforminaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoMetforminaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoMetforminaOnda1Ajustada)
fazUsoContinuoMetforminaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoMetforminaOnda2Ajustada)
fazUsoContinuoMetforminaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoMetforminaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoMetforminaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoMetforminaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoMetforminaOnda3Ajustada = 0:1)

fazUsoContinuoMetforminaOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoMetforminaOnda1, by = "fazUsoContinuoMetforminaOnda1Ajustada", all.x = TRUE)
fazUsoContinuoMetforminaOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoMetforminaOnda2, by = "fazUsoContinuoMetforminaOnda2Ajustada", all.x = TRUE)
fazUsoContinuoMetforminaOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoMetforminaOnda3, by = "fazUsoContinuoMetforminaOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoMetforminaOnda1_complet, aes(x = factor(fazUsoContinuoMetforminaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Metformina - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoMetforminaOnda2_complet, aes(x = factor(fazUsoContinuoMetforminaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Metformina - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoMetforminaOnda3_complet, aes(x = factor(fazUsoContinuoMetforminaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Metformina - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoMetforminaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoMetforminaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoMetforminaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Metformina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Metformina - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoMetforminaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoMetforminaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoMetforminaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Metformina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Metformina - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoMetforminaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoMetforminaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoMetforminaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Metformina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Metformina - Onda 3")