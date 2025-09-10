############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoValsartanaOnda1Ajustada <- fazUsoContinuoValsartanaOnda1[which(!is.na(fazUsoContinuoValsartanaOnda1))]
fazUsoContinuoValsartanaOnda2Ajustada <- fazUsoContinuoValsartanaOnda2[which(!is.na(fazUsoContinuoValsartanaOnda2))]
fazUsoContinuoValsartanaOnda3Ajustada <- fazUsoContinuoValsartanaOnda3[which(!is.na(fazUsoContinuoValsartanaOnda3))]

idxFazUsoContinuoValsartanaOnda1 <- which(!is.na(fazUsoContinuoValsartanaOnda1))
idxFazUsoContinuoValsartanaOnda2 <- which(!is.na(fazUsoContinuoValsartanaOnda2))
idxFazUsoContinuoValsartanaOnda3 <- which(!is.na(fazUsoContinuoValsartanaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoValsartanaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoValsartanaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoValsartanaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoValsartanaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoValsartanaOnda1Ajustada)
fazUsoContinuoValsartanaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoValsartanaOnda2Ajustada)
fazUsoContinuoValsartanaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoValsartanaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoValsartanaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoValsartanaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoValsartanaOnda3Ajustada = 0:1)

fazUsoContinuoValsartanaOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoValsartanaOnda1, by = "fazUsoContinuoValsartanaOnda1Ajustada", all.x = TRUE)
fazUsoContinuoValsartanaOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoValsartanaOnda2, by = "fazUsoContinuoValsartanaOnda2Ajustada", all.x = TRUE)
fazUsoContinuoValsartanaOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoValsartanaOnda3, by = "fazUsoContinuoValsartanaOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoValsartanaOnda1_complet, aes(x = factor(fazUsoContinuoValsartanaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Valsartana - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoValsartanaOnda2_complet, aes(x = factor(fazUsoContinuoValsartanaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Valsartana - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoValsartanaOnda3_complet, aes(x = factor(fazUsoContinuoValsartanaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Valsartana - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoValsartanaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoValsartanaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoValsartanaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Valsartana") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Valsartana - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoValsartanaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoValsartanaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoValsartanaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Valsartana") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Valsartana - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoValsartanaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoValsartanaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoValsartanaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Valsartana") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Valsartana - Onda 3")