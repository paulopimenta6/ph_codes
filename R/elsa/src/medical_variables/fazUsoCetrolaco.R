############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R")  
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoEsporadicoCetorolacoOnda1Ajustada <- fazUsoEsporadicoCetorolacoOnda1[which(!is.na(fazUsoEsporadicoCetorolacoOnda1))]
fazUsoEsporadicoCetorolacoOnda2Ajustada <- fazUsoEsporadicoCetorolacoOnda2[which(!is.na(fazUsoEsporadicoCetorolacoOnda2))]
fazUsoEsporadicoCetorolacoOnda3Ajustada <- fazUsoEsporadicoCetorolacoOnda3[which(!is.na(fazUsoEsporadicoCetorolacoOnda3))]

idxFazUsoEsporadicoCetorolacoOnda1 <- which(!is.na(fazUsoEsporadicoCetorolacoOnda1))
idxFazUsoEsporadicoCetorolacoOnda2 <- which(!is.na(fazUsoEsporadicoCetorolacoOnda2))
idxFazUsoEsporadicoCetorolacoOnda3 <- which(!is.na(fazUsoEsporadicoCetorolacoOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoEsporadicoCetorolacoOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoEsporadicoCetorolacoOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoEsporadicoCetorolacoOnda3]

################################################################################
###data.frame
################################################################################
fazUsoEsporadicoCetorolacoOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoEsporadicoCetorolacoOnda1Ajustada)
fazUsoEsporadicoCetorolacoOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoEsporadicoCetorolacoOnda2Ajustada)
fazUsoEsporadicoCetorolacoOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoEsporadicoCetorolacoOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoEsporadicoCetorolacoOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoEsporadicoCetorolacoOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoEsporadicoCetorolacoOnda3Ajustada = 0:1)

fazUsoEsporadicoCetorolacoOnda1_complet <- merge(all_levels_Onda1, fazUsoEsporadicoCetorolacoOnda1, by = "fazUsoEsporadicoCetorolacoOnda1Ajustada", all.x = TRUE)
fazUsoEsporadicoCetorolacoOnda2_complet <- merge(all_levels_Onda2, fazUsoEsporadicoCetorolacoOnda2, by = "fazUsoEsporadicoCetorolacoOnda2Ajustada", all.x = TRUE)
fazUsoEsporadicoCetorolacoOnda3_complet <- merge(all_levels_Onda3, fazUsoEsporadicoCetorolacoOnda3, by = "fazUsoEsporadicoCetorolacoOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoEsporadicoCetorolacoOnda1_complet, aes(x = factor(fazUsoEsporadicoCetorolacoOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Cetrolaco - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoEsporadicoCetorolacoOnda2_complet, aes(x = factor(fazUsoEsporadicoCetorolacoOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Cetrolaco - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoEsporadicoCetorolacoOnda3_complet, aes(x = factor(fazUsoEsporadicoCetorolacoOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Cetrolaco - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoEsporadicoCetorolacoOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoEsporadicoCetorolacoOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoEsporadicoCetorolacoOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Cetrolaco") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Cetrolaco - Onda 1")

###Onda 2
ggplot(data = fazUsoEsporadicoCetorolacoOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoEsporadicoCetorolacoOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoEsporadicoCetorolacoOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Cetrolaco") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Cetrolaco - Onda 2")

###Onda 3
ggplot(data = fazUsoEsporadicoCetorolacoOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoEsporadicoCetorolacoOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoEsporadicoCetorolacoOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Cetrolaco") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Cetrolaco - Onda 3")