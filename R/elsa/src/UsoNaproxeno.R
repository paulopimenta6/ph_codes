############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoNaproxenoOnda1Ajustada <- fazUsoContinuoNaproxenoOnda1[which(!is.na(fazUsoContinuoNaproxenoOnda1))]
fazUsoContinuoNaproxenoOnda2Ajustada <- fazUsoContinuoNaproxenoOnda2[which(!is.na(fazUsoContinuoNaproxenoOnda2))]
fazUsoContinuoNaproxenoOnda3Ajustada <- fazUsoContinuoNaproxenoOnda3[which(!is.na(fazUsoContinuoNaproxenoOnda3))]

idxFazUsoContinuoNaproxenoOnda1 <- which(!is.na(fazUsoContinuoNaproxenoOnda1))
idxFazUsoContinuoNaproxenoOnda2 <- which(!is.na(fazUsoContinuoNaproxenoOnda2))
idxFazUsoContinuoNaproxenoOnda3 <- which(!is.na(fazUsoContinuoNaproxenoOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoNaproxenoOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoNaproxenoOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoNaproxenoOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoNaproxenoOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoNaproxenoOnda1Ajustada)
fazUsoContinuoNaproxenoOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoNaproxenoOnda2Ajustada)
fazUsoContinuoNaproxenoOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoNaproxenoOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoNaproxenoOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoNaproxenoOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoNaproxenoOnda3Ajustada = 0:1)

fazUsoContinuoNaproxenoOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoNaproxenoOnda1, by = "fazUsoContinuoNaproxenoOnda1Ajustada", all.x = TRUE)
fazUsoContinuoNaproxenoOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoNaproxenoOnda2, by = "fazUsoContinuoNaproxenoOnda2Ajustada", all.x = TRUE)
fazUsoContinuoNaproxenoOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoNaproxenoOnda3, by = "fazUsoContinuoNaproxenoOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoNaproxenoOnda1_complet, aes(x = factor(fazUsoContinuoNaproxenoOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Naproxeno - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoNaproxenoOnda2_complet, aes(x = factor(fazUsoContinuoNaproxenoOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Naproxeno - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoNaproxenoOnda3_complet, aes(x = factor(fazUsoContinuoNaproxenoOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Naproxeno - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoNaproxenoOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoNaproxenoOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoNaproxenoOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Naproxeno") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Naproxeno - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoNaproxenoOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoNaproxenoOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoNaproxenoOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Naproxeno") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Naproxeno - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoNaproxenoOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoNaproxenoOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoNaproxenoOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Naproxeno") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Naproxeno - Onda 3")