############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoInibidoresEcaOnda1Ajustada <- fazUsoInibidoresEcaOnda1[which(!is.na(fazUsoInibidoresEcaOnda1))]
fazUsoInibidoresEcaOnda2Ajustada <- fazUsoInibidoresEcaOnda2[which(!is.na(fazUsoInibidoresEcaOnda2))]
fazUsoInibidoresEcaOnda3Ajustada <- fazUsoInibidoresEcaOnda3[which(!is.na(fazUsoInibidoresEcaOnda3))]

idxFazUsoInibidoresEcaOnda1 <- which(!is.na(fazUsoInibidoresEcaOnda1))
idxFazUsoInibidoresEcaOnda2 <- which(!is.na(fazUsoInibidoresEcaOnda2))
idxFazUsoInibidoresEcaOnda3 <- which(!is.na(fazUsoInibidoresEcaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoInibidoresEcaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoInibidoresEcaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoInibidoresEcaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoInibidoresEcaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoInibidoresEcaOnda1Ajustada)
fazUsoInibidoresEcaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoInibidoresEcaOnda2Ajustada)
fazUsoInibidoresEcaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoInibidoresEcaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoInibidoresEcaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoInibidoresEcaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoInibidoresEcaOnda3Ajustada = 0:1)

fazUsoInibidoresEcaOnda1_complet <- merge(all_levels_Onda1, fazUsoInibidoresEcaOnda1, by = "fazUsoInibidoresEcaOnda1Ajustada", all.x = TRUE)
fazUsoInibidoresEcaOnda2_complet <- merge(all_levels_Onda2, fazUsoInibidoresEcaOnda2, by = "fazUsoInibidoresEcaOnda2Ajustada", all.x = TRUE)
fazUsoInibidoresEcaOnda3_complet <- merge(all_levels_Onda3, fazUsoInibidoresEcaOnda3, by = "fazUsoInibidoresEcaOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoInibidoresEcaOnda1_complet, aes(x = factor(fazUsoInibidoresEcaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Inibidopres da ECA - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoInibidoresEcaOnda2_complet, aes(x = factor(fazUsoInibidoresEcaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Inibidopres da ECA - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoInibidoresEcaOnda3_complet, aes(x = factor(fazUsoInibidoresEcaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Inibidopres da ECA - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoInibidoresEcaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoInibidoresEcaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoInibidoresEcaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Inibidopres da ECA") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Inibidopres da ECA - Onda 1")

###Onda 2
ggplot(data = fazUsoInibidoresEcaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoInibidoresEcaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoInibidoresEcaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Inibidopres da ECA") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Inibidopres da ECA - Onda 2")

###Onda 3
ggplot(data = fazUsoInibidoresEcaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoInibidoresEcaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoInibidoresEcaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Inibidopres da ECA") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Inibidopres da ECA - Onda 3")