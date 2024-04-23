############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoGliclazidaOnda1Ajustada <- fazUsoContinuoGliclazidaOnda1[which(!is.na(fazUsoContinuoGliclazidaOnda1))]
fazUsoContinuoGliclazidaOnda2Ajustada <- fazUsoContinuoGliclazidaOnda2[which(!is.na(fazUsoContinuoGliclazidaOnda2))]
fazUsoContinuoGliclazidaOnda3Ajustada <- fazUsoContinuoGliclazidaOnda3[which(!is.na(fazUsoContinuoGliclazidaOnda3))]

idxFazUsoContinuoGliclazidaOnda1 <- which(!is.na(fazUsoContinuoGliclazidaOnda1))
idxFazUsoContinuoGliclazidaOnda2 <- which(!is.na(fazUsoContinuoGliclazidaOnda2))
idxFazUsoContinuoGliclazidaOnda3 <- which(!is.na(fazUsoContinuoGliclazidaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoGliclazidaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoGliclazidaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoGliclazidaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoGliclazidaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoGliclazidaOnda1Ajustada)
fazUsoContinuoGliclazidaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoGliclazidaOnda2Ajustada)
fazUsoContinuoGliclazidaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoGliclazidaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoGliclazidaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoGliclazidaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoGliclazidaOnda3Ajustada = 0:1)

fazUsoContinuoGliclazidaOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoGliclazidaOnda1, by = "fazUsoContinuoGliclazidaOnda1Ajustada", all.x = TRUE)
fazUsoContinuoGliclazidaOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoGliclazidaOnda2, by = "fazUsoContinuoGliclazidaOnda2Ajustada", all.x = TRUE)
fazUsoContinuoGliclazidaOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoGliclazidaOnda3, by = "fazUsoContinuoGliclazidaOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoGliclazidaOnda1_complet, aes(x = factor(fazUsoContinuoGliclazidaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Glicazida - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoGliclazidaOnda2_complet, aes(x = factor(fazUsoContinuoGliclazidaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Glicazida - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoGliclazidaOnda3_complet, aes(x = factor(fazUsoContinuoGliclazidaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Glicazida - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoGliclazidaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoGliclazidaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoGliclazidaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Glicazida") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Glicazida - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoGliclazidaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoGliclazidaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoGliclazidaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Glicazida") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Glicazida - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoGliclazidaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoGliclazidaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoGliclazidaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Glicazida") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Glicazida - Onda 3")