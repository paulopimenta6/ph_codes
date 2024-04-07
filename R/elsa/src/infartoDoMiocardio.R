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
infartoDoMiocardioOnda1Ajustada <- infartoDoMiocardioOnda1[which(!is.na(infartoDoMiocardioOnda1))]
infartoDoMiocardioOnda2Ajustada <- infartoDoMiocardioOnda2[which(!is.na(infartoDoMiocardioOnda2))]
infartoDoMiocardioOnda3Ajustada <- infartoDoMiocardioOnda3[which(!is.na(infartoDoMiocardioOnda3))]

idxInfartoDoMiocardioOnda1 <- which(!is.na(infartoDoMiocardioOnda1))
idxInfartoDoMiocardioOnda2 <- which(!is.na(infartoDoMiocardioOnda2))
idxInfartoDoMiocardioOnda3 <- which(!is.na(infartoDoMiocardioOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxInfartoDoMiocardioOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxInfartoDoMiocardioOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxInfartoDoMiocardioOnda3]

################################################################################
###data.frame
################################################################################
infartoDoMiocardioOnda1 <- data.frame(idadeNaOnda1Ajustada, infartoDoMiocardioOnda1Ajustada)
infartoDoMiocardioOnda2 <- data.frame(idadeNaOnda2Ajustada, infartoDoMiocardioOnda2Ajustada)
infartoDoMiocardioOnda3 <- data.frame(idadeNaOnda3Ajustada, infartoDoMiocardioOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(infartoDoMiocardioOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(infartoDoMiocardioOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(infartoDoMiocardioOnda3Ajustada = 0:1)

infartoDoMiocardioOnda1_complet <- merge(all_levels_Onda1, infartoDoMiocardioOnda1, by = "infartoDoMiocardioOnda1Ajustada", all.x = TRUE)
infartoDoMiocardioOnda2_complet <- merge(all_levels_Onda2, infartoDoMiocardioOnda2, by = "infartoDoMiocardioOnda2Ajustada", all.x = TRUE)
infartoDoMiocardioOnda3_complet <- merge(all_levels_Onda3, infartoDoMiocardioOnda3, by = "infartoDoMiocardioOnda3Ajustada", all.x = TRUE)

ggplot(data = infartoDoMiocardioOnda1_complet, aes(x = factor(infartoDoMiocardioOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Infarto do miocardio - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

ggplot(data = infartoDoMiocardioOnda2_complet, aes(x = factor(infartoDoMiocardioOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Infarto do miocardio - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

ggplot(data = infartoDoMiocardioOnda3_complet, aes(x = factor(infartoDoMiocardioOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Infarto do miocardio - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
ggplot(data = infartoDoMiocardioOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(infartoDoMiocardioOnda1Ajustada))) +
  geom_boxplot(aes(group=infartoDoMiocardioOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Infarto do miocardio") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Infarto do miocardio - Onda 1")

ggplot(data = infartoDoMiocardioOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(infartoDoMiocardioOnda2Ajustada))) +
  geom_boxplot(aes(group=infartoDoMiocardioOnda2Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Infarto do miocardio") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Infarto do miocardio - Onda 2")

ggplot(data = infartoDoMiocardioOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(infartoDoMiocardioOnda3Ajustada))) +
  geom_boxplot(aes(group=infartoDoMiocardioOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Infarto do miocardio") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Infarto do miocardio - Onda 3")