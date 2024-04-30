############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
creatininaRastreavelNaUrinaOnda1Ajustada <- creatininaRastreavelNaUrinaOnda1[which(!(is.na(creatininaRastreavelNaUrinaOnda1) | creatininaRastreavelNaUrinaOnda1 > 400))]
creatininaRastreavelNaUrinaOnda2Ajustada <- creatininaRastreavelNaUrinaOnda2[which(!is.na(creatininaRastreavelNaUrinaOnda2))]
creatininaRastreavelNaUrinaOnda3Ajustada <- creatininaRastreavelNaUrinaOnda3[which(!(is.na(creatininaRastreavelNaUrinaOnda3) | creatininaRastreavelNaUrinaOnda3 > 400))]

idxCreatininaRastreavelNaUrinaOnda1 <- which(!(is.na(creatininaRastreavelNaUrinaOnda1) | creatininaRastreavelNaUrinaOnda1 > 400))
idxCreatininaRastreavelNaUrinaOnda2 <- which(!is.na(creatininaRastreavelNaUrinaOnda2))
idxCreatininaRastreavelNaUrinaOnda3 <- which(!(is.na(creatininaRastreavelNaUrinaOnda3) | creatininaRastreavelNaUrinaOnda3 > 400))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxCreatininaRastreavelNaUrinaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxCreatininaRastreavelNaUrinaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxCreatininaRastreavelNaUrinaOnda3]

################################################################################
###data frame
################################################################################
creatininaRastreavelNaUrinaOnda1 <- data.frame(idadeNaOnda1Ajustada, creatininaRastreavelNaUrinaOnda1Ajustada)
creatininaRastreavelNaUrinaOnda2 <- data.frame(idadeNaOnda2Ajustada, creatininaRastreavelNaUrinaOnda2Ajustada)
creatininaRastreavelNaUrinaOnda3 <- data.frame(idadeNaOnda3Ajustada, creatininaRastreavelNaUrinaOnda3Ajustada)

###Graficos
################################################################################
#Onda 1
ggplot(data = creatininaRastreavelNaUrinaOnda1, aes(x = creatininaRastreavelNaUrinaOnda1Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Ajustada))) +
  ggtitle("Creatina rastreavel na urina - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "Concentração em mg/dl")

#Onda 2
ggplot(data = creatininaRastreavelNaUrinaOnda2, aes(x = creatininaRastreavelNaUrinaOnda2Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Ajustada))) +
  ggtitle("Creatina rastreavel na urina - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "Concentração em mg/dl")

#Onda 3
ggplot(data = creatininaRastreavelNaUrinaOnda3, aes(x = creatininaRastreavelNaUrinaOnda3Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Ajustada))) +
  ggtitle("Creatina rastreavel na urina - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "Concentração em mg/dl")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = creatininaRastreavelNaUrinaOnda1, aes(x = idadeNaOnda1Ajustada, y = creatininaRastreavelNaUrinaOnda1Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda1Ajustada)) +
  labs(x = "Idade na Onda 1", y = "Concentração em mg/dl") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Creatinina rastreavel na urina - Onda 1")

###Onda 2
ggplot(data = creatininaRastreavelNaUrinaOnda2, aes(x = idadeNaOnda2Ajustada, y = creatininaRastreavelNaUrinaOnda2Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda2Ajustada)) +
  labs(x = "Idade na Onda 2", y = "Concentração em mg/dl") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Creatinina rastreavel na urina - Onda 2")

###Onda 3
ggplot(data = creatininaRastreavelNaUrinaOnda3, aes(x = idadeNaOnda3Ajustada, y = creatininaRastreavelNaUrinaOnda3Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda3Ajustada)) +
  labs(x = "Idade na Onda 3", y = "Concentração em mg/dl") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Creatinina rastreavel na urina - Onda 3")