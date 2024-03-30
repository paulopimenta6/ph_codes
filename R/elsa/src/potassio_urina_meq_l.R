############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src") {   ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src")            ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
###potassio - urina
################################################################################
potassioOnda1Ajustada <- potassioOnda1[which(!is.na(potassioOnda1))]
potassioOnda2Ajustada <- potassioOnda2[which(!is.na(potassioOnda2))]
potassioOnda3Ajustada <- potassioOnda3[which(!is.na(potassioOnda3))]

idxPotassioOnda1 <- which(!is.na(potassioOnda1))
idxPotassioOnda2 <- which(!is.na(potassioOnda2))
idxPotassioOnda3 <- which(!is.na(potassioOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxPotassioOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxPotassioOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxPotassioOnda3]

potassioUrinaOnda1 <- data.frame(idadeNaOnda1Ajustada, potassioOnda1Ajustada)
potassioUrinaOnda2 <- data.frame(idadeNaOnda2Ajustada, potassioOnda2Ajustada)
potassioUrinaOnda3 <- data.frame(idadeNaOnda3Ajustada, potassioOnda3Ajustada)

################################################################################
###Graficos
################################################################################
#Onda 1
ggplot(data = potassioUrinaOnda1, aes(x = potassioOnda1Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Ajustada))) +
  ggtitle("Sódio - Onda 1") +
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas", x = "Potássio (meq/l)")

#Onda 1
ggplot(data = potassioUrinaOnda2, aes(x = potassioOnda2Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Ajustada))) +
  ggtitle("Potássio - Onda 2") +
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas", x = "Potássio (meq/l)")

#Onda 3
ggplot(data = potassioUrinaOnda3, aes(x = potassioOnda3Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Ajustada))) +
  ggtitle("Potássio - Onda 3") +
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas", x = "Potássio (meq/l)")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = potassioUrinaOnda1, aes(x = idadeNaOnda1Ajustada, y = potassioOnda1Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda1Ajustada)) +
  labs(x = "Idade na Onda 1", y = "Potássio (meq/l) - Onda 1") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Potássio - Onda 1")

###Onda 2
ggplot(data = potassioUrinaOnda2, aes(x = idadeNaOnda2Ajustada, y = potassioOnda2Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda2Ajustada)) +
  labs(x = "Idade na Onda 2", y = "Potássio (meq/l) - Onda 2") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Potássio - Onda 2")

###Onda 3
ggplot(data = potassioUrinaOnda3, aes(x = idadeNaOnda3Ajustada, y = potassioOnda3Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda3Ajustada)) +
  labs(x = "Idade na Onda 3", y = "Potássio (meq/l) - Onda 3") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Potássio - Onda 3")