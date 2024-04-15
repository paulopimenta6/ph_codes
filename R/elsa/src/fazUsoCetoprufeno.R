############################################################################################
##############################Especificando diretorio src###################################
###Linux                                                                                  ##
if (sys_info_so == "Linux"){                                                              ##
  if (getwd() != "home/paulo/Documentos/meus_codigos/ph_codes/R/elsa/src") {              ##
    setwd("/home/paulo/Documentos/meus_codigos/ph_codes/R/elsa/src")                      ##  
  }                                                                                       ##
}                                                                                         ##
### Windows                                                                               ##
if (sys_info_so == "Windows"){                                                            ##
  if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src") {   ##
    setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src")            ##  
  }                                                                                       ##
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoCetoprofenoOnda1Ajustada <- fazUsoContinuoCetoprofenoOnda1[which(!is.na(fazUsoContinuoCetoprofenoOnda1))]
fazUsoContinuoCetoprofenoOnda2Ajustada <- fazUsoContinuoCetoprofenoOnda2[which(!is.na(fazUsoContinuoCetoprofenoOnda2))]
fazUsoContinuoCetoprofenoOnda3Ajustada <- fazUsoContinuoCetoprofenoOnda3[which(!is.na(fazUsoContinuoCetoprofenoOnda3))]

idxFazUsoContinuoCetoprofenoOnda1 <- which(!is.na(fazUsoContinuoCetoprofenoOnda1))
idxFazUsoContinuoCetoprofenoOnda2 <- which(!is.na(fazUsoContinuoCetoprofenoOnda2))
idxFazUsoContinuoCetoprofenoOnda3 <- which(!is.na(fazUsoContinuoCetoprofenoOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoCetoprofenoOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoCetoprofenoOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoCetoprofenoOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoCetoprofenoOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoCetoprofenoOnda1Ajustada)
fazUsoContinuoCetoprofenoOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoCetoprofenoOnda2Ajustada)
fazUsoContinuoCetoprofenoOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoCetoprofenoOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoCetoprofenoOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoCetoprofenoOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoCetoprofenoOnda3Ajustada = 0:1)

fazUsoContinuoCetoprofenoOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoCetoprofenoOnda1, by = "fazUsoContinuoCetoprofenoOnda1Ajustada", all.x = TRUE)
fazUsoContinuoCetoprofenoOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoCetoprofenoOnda2, by = "fazUsoContinuoCetoprofenoOnda2Ajustada", all.x = TRUE)
fazUsoContinuoCetoprofenoOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoCetoprofenoOnda3, by = "fazUsoContinuoCetoprofenoOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoCetoprofenoOnda1_complet, aes(x = factor(fazUsoContinuoCetoprofenoOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Cetoprufeno - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoCetoprofenoOnda2_complet, aes(x = factor(fazUsoContinuoCetoprofenoOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Cetoprufeno - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoCetoprofenoOnda3_complet, aes(x = factor(fazUsoContinuoCetoprofenoOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Cetoprufeno - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoCetoprofenoOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoCetoprofenoOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoCetoprofenoOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Cetoprufeno") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Cetoprufeno - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoCetoprofenoOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoCetoprofenoOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoCetoprofenoOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Cetoprufeno") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Cetoprufeno - Onda 2")

###Onda 1
ggplot(data = fazUsoContinuoCetoprofenoOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoCetoprofenoOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoCetoprofenoOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Cetoprufeno") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Cetoprufeno - Onda 3")