############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoMeloxicamOnda1Ajustada <- fazUsoContinuoMeloxicamOnda1[which(!is.na(fazUsoContinuoMeloxicamOnda1))]
fazUsoContinuoMeloxicamOnda2Ajustada <- fazUsoContinuoMeloxicamOnda2[which(!is.na(fazUsoContinuoMeloxicamOnda2))]
fazUsoContinuoMeloxicamOnda3Ajustada <- fazUsoContinuoMeloxicamOnda3[which(!is.na(fazUsoContinuoMeloxicamOnda3))]

idxFazUsoContinuoMeloxicamOnda1 <- which(!is.na(fazUsoContinuoMeloxicamOnda1))
idxFazUsoContinuoMeloxicamOnda2 <- which(!is.na(fazUsoContinuoMeloxicamOnda2))
idxFazUsoContinuoMeloxicamOnda3 <- which(!is.na(fazUsoContinuoMeloxicamOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoMeloxicamOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoMeloxicamOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoMeloxicamOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoMeloxicamOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoMeloxicamOnda1Ajustada)
fazUsoContinuoMeloxicamOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoMeloxicamOnda2Ajustada)
fazUsoContinuoMeloxicamOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoMeloxicamOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoMeloxicamOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoMeloxicamOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoMeloxicamOnda3Ajustada = 0:1)

fazUsoContinuoMeloxicamOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoMeloxicamOnda1, by = "fazUsoContinuoMeloxicamOnda1Ajustada", all.x = TRUE)
fazUsoContinuoMeloxicamOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoMeloxicamOnda2, by = "fazUsoContinuoMeloxicamOnda2Ajustada", all.x = TRUE)
fazUsoContinuoMeloxicamOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoMeloxicamOnda3, by = "fazUsoContinuoMeloxicamOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoMeloxicamOnda1_complet, aes(x = factor(fazUsoContinuoMeloxicamOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Meloxicam - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoMeloxicamOnda2_complet, aes(x = factor(fazUsoContinuoMeloxicamOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Meloxicam - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoMeloxicamOnda3_complet, aes(x = factor(fazUsoContinuoMeloxicamOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Meloxicam - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoMeloxicamOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoMeloxicamOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoMeloxicamOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Meloxicam") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Meloxicam - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoMeloxicamOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoMeloxicamOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoMeloxicamOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Meloxicam") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Meloxicam - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoMeloxicamOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoMeloxicamOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoMeloxicamOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Meloxicam") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Meloxicam - Onda 3")