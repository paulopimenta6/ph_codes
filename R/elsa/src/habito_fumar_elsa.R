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

ggplot(data = importaDadosLib, mapping = aes(x=(habitoDeFumarOnda1))) + geom_bar() + xlab("Pacientes com habito de fumar na Onda 1 - 0: nunca fumou, 1: ex-fumante e 2: fumante") + ylab("Quantidade da amostra na Onda 1")
ggplot(data =importaDadosLib, mapping = aes(x=(habitoDeFumarOnda2))) + geom_bar() + xlab("Pacientes com habito de fumar na Onda 2 - 0: nunca fumou, 1: ex-fumante e 2: fumante") + ylab("Quantidade da amostra na Onda 2")
ggplot(data = importaDadosLib, mapping = aes(x=(habitoDeFumarOnda3))) + geom_bar() + xlab("Pacientes com habito de fumar na Onda 3 - 0: nunca fumou, 3: ex-fumante e 2: fumante") + ylab("Quantidade da amostra na Onda 3")

###Ajustando grafico
indicesHabitoDeFumarOnda1 <- which(!(is.na(habitoDeFumarOnda1)))
indicesHabitoDeFumarOnda2 <- which(!(is.na(habitoDeFumarOnda2)))
indicesHabitoDeFumarOnda3 <- which(!(is.na(habitoDeFumarOnda3)))

habitoDeFumarOnda1Ajustado <- habitoDeFumarOnda1[!(is.na(habitoDeFumarOnda1))]
habitoDeFumarOnda2Ajustado <- habitoDeFumarOnda2[!(is.na(habitoDeFumarOnda2))]
habitoDeFumarOnda3Ajustado <- habitoDeFumarOnda3[!(is.na(habitoDeFumarOnda3))]

idadeNaOnda1Ajustado <- idadeNaOnda1[indicesHabitoDeFumarOnda1]
idadeNaOnda2Ajustado <- idadeNaOnda2[indicesHabitoDeFumarOnda2]
idadeNaOnda3Ajustado <- idadeNaOnda3[indicesHabitoDeFumarOnda3]

habitoDeFumarOnda1Ajustado <- data.frame(idadeNaOnda1Ajustado, habitoDeFumarOnda1Ajustado)
habitoDeFumarOnda2Ajustado <- data.frame(idadeNaOnda2Ajustado, habitoDeFumarOnda2Ajustado)
habitoDeFumarOnda3Ajustado <- data.frame(idadeNaOnda3Ajustado, habitoDeFumarOnda3Ajustado)

ggplot(data = habitoDeFumarOnda1Ajustado, aes(x = habitoDeFumarOnda1Ajustado)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Ajustado))) + 
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "Pacientes com habito de fumar - 0: nunca fumou, 3: ex-fumante e 2: fumante - Onda 1")

ggplot(data = habitoDeFumarOnda2Ajustado, aes(x = habitoDeFumarOnda2Ajustado)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Ajustado))) + 
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "Pacientes com habito de fumar - 0: nunca fumou, 3: ex-fumante e 2: fumante - Onda 2")

ggplot(data = habitoDeFumarOnda3Ajustado, aes(x = habitoDeFumarOnda3Ajustado)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Ajustado))) + 
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "Pacientes com habito de fumar - 0: nunca fumou, 3: ex-fumante e 2: fumante - Onda 3")
