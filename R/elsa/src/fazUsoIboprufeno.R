############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoIbuprofenoOnda1Ajustada <- fazUsoContinuoIbuprofenoOnda1[which(!is.na(fazUsoContinuoIbuprofenoOnda1))]
fazUsoContinuoIbuprofenoOnda2Ajustada <- fazUsoContinuoIbuprofenoOnda2[which(!is.na(fazUsoContinuoIbuprofenoOnda2))]
fazUsoContinuoIbuprofenoOnda3Ajustada <- fazUsoContinuoIbuprofenoOnda3[which(!is.na(fazUsoContinuoIbuprofenoOnda3))]

idxFazUsoContinuoIbuprofenoOnda1 <- which(!is.na(fazUsoContinuoIbuprofenoOnda1))
idxFazUsoContinuoIbuprofenoOnda2 <- which(!is.na(fazUsoContinuoIbuprofenoOnda2))
idxFazUsoContinuoIbuprofenoOnda3 <- which(!is.na(fazUsoContinuoIbuprofenoOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoIbuprofenoOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoIbuprofenoOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoIbuprofenoOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoIbuprofenoOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoIbuprofenoOnda1Ajustada)
fazUsoContinuoIbuprofenoOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoIbuprofenoOnda2Ajustada)
fazUsoContinuoIbuprofenoOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoIbuprofenoOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoIbuprofenoOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoIbuprofenoOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoIbuprofenoOnda3Ajustada = 0:1)

fazUsoContinuoIbuprofenoOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoIbuprofenoOnda1, by = "fazUsoContinuoIbuprofenoOnda1Ajustada", all.x = TRUE)
fazUsoContinuoIbuprofenoOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoIbuprofenoOnda2, by = "fazUsoContinuoIbuprofenoOnda2Ajustada", all.x = TRUE)
fazUsoContinuoIbuprofenoOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoIbuprofenoOnda3, by = "fazUsoContinuoIbuprofenoOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoIbuprofenoOnda1_complet, aes(x = factor(fazUsoContinuoIbuprofenoOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Iboprufeno - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoIbuprofenoOnda2_complet, aes(x = factor(fazUsoContinuoIbuprofenoOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Iboprufeno - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoIbuprofenoOnda3_complet, aes(x = factor(fazUsoContinuoIbuprofenoOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Iboprufeno - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoIbuprofenoOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoIbuprofenoOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoIbuprofenoOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Iboprufeno") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Iboprufeno - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoIbuprofenoOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoIbuprofenoOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoIbuprofenoOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Iboprufeno") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Iboprufeno - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoIbuprofenoOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoIbuprofenoOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoIbuprofenoOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Iboprufeno") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Iboprufeno - Onda 3")