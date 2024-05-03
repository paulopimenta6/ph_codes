############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R")  
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
creatininaRastreavelNoSangueOnda1Ajustada <- creatininaRastreavelNoSangueOnda1[which(!(is.na(creatininaRastreavelNoSangueOnda1) | creatininaRastreavelNoSangueOnda1 > 3))]
creatininaRastreavelNoSangueOnda2Ajustada <- creatininaRastreavelNoSangueOnda2[which(!(is.na(creatininaRastreavelNoSangueOnda2) | creatininaRastreavelNoSangueOnda2 > 3))]
creatininaRastreavelNoSangueOnda3Ajustada <- creatininaRastreavelNoSangueOnda3[which(!(is.na(creatininaRastreavelNoSangueOnda3) | creatininaRastreavelNoSangueOnda3 > 3))]

idxCreatininaRastreavelNoSangueOnda1 <- which(!(is.na(creatininaRastreavelNoSangueOnda1) | creatininaRastreavelNoSangueOnda1 > 3))
idxCreatininaRastreavelNoSangueOnda2 <- which(!(is.na(creatininaRastreavelNoSangueOnda2) | creatininaRastreavelNoSangueOnda2 > 3))
idxCreatininaRastreavelNoSangueOnda3 <- which(!(is.na(creatininaRastreavelNoSangueOnda3) | creatininaRastreavelNoSangueOnda3 > 3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxCreatininaRastreavelNoSangueOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxCreatininaRastreavelNoSangueOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxCreatininaRastreavelNoSangueOnda3]

################################################################################
###data frame
################################################################################
creatininaRastreavelNoSangueOnda1 <- data.frame(idadeNaOnda1Ajustada, creatininaRastreavelNoSangueOnda1Ajustada)
creatininaRastreavelNoSangueOnda2 <- data.frame(idadeNaOnda2Ajustada, creatininaRastreavelNoSangueOnda2Ajustada)
creatininaRastreavelNoSangueOnda3 <- data.frame(idadeNaOnda3Ajustada, creatininaRastreavelNoSangueOnda3Ajustada)

################################################################################
###Graficos
################################################################################
#Onda 1
ggplot(data = creatininaRastreavelNoSangueOnda1, aes(x = creatininaRastreavelNoSangueOnda1Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Ajustada))) +
  ggtitle("Creatina rastreavel no sangue - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "Concentração em mg/dl")

#Onda 2
ggplot(data = creatininaRastreavelNoSangueOnda2, aes(x = creatininaRastreavelNoSangueOnda2Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Ajustada))) +
  ggtitle("Creatinina rastreavel no sangue - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "Concentração em mg/dl")

#Onda 3
ggplot(data = creatininaRastreavelNoSangueOnda3, aes(x = creatininaRastreavelNoSangueOnda3Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Ajustada))) +
  ggtitle("Creatinina rastreavel no sangue - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "Concentração em mg/dl")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = creatininaRastreavelNoSangueOnda1, aes(x = idadeNaOnda1Ajustada, y = creatininaRastreavelNoSangueOnda1Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda1Ajustada)) +
  labs(x = "Idade na Onda 1", y = "Concentração em mg/dl") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Creatinina rastreavel no sangue - Onda 1")

###Onda 2
ggplot(data = creatininaRastreavelNoSangueOnda2, aes(x = idadeNaOnda2Ajustada, y = creatininaRastreavelNoSangueOnda2Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda2Ajustada)) +
  labs(x = "Idade na Onda 2", y = "Concentração em mg/dl") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Creatinina rastreavel no sangue - Onda 2")

###Onda 3
ggplot(data = creatininaRastreavelNoSangueOnda3, aes(x = idadeNaOnda3Ajustada, y = creatininaRastreavelNoSangueOnda3Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda3Ajustada)) +
  labs(x = "Idade na Onda 3", y = "Concentração em mg/dl") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Creatinina rastreavel no sangue - Onda 3")