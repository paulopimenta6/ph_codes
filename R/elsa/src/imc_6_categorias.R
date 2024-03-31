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
imc6categoriasOnda1Ajustada <- imc6categoriasOnda1[which(!is.na(imc6categoriasOnda1))]
imc6categoriasOnda2Ajustada <- imc6categoriasOnda2[which(!is.na(imc6categoriasOnda2))]
imc6categoriasOnda3Ajustada <- imc6categoriasOnda3[which(!is.na(imc6categoriasOnda3))]

idxImc6categoriasOnda1 <- which(!is.na(imc6categoriasOnda1))
idxImc6categoriasOnda2 <- which(!is.na(imc6categoriasOnda2))
idxImc6categoriasOnda3 <- which(!is.na(imc6categoriasOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxImc6categoriasOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxImc6categoriasOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxImc6categoriasOnda3]

################################################################################
###data.frame
################################################################################
imc6categoriasOnda1 <- data.frame(idadeNaOnda1Ajustada, imc6categoriasOnda1Ajustada)
imc6categoriasOnda2 <- data.frame(idadeNaOnda2Ajustada, imc6categoriasOnda2Ajustada)
imc6categoriasOnda3 <- data.frame(idadeNaOnda3Ajustada, imc6categoriasOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(imc6categoriasOnda1Ajustada = 1:6)
all_levels_Onda2 <- data.frame(imc6categoriasOnda2Ajustada = 1:6)
all_levels_Onda3 <- data.frame(imc6categoriasOnda3Ajustada = 1:6)

imc6categoriasOnda1_complet <- merge(all_levels_Onda1, imc6categoriasOnda1, by = "imc6categoriasOnda1Ajustada", all.x = TRUE)
imc6categoriasOnda2_complet <- merge(all_levels_Onda2, imc6categoriasOnda2, by = "imc6categoriasOnda2Ajustada", all.x = TRUE)
imc6categoriasOnda3_complet <- merge(all_levels_Onda3, imc6categoriasOnda3, by = "imc6categoriasOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = imc6categoriasOnda1_complet, aes(x = factor(imc6categoriasOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("IMC em 6 niveis - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "1 - Magreza, 2 - Eutrofia, 3 - Sobrepeso, 4 - Obesidade Grau I, 5 - Obesidade Grau II, 6 - Obesidade Grau III")

#Onda 2
ggplot(data = imc6categoriasOnda2_complet, aes(x = factor(imc6categoriasOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("IMC em 6 niveis - Onda 1") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "1 - Magreza, 2 - Eutrofia, 3 - Sobrepeso, 4 - Obesidade Grau I, 5 - Obesidade Grau II, 6 - Obesidade Grau III")

#Onda 3
ggplot(data = imc6categoriasOnda3_complet, aes(x = factor(imc6categoriasOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("IMC em 6 niveis - Onda 1") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "1 - Magreza, 2 - Eutrofia, 3 - Sobrepeso, 4 - Obesidade Grau I, 5 - Obesidade Grau II, 6 - Obesidade Grau III")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = imc6categoriasOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(imc6categoriasOnda1Ajustada))) +
  geom_boxplot(aes(group=imc6categoriasOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "IMC") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("IMC em 6 níveis - Onda 1")

###Onda 2
ggplot(data = imc6categoriasOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(imc6categoriasOnda2Ajustada))) +
  geom_boxplot(aes(group=imc6categoriasOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "IMC") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("IMC em 6 níveis - Onda 2")

###Onda 3
ggplot(data = imc6categoriasOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(imc6categoriasOnda3Ajustada))) +
  geom_boxplot(aes(group=imc6categoriasOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "IMC") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("IMC em 6 níveis - Onda 3")
