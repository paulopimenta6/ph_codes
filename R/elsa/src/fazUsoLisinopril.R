############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoLisinoprilOnda1Ajustada <- fazUsoContinuoLisinoprilOnda1[which(!is.na(fazUsoContinuoLisinoprilOnda1))]
fazUsoContinuoLisinoprilOnda2Ajustada <- fazUsoContinuoLisinoprilOnda2[which(!is.na(fazUsoContinuoLisinoprilOnda2))]
fazUsoContinuoLisinoprilOnda3Ajustada <- fazUsoContinuoLisinoprilOnda3[which(!is.na(fazUsoContinuoLisinoprilOnda3))]

idxFazUsoContinuoLisinoprilOnda1 <- which(!is.na(fazUsoContinuoLisinoprilOnda1))
idxFazUsoContinuoLisinoprilOnda2 <- which(!is.na(fazUsoContinuoLisinoprilOnda2))
idxFazUsoContinuoLisinoprilOnda3 <- which(!is.na(fazUsoContinuoLisinoprilOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoLisinoprilOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoLisinoprilOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoLisinoprilOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoLisinoprilOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoLisinoprilOnda1Ajustada)
fazUsoContinuoLisinoprilOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoLisinoprilOnda2Ajustada)
fazUsoContinuoLisinoprilOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoLisinoprilOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoLisinoprilOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoLisinoprilOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoLisinoprilOnda3Ajustada = 0:1)

fazUsoContinuoLisinoprilOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoLisinoprilOnda1, by = "fazUsoContinuoLisinoprilOnda1Ajustada", all.x = TRUE)
fazUsoContinuoLisinoprilOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoLisinoprilOnda2, by = "fazUsoContinuoLisinoprilOnda2Ajustada", all.x = TRUE)
fazUsoContinuoLisinoprilOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoLisinoprilOnda3, by = "fazUsoContinuoLisinoprilOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoLisinoprilOnda1_complet, aes(x = factor(fazUsoContinuoLisinoprilOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Lisinopril - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoLisinoprilOnda2_complet, aes(x = factor(fazUsoContinuoLisinoprilOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Lisinopril - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoLisinoprilOnda3_complet, aes(x = factor(fazUsoContinuoLisinoprilOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Lisinopril - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoLisinoprilOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoLisinoprilOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoLisinoprilOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Lisinopril") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Lisinopril - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoLisinoprilOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoLisinoprilOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoLisinoprilOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Lisinopril") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Lisinopril - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoLisinoprilOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoLisinoprilOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoLisinoprilOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Lisinopril") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Lisinopril - Onda 3")