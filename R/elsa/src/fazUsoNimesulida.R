############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoNimesulidaOnda1Ajustada <- fazUsoContinuoNimesulidaOnda1[which(!is.na(fazUsoContinuoNimesulidaOnda1))]
fazUsoContinuoNimesulidaOnda2Ajustada <- fazUsoContinuoNimesulidaOnda2[which(!is.na(fazUsoContinuoNimesulidaOnda2))]
fazUsoContinuoNimesulidaOnda3Ajustada <- fazUsoContinuoNimesulidaOnda3[which(!is.na(fazUsoContinuoNimesulidaOnda3))]

idxFazUsoContinuoNimesulidaOnda1 <- which(!is.na(fazUsoContinuoNimesulidaOnda1))
idxFazUsoContinuoNimesulidaOnda2 <- which(!is.na(fazUsoContinuoNimesulidaOnda2))
idxFazUsoContinuoNimesulidaOnda3 <- which(!is.na(fazUsoContinuoNimesulidaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoNimesulidaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoNimesulidaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoNimesulidaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoNimesulidaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoNimesulidaOnda1Ajustada)
fazUsoContinuoNimesulidaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoNimesulidaOnda2Ajustada)
fazUsoContinuoNimesulidaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoNimesulidaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoNimesulidaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoNimesulidaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoNimesulidaOnda3Ajustada = 0:1)

fazUsoContinuoNimesulidaOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoNimesulidaOnda1, by = "fazUsoContinuoNimesulidaOnda1Ajustada", all.x = TRUE)
fazUsoContinuoNimesulidaOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoNimesulidaOnda2, by = "fazUsoContinuoNimesulidaOnda2Ajustada", all.x = TRUE)
fazUsoContinuoNimesulidaOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoNimesulidaOnda3, by = "fazUsoContinuoNimesulidaOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoNimesulidaOnda1_complet, aes(x = factor(fazUsoContinuoNimesulidaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Nimesulida - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoNimesulidaOnda2_complet, aes(x = factor(fazUsoContinuoNimesulidaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Nimesulida - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoNimesulidaOnda3_complet, aes(x = factor(fazUsoContinuoNimesulidaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Nimesulida - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoNimesulidaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoNimesulidaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoNimesulidaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Nimesulida") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Nimesulida - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoNimesulidaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoNimesulidaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoNimesulidaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Nimesulida") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Nimesulida - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoNimesulidaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoNimesulidaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoNimesulidaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Nimesulida") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Nimesulida - Onda 3")