############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src") {     ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src")              ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoBenazeprilOnda1Ajustada <- fazUsoContinuoBenazeprilOnda1[which(!is.na(fazUsoContinuoBenazeprilOnda1))]
fazUsoContinuoBenazeprilOnda2Ajustada <- fazUsoContinuoBenazeprilOnda2[which(!is.na(fazUsoContinuoBenazeprilOnda2))]
fazUsoContinuoBenazeprilOnda3Ajustada <- fazUsoContinuoBenazeprilOnda3[which(!is.na(fazUsoContinuoBenazeprilOnda3))]

idxFazUsoContinuoBenazeprilOnda1 <- which(!is.na(fazUsoContinuoBenazeprilOnda1))
idxFazUsoContinuoBenazeprilOnda2 <- which(!is.na(fazUsoContinuoBenazeprilOnda2))
idxFazUsoContinuoBenazeprilOnda3 <- which(!is.na(fazUsoContinuoBenazeprilOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoAtorvastatinaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoAtorvastatinaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoAtorvastatinaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoBenazeprilOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoBenazeprilOnda1Ajustada)
fazUsoContinuoBenazeprilOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoBenazeprilOnda2Ajustada)
fazUsoContinuoBenazeprilOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoBenazeprilOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoBenazeprilOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoBenazeprilOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoBenazeprilOnda3Ajustada = 0:1)

fazUsoContinuoBenazeprilOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoBenazeprilOnda1, by = "fazUsoContinuoBenazeprilOnda1Ajustada", all.x = TRUE)
fazUsoContinuoBenazeprilOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoBenazeprilOnda2, by = "fazUsoContinuoBenazeprilOnda2Ajustada", all.x = TRUE)
fazUsoContinuoBenazeprilOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoBenazeprilOnda3, by = "fazUsoContinuoBenazeprilOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoBenazeprilOnda1_complet, aes(x = factor(fazUsoContinuoBenazeprilOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Benzapril - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoBenazeprilOnda2_complet, aes(x = factor(fazUsoContinuoBenazeprilOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Benzapril - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoBenazeprilOnda3_complet, aes(x = factor(fazUsoContinuoBenazeprilOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Benzapril - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoBenazeprilOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoBenazeprilOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoBenazeprilOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Benzapril") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Benzapril - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoBenazeprilOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoBenazeprilOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoBenazeprilOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Benzapril") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Benzapril - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoBenazeprilOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoBenazeprilOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoBenazeprilOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Benzapril") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Benzapril - Onda 3")