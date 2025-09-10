source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
presencaDeHipertensaoArterialSistemicaOnda1Ajustada <- presencaDeHipertensaoArterialSistemicaOnda1[which(!is.na(presencaDeHipertensaoArterialSistemicaOnda1))]
presencaDeHipertensaoArterialSistemicaOnda2Ajustada <- presencaDeHipertensaoArterialSistemicaOnda2[which(!is.na(presencaDeHipertensaoArterialSistemicaOnda2))]
presencaDeHipertensaoArterialSistemicaOnda3Ajustada <- presencaDeHipertensaoArterialSistemicaOnda3[which(!is.na(presencaDeHipertensaoArterialSistemicaOnda3))]

idxPresencaDeHipertensaoArterialSistemicaOnda1 <- which(!is.na(presencaDeHipertensaoArterialSistemicaOnda1))
idxPresencaDeHipertensaoArterialSistemicaOnda2 <- which(!is.na(presencaDeHipertensaoArterialSistemicaOnda2))
idxPresencaDeHipertensaoArterialSistemicaOnda3 <- which(!is.na(presencaDeHipertensaoArterialSistemicaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxPresencaDeHipertensaoArterialSistemicaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxPresencaDeHipertensaoArterialSistemicaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxPresencaDeHipertensaoArterialSistemicaOnda3]

presencaDeHipertensaoArterialSistemicaOnda1 <- data.frame(idadeNaOnda1Ajustada, presencaDeHipertensaoArterialSistemicaOnda1Ajustada)
presencaDeHipertensaoArterialSistemicaOnda2 <- data.frame(idadeNaOnda2Ajustada, presencaDeHipertensaoArterialSistemicaOnda2Ajustada)
presencaDeHipertensaoArterialSistemicaOnda3 <- data.frame(idadeNaOnda3Ajustada, presencaDeHipertensaoArterialSistemicaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
#Onda 1
ggplot(data = presencaDeHipertensaoArterialSistemicaOnda1, aes(x = presencaDeHipertensaoArterialSistemicaOnda1Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Ajustada))) +
  ggtitle("Presença de Hipertensão Sistêmica - Onda 1") +
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas", x = "0: Não 1: Sim")

#Onda 2
ggplot(data = presencaDeHipertensaoArterialSistemicaOnda2, aes(x = presencaDeHipertensaoArterialSistemicaOnda2Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Ajustada))) +
  ggtitle("Presença de Hipertensão Sistêmica - Onda 2") +
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas", x = "0: Não 1: Sim")

#Onda 3
ggplot(data = presencaDeHipertensaoArterialSistemicaOnda3, aes(x = presencaDeHipertensaoArterialSistemicaOnda3Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Ajustada))) +
  ggtitle("Presença de Hipertensão Sistêmica - Onda 3") +
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas", x = "0: Não 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = presencaDeHipertensaoArterialSistemicaOnda1, aes(y = idadeNaOnda1Ajustada, x = presencaDeHipertensaoArterialSistemicaOnda1Ajustada)) +
  geom_boxplot(aes(group=presencaDeHipertensaoArterialSistemicaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "0: Não 1: Sim") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Presença Arterial Sistêmica - Onda 1")

###Onda 2
ggplot(data = presencaDeHipertensaoArterialSistemicaOnda2, aes(y = idadeNaOnda2Ajustada, x = presencaDeHipertensaoArterialSistemicaOnda2Ajustada)) +
  geom_boxplot(aes(group=presencaDeHipertensaoArterialSistemicaOnda2Ajustada)) +
  labs(y = "Idade na Onda 1", x = "0: Não 1: Sim") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Presença Arterial Sistêmica - Onda 2")

###Onda 3
ggplot(data = presencaDeHipertensaoArterialSistemicaOnda3, aes(y = idadeNaOnda3Ajustada, x = presencaDeHipertensaoArterialSistemicaOnda3Ajustada)) +
  geom_boxplot(aes(group=presencaDeHipertensaoArterialSistemicaOnda3Ajustada)) +
  labs(y = "Idade na Onda 1", x = "0: Não 1: Sim") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Presença Arterial Sistêmica - Onda 3")