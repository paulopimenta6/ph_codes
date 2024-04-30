############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R")  
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoCaptoprilOnda1Ajustada <- fazUsoContinuoCaptoprilOnda1[which(!is.na(fazUsoContinuoCaptoprilOnda1))]
fazUsoContinuoCaptoprilOnda2Ajustada <- fazUsoContinuoCaptoprilOnda2[which(!is.na(fazUsoContinuoCaptoprilOnda2))]
fazUsoContinuoCaptoprilOnda3Ajustada <- fazUsoContinuoCaptoprilOnda3[which(!is.na(fazUsoContinuoCaptoprilOnda3))]

idxFazUsoContinuoCaptoprilOnda1 <- which(!is.na(fazUsoContinuoCaptoprilOnda1))
idxFazUsoContinuoCaptoprilOnda2 <- which(!is.na(fazUsoContinuoCaptoprilOnda2))
idxFazUsoContinuoCaptoprilOnda3 <- which(!is.na(fazUsoContinuoCaptoprilOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoCaptoprilOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoCaptoprilOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoCaptoprilOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoCaptoprilOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoCaptoprilOnda1Ajustada)
fazUsoContinuoCaptoprilOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoCaptoprilOnda2Ajustada)
fazUsoContinuoCaptoprilOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoCaptoprilOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoCaptoprilOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoCaptoprilOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoCaptoprilOnda3Ajustada = 0:1)

fazUsoContinuoCaptoprilOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoCaptoprilOnda1, by = "fazUsoContinuoCaptoprilOnda1Ajustada", all.x = TRUE)
fazUsoContinuoCaptoprilOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoCaptoprilOnda2, by = "fazUsoContinuoCaptoprilOnda2Ajustada", all.x = TRUE)
fazUsoContinuoCaptoprilOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoCaptoprilOnda3, by = "fazUsoContinuoCaptoprilOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoCaptoprilOnda1_complet, aes(x = factor(fazUsoContinuoCaptoprilOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Captopril - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoCaptoprilOnda2_complet, aes(x = factor(fazUsoContinuoCaptoprilOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Captopril - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoCaptoprilOnda3_complet, aes(x = factor(fazUsoContinuoCaptoprilOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Captopril - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoCaptoprilOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoCaptoprilOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoCaptoprilOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Captopril - 0: Não, 1: sim") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Captopril - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoCaptoprilOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoCaptoprilOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoCaptoprilOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Captopril - 0: Não, 1: sim") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Captopril - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoCaptoprilOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoCaptoprilOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoCaptoprilOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Captopril - 0: Não, 1: sim") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Captopril - Onda 3")