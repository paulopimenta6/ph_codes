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
tomaAntiHipertensivosOnda1Ajustada <- tomaAntiHipertensivosOnda1[which(!is.na(tomaAntiHipertensivosOnda1))]
tomaAntiHipertensivosOnda2Ajustada <- tomaAntiHipertensivosOnda2[which(!is.na(tomaAntiHipertensivosOnda2))]
tomaAntiHipertensivosOnda3Ajustada <- tomaAntiHipertensivosOnda3[which(!is.na(tomaAntiHipertensivosOnda3))]

idxTomaAntiHipertensivosOnda1 <- which(!is.na(tomaAntiHipertensivosOnda1))
idxTomaAntiHipertensivosOnda2 <- which(!is.na(tomaAntiHipertensivosOnda2))
idxTomaAntiHipertensivosOnda3 <- which(!is.na(tomaAntiHipertensivosOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxTomaAntiHipertensivosOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxTomaAntiHipertensivosOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxTomaAntiHipertensivosOnda3]

tomaAntiHipertensivosOnda1 <- data.frame(idadeNaOnda1Ajustada, tomaAntiHipertensivosOnda1Ajustada)
tomaAntiHipertensivosOnda2 <- data.frame(idadeNaOnda2Ajustada, tomaAntiHipertensivosOnda2Ajustada)
tomaAntiHipertensivosOnda3 <- data.frame(idadeNaOnda3Ajustada, tomaAntiHipertensivosOnda3Ajustada) 

################################################################################
###Graficos
################################################################################
#Onda 1
ggplot(data = tomaAntiHipertensivosOnda1, aes(x = tomaAntiHipertensivosOnda1Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Ajustada))) +
  ggtitle("Faz uso de anti Hipertêmico - Onda 1") +
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas", x = "0: Não 1: Sim")

#Onda 2
ggplot(data = tomaAntiHipertensivosOnda2, aes(x = tomaAntiHipertensivosOnda2Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Ajustada))) +
  ggtitle("Faz uso de anti Hipertêmico - Onda 2") +
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas", x = "0: Não 1: Sim")

#Onda 3
ggplot(data = tomaAntiHipertensivosOnda3, aes(x = tomaAntiHipertensivosOnda3Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Ajustada))) +
  ggtitle("Faz uso de anti Hipertêmico - Onda 3") +
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas", x = "0: Não 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = tomaAntiHipertensivosOnda1, aes(y = idadeNaOnda1Ajustada, x = tomaAntiHipertensivosOnda1Ajustada)) +
  geom_boxplot(aes(group=tomaAntiHipertensivosOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "0: Não 1: Sim") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Faz uso de anti hipertêmico - Onda 1")

###Onda 1
ggplot(data = tomaAntiHipertensivosOnda2, aes(y = idadeNaOnda2Ajustada, x = tomaAntiHipertensivosOnda2Ajustada)) +
  geom_boxplot(aes(group=tomaAntiHipertensivosOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "0: Não 1: Sim") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Faz uso de anti hipertêmico - Onda 2")

###Onda 1
ggplot(data = tomaAntiHipertensivosOnda3, aes(y = idadeNaOnda3Ajustada, x = tomaAntiHipertensivosOnda3Ajustada)) +
  geom_boxplot(aes(group=tomaAntiHipertensivosOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "0: Não 1: Sim") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Faz uso de anti hipertêmico - Onda 3")