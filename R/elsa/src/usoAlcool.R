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
usoDeAlcoolOnda1Ajustada <- usoDeAldoolOnda1[which(!is.na(usoDeAlcoolOnda1))]
usoDeAlcoolOnda2Ajustada <- usoDeAldoolOnda2[which(!is.na(usoDeAlcoolOnda2))]
usoDeAlcoolOnda3Ajustada <- usoDeAldoolOnda3[which(!is.na(usoDeAlcoolOnda3))]

idxUsoDeAlcoolOnda1 <- which(!is.na(usoDeAlcoolOnda1))
idxUsoDeAlcoolOnda2 <- which(!is.na(usoDeAlcoolOnda2))
idxUsoDeAlcoolOnda3 <- which(!is.na(usoDeAlcoolOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxUsoDeAlcoolOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxUsoDeAlcoolOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxUsoDeAlcoolOnda3]

usoDeAlcoolOnda1 <- data.frame(idadeNaOnda1Ajustada, usoDeAlcoolOnda1Ajustada)
usoDeAlcoolOnda2 <- data.frame(idadeNaOnda2Ajustada, usoDeAlcoolOnda2Ajustada)
usoDeAlcoolOnda3 <- data.frame(idadeNaOnda3Ajustada, usoDeAlcoolOnda3Ajustada)

################################################################################
###Graficos
################################################################################
#Onda 1
ggplot(data = usoDeAlcoolOnda1, aes(x = usoDeAlcoolOnda1Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Ajustada))) +
  ggtitle("Consumo de álcool - Onda 1") +
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas", x = "0: Não usuário, 1: Ex-usuário, 2 - Usuário")

#Onda 2
ggplot(data = usoDeAlcoolOnda2, aes(x = usoDeAlcoolOnda2Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Ajustada))) +
  ggtitle("Consumo de álcool - Onda 2") +
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas", x = "0: Não usuário, 1: Ex-usuário, 2 - Usuário")

#Onda 3
ggplot(data = usoDeAlcoolOnda3, aes(x = usoDeAlcoolOnda3Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Ajustada))) +
  ggtitle("Consumo de álcool - Onda 3") +
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas", x = "0: Não usuário, 1: Ex-usuário, 2 - Usuário")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = usoDeAlcoolOnda1, aes(y = idadeNaOnda1Ajustada, x = usoDeAlcoolOnda1Ajustada)) +
  geom_boxplot(aes(group=usoDeAlcoolOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "0: Não usuário, 1: Ex-usuário, 2 - Usuário") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Consumo de álcool - Onda 1")

###Onda 2
ggplot(data = usoDeAlcoolOnda2, aes(y = idadeNaOnda2Ajustada, x = usoDeAlcoolOnda2Ajustada)) +
  geom_boxplot(aes(group=usoDeAlcoolOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "0: Não usuário, 1: Ex-usuário, 2 - Usuário") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Consumo de álcool - Onda 2")

###Onda 3
ggplot(data = usoDeAlcoolOnda3, aes(y = idadeNaOnda3Ajustada, x = usoDeAlcoolOnda3Ajustada)) +
  geom_boxplot(aes(group=usoDeAlcoolOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "0: Não usuário, 1: Ex-usuário, 2 - Usuário") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Consumo de álcool - Onda 3")