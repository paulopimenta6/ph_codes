############################################################################################
##############################Especificando diretorio src###################################                                                                                      ##
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoEnalaprilOnda1Ajustada <- fazUsoContinuoEnalaprilOnda1[which(!is.na(fazUsoContinuoEnalaprilOnda1))]
fazUsoContinuoEnalaprilOnda2Ajustada <- fazUsoContinuoEnalaprilOnda2[which(!is.na(fazUsoContinuoEnalaprilOnda2))]
fazUsoContinuoEnalaprilOnda3Ajustada <- fazUsoContinuoEnalaprilOnda3[which(!is.na(fazUsoContinuoEnalaprilOnda3))]

idxFazUsoContinuoEnalaprilOnda1 <- which(!is.na(fazUsoContinuoEnalaprilOnda1))
idxFazUsoContinuoEnalaprilOnda2 <- which(!is.na(fazUsoContinuoEnalaprilOnda2))
idxFazUsoContinuoEnalaprilOnda3 <- which(!is.na(fazUsoContinuoEnalaprilOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoEnalaprilOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoEnalaprilOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoEnalaprilOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoEnalaprilOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoEnalaprilOnda1Ajustada)
fazUsoContinuoEnalaprilOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoEnalaprilOnda2Ajustada)
fazUsoContinuoEnalaprilOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoEnalaprilOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoEnalaprilOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoEnalaprilOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoEnalaprilOnda3Ajustada = 0:1)

fazUsoContinuoEnalaprilOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoEnalaprilOnda1, by = "fazUsoContinuoEnalaprilOnda1Ajustada", all.x = TRUE)
fazUsoContinuoEnalaprilOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoEnalaprilOnda2, by = "fazUsoContinuoEnalaprilOnda2Ajustada", all.x = TRUE)
fazUsoContinuoEnalaprilOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoEnalaprilOnda3, by = "fazUsoContinuoEnalaprilOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoEnalaprilOnda1_complet, aes(x = factor(fazUsoContinuoEnalaprilOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Enalapril - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoEnalaprilOnda2_complet, aes(x = factor(fazUsoContinuoEnalaprilOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Enalapril - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoEnalaprilOnda3_complet, aes(x = factor(fazUsoContinuoEnalaprilOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Enalapril - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoEnalaprilOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoEnalaprilOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoEnalaprilOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Enalapril") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Enalapril - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoEnalaprilOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoEnalaprilOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoEnalaprilOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Enalapril") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Enalapril - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoEnalaprilOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoEnalaprilOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoEnalaprilOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Enalapril") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Enalapril - Onda 3")