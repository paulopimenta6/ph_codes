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
doencaCardiovascularPrevaOnda1Ajustada <- doencaCardiovascularPrevaOnda1[which(!is.na(doencaCardiovascularPrevaOnda1))]
doencaCardiovascularPrevaOnda2Ajustada <- doencaCardiovascularPrevaOnda2[which(!is.na(doencaCardiovascularPrevaOnda2))]
doencaCardiovascularPrevaOnda3Ajustada <- doencaCardiovascularPrevaOnda3[which(!is.na(doencaCardiovascularPrevaOnda3))]

idxDoencaCardiovascularPrevaOnda1 <- which(!is.na(doencaCardiovascularPrevaOnda1))
idxDoencaCardiovascularPrevaOnda2 <- which(!is.na(doencaCardiovascularPrevaOnda2))
idxDoencaCardiovascularPrevaOnda3 <- which(!is.na(doencaCardiovascularPrevaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxDoencaCardiovascularPrevaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxDoencaCardiovascularPrevaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxDoencaCardiovascularPrevaOnda3]

################################################################################
###data.frame
################################################################################
doencaCardiovascularPrevaOnda1 <- data.frame(idadeNaOnda1Ajustada, doencaCardiovascularPrevaOnda1Ajustada)
doencaCardiovascularPrevaOnda2 <- data.frame(idadeNaOnda2Ajustada, doencaCardiovascularPrevaOnda2Ajustada)
doencaCardiovascularPrevaOnda3 <- data.frame(idadeNaOnda3Ajustada, doencaCardiovascularPrevaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(doencaCardiovascularPrevaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(doencaCardiovascularPrevaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(doencaCardiovascularPrevaOnda3Ajustada = 0:1)

doencaCardiovascularPrevaOnda1_complet <- merge(all_levels_Onda1, doencaCardiovascularPrevaOnda1, by = "doencaCardiovascularPrevaOnda1Ajustada", all.x = TRUE)
doencaCardiovascularPrevaOnda2_complet <- merge(all_levels_Onda2, doencaCardiovascularPrevaOnda2, by = "doencaCardiovascularPrevaOnda2Ajustada", all.x = TRUE)
doencaCardiovascularPrevaOnda3_complet <- merge(all_levels_Onda3, doencaCardiovascularPrevaOnda3, by = "doencaCardiovascularPrevaOnda3Ajustada", all.x = TRUE)

ggplot(data = doencaCardiovascularPrevaOnda1_complet, aes(x = factor(doencaCardiovascularPrevaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Doença cardiovascular permanente - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

ggplot(data = doencaCardiovascularPrevaOnda2_complet, aes(x = factor(doencaCardiovascularPrevaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Doença cardiovascular permanente - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

ggplot(data = doencaCardiovascularPrevaOnda3_complet, aes(x = factor(doencaCardiovascularPrevaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Doença cardiovascular permanente - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
ggplot(data = doencaCardiovascularPrevaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(doencaCardiovascularPrevaOnda1Ajustada))) +
  geom_boxplot(aes(group=doencaCardiovascularPrevaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Doença vascular permanente") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Doença vascular permanente - Onda 1")

ggplot(data = doencaCardiovascularPrevaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(doencaCardiovascularPrevaOnda2Ajustada))) +
  geom_boxplot(aes(group=doencaCardiovascularPrevaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Doença vascular permanente") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Doença vascular permanente - Onda 2")

ggplot(data = doencaCardiovascularPrevaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(doencaCardiovascularPrevaOnda3Ajustada))) +
  geom_boxplot(aes(group=doencaCardiovascularPrevaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Doença vascular permanente") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Doença vascular permanente - Onda 3")