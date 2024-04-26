############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoLosartanaOnda1Ajustada <- fazUsoContinuoLosartanaOnda1[which(!is.na(fazUsoContinuoLosartanaOnda1))]
fazUsoContinuoLosartanaOnda2Ajustada <- fazUsoContinuoLosartanaOnda2[which(!is.na(fazUsoContinuoLosartanaOnda2))]
fazUsoContinuoLosartanaOnda3Ajustada <- fazUsoContinuoLosartanaOnda3[which(!is.na(fazUsoContinuoLosartanaOnda3))]

idxFazUsoContinuoLosartanaOnda1 <- which(!is.na(fazUsoContinuoLosartanaOnda1))
idxFazUsoContinuoLosartanaOnda2 <- which(!is.na(fazUsoContinuoLosartanaOnda2))
idxFazUsoContinuoLosartanaOnda3 <- which(!is.na(fazUsoContinuoLosartanaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoLosartanaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoLosartanaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoLosartanaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoLosartanaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoLosartanaOnda1Ajustada)
fazUsoContinuoLosartanaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoLosartanaOnda2Ajustada)
fazUsoContinuoLosartanaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoLosartanaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoLosartanaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoLosartanaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoLosartanaOnda3Ajustada = 0:1)

fazUsoContinuoLosartanaOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoLosartanaOnda1, by = "fazUsoContinuoLosartanaOnda1Ajustada", all.x = TRUE)
fazUsoContinuoLosartanaOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoLosartanaOnda2, by = "fazUsoContinuoLosartanaOnda2Ajustada", all.x = TRUE)
fazUsoContinuoLosartanaOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoLosartanaOnda3, by = "fazUsoContinuoLosartanaOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoLosartanaOnda1_complet, aes(x = factor(fazUsoContinuoLosartanaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Losartana - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoLosartanaOnda2_complet, aes(x = factor(fazUsoContinuoLosartanaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Losartana - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoLosartanaOnda3_complet, aes(x = factor(fazUsoContinuoLosartanaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Losartana - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoLosartanaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoLosartanaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoLosartanaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Losartana") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Losartana - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoLosartanaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoLosartanaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoLosartanaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Losartana") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Losartana - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoLosartanaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoLosartanaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoLosartanaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Losartana") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Losartana - Onda 3")