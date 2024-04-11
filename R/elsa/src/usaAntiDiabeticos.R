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
tomaAntidiabeticosOraisOnda1Ajustada <- tomaAntidiabeticosOraisOnda1[which(!is.na(tomaAntidiabeticosOraisOnda1))] 
tomaAntidiabeticosOraisOnda2Ajustada <- tomaAntidiabeticosOraisOnda2[which(!is.na(tomaAntidiabeticosOraisOnda2))]
tomaAntidiabeticosOraisOnda3Ajustada <- tomaAntidiabeticosOraisOnda3[which(!is.na(tomaAntidiabeticosOraisOnda3))]

idxTomaAntidiabeticosOraisOnda1 <- which(!is.na(tomaAntidiabeticosOraisOnda1)) 
idxTomaAntidiabeticosOraisOnda2 <- which(!is.na(tomaAntidiabeticosOraisOnda2))
idxTomaAntidiabeticosOraisOnda3 <- which(!is.na(tomaAntidiabeticosOraisOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxTomaAntidiabeticosOraisOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxTomaAntidiabeticosOraisOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxTomaAntidiabeticosOraisOnda3]

################################################################################
###data.frame
################################################################################
tomaAntidiabeticosOraisOnda1 <- data.frame(idadeNaOnda1Ajustada, tomaAntidiabeticosOraisOnda1Ajustada)
tomaAntidiabeticosOraisOnda2 <- data.frame(idadeNaOnda2Ajustada, tomaAntidiabeticosOraisOnda2Ajustada)
tomaAntidiabeticosOraisOnda3 <- data.frame(idadeNaOnda3Ajustada, tomaAntidiabeticosOraisOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(tomaAntidiabeticosOraisOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(tomaAntidiabeticosOraisOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(tomaAntidiabeticosOraisOnda3Ajustada = 0:1)

tomaAntidiabeticosOraisOnda1_complet <- merge(all_levels_Onda1, tomaAntidiabeticosOraisOnda1, by = "tomaAntidiabeticosOraisOnda1Ajustada", all.x = TRUE)
tomaAntidiabeticosOraisOnda2_complet <- merge(all_levels_Onda2, tomaAntidiabeticosOraisOnda2, by = "tomaAntidiabeticosOraisOnda2Ajustada", all.x = TRUE)
tomaAntidiabeticosOraisOnda3_complet <- merge(all_levels_Onda3, tomaAntidiabeticosOraisOnda3, by = "tomaAntidiabeticosOraisOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = tomaAntidiabeticosOraisOnda1_complet, aes(x = factor(tomaAntidiabeticosOraisOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso de anti diabéticos - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = tomaAntidiabeticosOraisOnda2_complet, aes(x = factor(tomaAntidiabeticosOraisOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso de anti diabéticos - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = tomaAntidiabeticosOraisOnda3_complet, aes(x = factor(tomaAntidiabeticosOraisOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso de anti diabéticos - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = tomaAntidiabeticosOraisOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(tomaAntidiabeticosOraisOnda1Ajustada))) +
  geom_boxplot(aes(group=tomaAntidiabeticosOraisOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de anti diabéticos") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de anti diabéticos - Onda 1")

###Onda 2
ggplot(data = tomaAntidiabeticosOraisOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(tomaAntidiabeticosOraisOnda2Ajustada))) +
  geom_boxplot(aes(group=tomaAntidiabeticosOraisOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de anti diabéticos") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de anti diabéticos - Onda 2")

###Onda 3
ggplot(data = tomaAntidiabeticosOraisOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(tomaAntidiabeticosOraisOnda3Ajustada))) +
  geom_boxplot(aes(group=tomaAntidiabeticosOraisOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de anti diabéticos") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de anti diabéticos - Onda 3")