############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoInsulinaONda1Ajustada <- fazUsoContinuoInsulinaONda1[which(!is.na(fazUsoContinuoInsulinaONda1))]
fazUsoContinuoInsulinaONda2Ajustada <- fazUsoContinuoInsulinaONda2[which(!is.na(fazUsoContinuoInsulinaONda2))]
fazUsoContinuoInsulinaONda3Ajustada <- fazUsoContinuoInsulinaONda3[which(!is.na(fazUsoContinuoInsulinaONda3))]

idxFazUsoContinuoInsulinaONda1 <- which(!is.na(fazUsoContinuoInsulinaONda1))
idxFazUsoContinuoInsulinaONda2 <- which(!is.na(fazUsoContinuoInsulinaONda2))
idxFazUsoContinuoInsulinaONda3 <- which(!is.na(fazUsoContinuoInsulinaONda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoInsulinaONda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoInsulinaONda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoInsulinaONda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoInsulinaONda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoInsulinaONda1Ajustada)
fazUsoContinuoInsulinaONda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoInsulinaONda2Ajustada)
fazUsoContinuoInsulinaONda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoInsulinaONda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoInsulinaONda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoInsulinaONda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoInsulinaONda3Ajustada = 0:1)

fazUsoContinuoInsulinaONda1_complet <- merge(all_levels_Onda1, fazUsoContinuoInsulinaONda1, by = "fazUsoContinuoInsulinaONda1Ajustada", all.x = TRUE)
fazUsoContinuoInsulinaONda2_complet <- merge(all_levels_Onda2, fazUsoContinuoInsulinaONda2, by = "fazUsoContinuoInsulinaONda2Ajustada", all.x = TRUE)
fazUsoContinuoInsulinaONda3_complet <- merge(all_levels_Onda3, fazUsoContinuoInsulinaONda3, by = "fazUsoContinuoInsulinaONda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoInsulinaONda1_complet, aes(x = factor(fazUsoContinuoInsulinaONda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Insulina - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoInsulinaONda2_complet, aes(x = factor(fazUsoContinuoInsulinaONda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Insulina - Onda 2") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoInsulinaONda3_complet, aes(x = factor(fazUsoContinuoInsulinaONda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Insulina - Onda 3") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoInsulinaONda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoInsulinaONda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoInsulinaONda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Insulina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Insulina - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoInsulinaONda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoInsulinaONda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoInsulinaONda2Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Insulina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Insulina - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoInsulinaONda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoInsulinaONda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoInsulinaONda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Insulina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Insulina - Onda 3")