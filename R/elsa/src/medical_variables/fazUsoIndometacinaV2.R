############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoIndometacinaOnda1Ajustada <- fazUsoContinuoIndometacinaOnda1[which(!is.na(fazUsoContinuoIndometacinaOnda1))]
fazUsoContinuoIndometacinaOnda2Ajustada <- fazUsoContinuoIndometacinaOnda2[which(!is.na(fazUsoContinuoIndometacinaOnda2))]
fazUsoContinuoIndometacinaOnda3Ajustada <- fazUsoContinuoIndometacinaOnda3[which(!is.na(fazUsoContinuoIndometacinaOnda3))]

idxFazUsoContinuoIndometacinaOnda1 <- which(!is.na(fazUsoContinuoIndometacinaOnda1))
idxFazUsoContinuoIndometacinaOnda2 <- which(!is.na(fazUsoContinuoIndometacinaOnda2))
idxFazUsoContinuoIndometacinaOnda3 <- which(!is.na(fazUsoContinuoIndometacinaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoIndometacinaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoIndometacinaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoIndometacinaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoIndometacinaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoIndometacinaOnda1Ajustada)
fazUsoContinuoIndometacinaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoIndometacinaOnda2Ajustada)
fazUsoContinuoIndometacinaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoIndometacinaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoIndometacinaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoIndometacinaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoIndometacinaOnda3Ajustada = 0:1)

fazUsoContinuoIndometacinaOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoIndometacinaOnda1, by = "fazUsoContinuoIndometacinaOnda1Ajustada", all.y = TRUE)
fazUsoContinuoIndometacinaOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoIndometacinaOnda2, by = "fazUsoContinuoIndometacinaOnda2Ajustada", all.y = TRUE)
fazUsoContinuoIndometacinaOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoIndometacinaOnda3, by = "fazUsoContinuoIndometacinaOnda3Ajustada", all.y = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoIndometacinaOnda1_complet, aes(x = factor(fazUsoContinuoIndometacinaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Indometacina - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoIndometacinaOnda2_complet, aes(x = factor(fazUsoContinuoIndometacinaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Indometacina - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoIndometacinaOnda3_complet, aes(x = factor(fazUsoContinuoIndometacinaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Indometacina - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoIndometacinaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoIndometacinaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoIndometacinaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Indometacina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Indometacina - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoIndometacinaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoIndometacinaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoIndometacinaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Indometacina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Indometacina - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoIndometacinaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoIndometacinaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoIndometacinaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Indometacina") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Indometacina - Onda 3")