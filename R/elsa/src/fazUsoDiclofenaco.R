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
fazUsoContinuoDiclofenacoOnda1Ajustada <- fazUsoContinuoDiclofenacoOnda1[which(!is.na(fazUsoContinuoDiclofenacoOnda1))]
fazUsoContinuoDiclofenacoOnda2Ajustada <- fazUsoContinuoDiclofenacoOnda2[which(!is.na(fazUsoContinuoDiclofenacoOnda2))]
fazUsoContinuoDiclofenacoOnda3Ajustada <- fazUsoContinuoDiclofenacoOnda3[which(!is.na(fazUsoContinuoDiclofenacoOnda3))]

idxFazUsoContinuoDiclofenacoOnda1 <- which(!is.na(fazUsoContinuoDiclofenacoOnda1))
idxFazUsoContinuoDiclofenacoOnda2 <- which(!is.na(fazUsoContinuoDiclofenacoOnda2))
idxFazUsoContinuoDiclofenacoOnda3 <- which(!is.na(fazUsoContinuoDiclofenacoOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoDiclofenacoOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoDiclofenacoOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoDiclofenacoOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoDiclofenacoOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoDiclofenacoOnda1Ajustada)
fazUsoContinuoDiclofenacoOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoDiclofenacoOnda2Ajustada)
fazUsoContinuoDiclofenacoOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoDiclofenacoOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoDiclofenacoOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoDiclofenacoOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoDiclofenacoOnda3Ajustada = 0:1)

fazUsoContinuoDiclofenacoOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoDiclofenacoOnda1, by = "fazUsoContinuoDiclofenacoOnda1Ajustada", all.x = TRUE)
fazUsoContinuoDiclofenacoOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoDiclofenacoOnda2, by = "fazUsoContinuoDiclofenacoOnda2Ajustada", all.x = TRUE)
fazUsoContinuoDiclofenacoOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoDiclofenacoOnda3, by = "fazUsoContinuoDiclofenacoOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoDiclofenacoOnda1_complet, aes(x = factor(fazUsoContinuoDiclofenacoOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Diclofenaco - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoDiclofenacoOnda2_complet, aes(x = factor(fazUsoContinuoDiclofenacoOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Diclofenaco - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoDiclofenacoOnda3_complet, aes(x = factor(fazUsoContinuoDiclofenacoOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Diclofenaco - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoDiclofenacoOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoDiclofenacoOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoDiclofenacoOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Diclofenaco") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Diclofenaco - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoDiclofenacoOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoDiclofenacoOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoDiclofenacoOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Diclofenaco") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Diclofenaco - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoDiclofenacoOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoDiclofenacoOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoDiclofenacoOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Diclofenaco") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Diclofenaco - Onda 3")