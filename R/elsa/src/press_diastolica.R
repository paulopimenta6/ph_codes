############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src") {   ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src")            ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)

idxPressaoDiastolicamediaOnda1 <- which(!(is.na(pressaoDiastolicamediaOnda1)))
idxPressaoDiastolicamediaOnda2 <- which(!(is.na(pressaoDiastolicamediaOnda2)))
idxPressaoDiastolicamediaOnda3 <- which(!(is.na(pressaoDiastolicamediaOnda3)))

pressaoDiastolicamediaOnda1 <- pressaoDiastolicamediaOnda1[which(!(is.na(pressaoDiastolicamediaOnda1)))]
pressaoDiastolicamediaOnda2 <- pressaoDiastolicamediaOnda2[which(!(is.na(pressaoDiastolicamediaOnda2)))]
pressaoDiastolicamediaOnda3 <- pressaoDiastolicamediaOnda3[which(!(is.na(pressaoDiastolicamediaOnda3)))]

idadeNaOnda1Pres <- idadeNaOnda1[idxPressaoDiastolicamediaOnda1]
idadeNaOnda2Pres <- idadeNaOnda2[idxPressaoDiastolicamediaOnda2]
idadeNaOnda3Pres <- idadeNaOnda3[idxPressaoDiastolicamediaOnda3]

presDiastolicaOnda1 <- data.frame(idadeNaOnda1Pres, pressaoDiastolicamediaOnda1)
presDiastolicaOnda2 <- data.frame(idadeNaOnda2Pres, pressaoDiastolicamediaOnda2)
presDiastolicaOnda3 <- data.frame(idadeNaOnda3Pres, pressaoDiastolicamediaOnda3)

ggplot(data = presDiastolicaOnda1, aes(x = pressaoDiastolicamediaOnda1)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Pres))) + 
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "pressão arterial diastólica média (mmhg) - onda 1")


ggplot(data = presDiastolicaOnda2, aes(x = pressaoDiastolicamediaOnda2)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Pres))) + 
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "pressão arterial diastólica média (mmhg) - onda 2")

ggplot(data = presDiastolicaOnda3, aes(x = pressaoDiastolicamediaOnda3)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Pres))) + 
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "pressão arterial diastólica média (mmhg) - onda 3")

##boxplot
#boxplot(idadeNaOnda1Pres~presDiastolicaOnda1$pressaoDiastolicamediaOnda1, data=presDiastolicaOnda1)
#boxplot(idadeNaOnda2Pres~presDiastolicaOnda2$pressaoDiastolicamediaOnda2, data=presDiastolicaOnda2)
#boxplot(idadeNaOnda3Pres~presDiastolicaOnda3$pressaoDiastolicamediaOnda3, data=presDiastolicaOnda3)

ggplot(data = presDiastolicaOnda1, aes(x = idadeNaOnda1Pres, y = pressaoDiastolicamediaOnda1)) +
  geom_boxplot(aes(group=idadeNaOnda1Pres)) +
  labs(y = "pressão arterial diastólica média (mmhg)", x = "Idade") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Onda 1")


ggplot(data = presDiastolicaOnda2, aes(x = idadeNaOnda2Pres, y = pressaoDiastolicamediaOnda2)) +
  geom_boxplot(aes(group=idadeNaOnda2Pres)) +
  labs(y = "pressão arterial diastólica média (mmhg)", x = "Idade") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Onda 2")

ggplot(data = presDiastolicaOnda3, aes(x = idadeNaOnda3Pres, y = pressaoDiastolicamediaOnda3)) +
  geom_boxplot(aes(group=idadeNaOnda3Pres)) +
  labs(y = "pressão arterial diastólica média (mmhg)", x = "Idade") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Onda 3")

