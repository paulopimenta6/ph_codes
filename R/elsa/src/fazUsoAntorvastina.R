############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoAtorvastatinaOnda1Ajustada <- fazUsoContinuoAtorvastatinaOnda1[which(!is.na(fazUsoContinuoAtorvastatinaOnda1))]
fazUsoContinuoAtorvastatinaOnda2Ajustada <- fazUsoContinuoAtorvastatinaOnda2[which(!is.na(fazUsoContinuoAtorvastatinaOnda2))]
fazUsoContinuoAtorvastatinaOnda3Ajustada <- fazUsoContinuoAtorvastatinaOnda3[which(!is.na(fazUsoContinuoAtorvastatinaOnda3))]

idxFazUsoContinuoAtorvastatinaOnda1 <- which(!is.na(fazUsoContinuoAtorvastatinaOnda1))
idxFazUsoContinuoAtorvastatinaOnda2 <- which(!is.na(fazUsoContinuoAtorvastatinaOnda2))
idxFazUsoContinuoAtorvastatinaOnda3 <- which(!is.na(fazUsoContinuoAtorvastatinaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoAtorvastatinaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoAtorvastatinaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoAtorvastatinaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoAtorvastatinaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoAtorvastatinaOnda1Ajustada)
fazUsoContinuoAtorvastatinaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoAtorvastatinaOnda2Ajustada)
fazUsoContinuoAtorvastatinaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoAtorvastatinaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoAtorvastatinaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoAtorvastatinaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoAtorvastatinaOnda3Ajustada = 0:1)

fazUsoContinuoAtorvastatinaOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoAtorvastatinaOnda1, by = "fazUsoContinuoAtorvastatinaOnda1Ajustada", all.x = TRUE)
fazUsoContinuoAtorvastatinaOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoAtorvastatinaOnda2, by = "fazUsoContinuoAtorvastatinaOnda2Ajustada", all.x = TRUE)
fazUsoContinuoAtorvastatinaOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoAtorvastatinaOnda3, by = "fazUsoContinuoAtorvastatinaOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoAtorvastatinaOnda1_complet, aes(x = factor(fazUsoContinuoAtorvastatinaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Antorvastina - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoAtorvastatinaOnda2_complet, aes(x = factor(fazUsoContinuoAtorvastatinaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Antorvastina - Onda 2") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoAtorvastatinaOnda3_complet, aes(x = factor(fazUsoContinuoAtorvastatinaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Antorvastina - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoAtorvastatinaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoAtorvastatinaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoAtorvastatinaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Antorvastina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Antorvastina - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoAtorvastatinaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoAtorvastatinaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoAtorvastatinaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Antorvastina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Antorvastina - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoAtorvastatinaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoAtorvastatinaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoAtorvastatinaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Antorvastina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Antorvastina - Onda 3")
