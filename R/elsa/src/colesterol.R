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
###Colesterol
################################################################################
###colesterol total
colesterolTotalOnda1Ajustada1 <- colesterolTotalOnda1[which(!is.na(colesterolTotalOnda1))]
colesterolTotalOnda2Ajustada2 <- colesterolTotalOnda2[which(!is.na(colesterolTotalOnda2))]
colesterolTotalOnda3Ajustada3 <- colesterolTotalOnda3[which(!is.na(colesterolTotalOnda3))]

###colesterol hdl
colesterolHdlOnda1Ajustada1 <- colesterolHdlOnda1[which(!is.na(colesterolHdlOnda1))]
colesterolHdlOnda2Ajustada2 <- colesterolHdlOnda2[which(!is.na(colesterolHdlOnda2))]
colesterolHdlOnda3Ajustada3 <- colesterolHdlOnda3[which(!is.na(colesterolHdlOnda3))]

##colesterol ldl
colesterolLdlOnda1Ajustada1 <- colesterolLdlOnda1[which(!is.na(colesterolLdlOnda1))]
colesterolLdlOnda2Ajustada2 <- colesterolLdlOnda2[which(!is.na(colesterolLdlOnda2))]  
colesterolLdlOnda3Ajustada3 <- colesterolLdlOnda3[which(!is.na(colesterolLdlOnda3))]
################################################################################
###Idades
################################################################################
#indices
IdxcolesterolTotalOnda1Ajustada1 <- which(!is.na(colesterolTotalOnda1))
IdxcolesterolTotalOnda2Ajustada2 <- which(!is.na(colesterolTotalOnda2))
IdxcolesterolTotalOnda3Ajustada3 <- which(!is.na(colesterolTotalOnda3))

###colesterol hdl
IdxcolesterolHdlOnda1Ajustada1 <- which(!is.na(colesterolHdlOnda1))
IdxcolesterolHdlOnda2Ajustada2 <- which(!is.na(colesterolHdlOnda2))
IdxcolesterolHdlOnda3Ajustada3 <- which(!is.na(colesterolHdlOnda3))

##colesterol ldl
IdxcolesterolLdlOnda1Ajustada1 <- which(!is.na(colesterolLdlOnda1))
IdxcolesterolLdlOnda2Ajustada2 <- which(!is.na(colesterolLdlOnda2))  
IdxcolesterolLdlOnda3Ajustada3 <- which(!is.na(colesterolLdlOnda3))
################################################################################
#Idades
################################################################################
idadeColTotalOnda1 <- idadeNaOnda1[IdxcolesterolTotalOnda1Ajustada1] 
idadeColTotalOnda2 <- idadeNaOnda2[IdxcolesterolTotalOnda2Ajustada2]
idadeColTotalOnda3 <- idadeNaOnda3[IdxcolesterolTotalOnda3Ajustada3]

###colesterol hdl
idadehdlOnda1 <- idadeNaOnda1[IdxcolesterolHdlOnda1Ajustada1]
idadehdlOnda2 <- idadeNaOnda2[IdxcolesterolHdlOnda2Ajustada2]
idadehdlOnda3 <- idadeNaOnda3[IdxcolesterolHdlOnda3Ajustada3]

##colesterol ldl
idadeLdlOnda1 <- idadeNaOnda1[IdxcolesterolLdlOnda1Ajustada1] 
idadeLdlOnda2 <- idadeNaOnda2[IdxcolesterolLdlOnda2Ajustada2]
idadeLdlOnda3 <- idadeNaOnda3[IdxcolesterolLdlOnda3Ajustada3]

################################################################################
###Criando Data Frames
################################################################################
colesterolTotalOnda1 <- data.frame(idadeColTotalOnda1, colesterolTotalOnda1Ajustada1)
colesterolTotalOnda2 <- data.frame(idadeColTotalOnda2, colesterolTotalOnda2Ajustada2)
colesterolTotalOnda3 <- data.frame(idadeColTotalOnda3, colesterolTotalOnda3Ajustada3)

colesterolHdlOnda1 <- data.frame(idadehdlOnda1, colesterolHdlOnda1Ajustada1)
colesterolHdlOnda2 <- data.frame(idadehdlOnda2, colesterolHdlOnda2Ajustada2)
colesterolHdlOnda3 <- data.frame(idadehdlOnda3, colesterolHdlOnda3Ajustada3)

colesterolLdlOnda1 <- data.frame(idadeLdlOnda1, colesterolLdlOnda1Ajustada1)
colesterolLdlOnda2 <- data.frame(idadeLdlOnda2, colesterolLdlOnda2Ajustada2)  
colesterolLdlOnda3 <- data.frame(idadeLdlOnda3,colesterolLdlOnda3Ajustada3)

################################################################################
###Graficos
################################################################################
###Colesterol Total
ggplot(data = colesterolTotalOnda1, aes(x = colesterolTotalOnda1Ajustada1)) + 
  geom_bar(aes(fill=as.factor(idadeColTotalOnda1))) + 
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "Colesterol Total (mg/dl) - Onda 1")

ggplot(data = colesterolTotalOnda2, aes(x = colesterolTotalOnda2Ajustada2)) + 
  geom_bar(aes(fill=as.factor(idadeColTotalOnda2))) + 
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "Colesterol Total (mg/dl) - Onda 2")

ggplot(data = colesterolTotalOnda3, aes(x = colesterolTotalOnda3Ajustada3)) + 
  geom_bar(aes(fill=as.factor(idadeColTotalOnda3))) + 
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "Colesterol Total (mg/dl) - Onda 3")

###Colesterol HDL
ggplot(data = colesterolHdlOnda1, aes(x = colesterolHdlOnda1Ajustada1)) + 
  geom_bar(aes(fill=as.factor(idadehdlOnda1))) + 
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "Colesterol HDL (mg/dl) - Onda 1")

ggplot(data = colesterolHdlOnda2, aes(x = colesterolHdlOnda2Ajustada2)) + 
  geom_bar(aes(fill=as.factor(idadehdlOnda2))) + 
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "Colesterol HDL (mg/dl) - Onda 2")

ggplot(data = colesterolHdlOnda3, aes(x = colesterolHdlOnda3Ajustada3)) + 
  geom_bar(aes(fill=as.factor(idadehdlOnda3))) + 
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "Colesterol HDL (mg/dl) - Onda 3")

###Colesterol LDL
ggplot(data = colesterolLdlOnda1, aes(x = colesterolLdlOnda1Ajustada1)) + 
  geom_bar(aes(fill=as.factor(idadeLdlOnda1))) + 
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "Colesterol LDL (mg/dl) - Onda 1")

ggplot(data = colesterolLdlOnda2, aes(x = colesterolLdlOnda2Ajustada2)) + 
  geom_bar(aes(fill=as.factor(idadeLdlOnda2))) + 
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "Colesterol LDL (mg/dl) - Onda 2")

ggplot(data = colesterolLdlOnda3, aes(x = colesterolLdlOnda3Ajustada3)) + 
  geom_bar(aes(fill=as.factor(idadeLdlOnda3))) + 
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "Colesterol LDL (mg/dl) - Onda 3")
