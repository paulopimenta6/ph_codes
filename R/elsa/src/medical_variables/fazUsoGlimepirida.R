############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoGlimepiridaOnda1Ajustada <- fazUsoContinuoGlimepiridaOnda1[which(!is.na(fazUsoContinuoGlimepiridaOnda1))]
fazUsoContinuoGlimepiridaOnda2Ajustada <- fazUsoContinuoGlimepiridaOnda2[which(!is.na(fazUsoContinuoGlimepiridaOnda2))]
fazUsoContinuoGlimepiridaOnda3Ajustada <- fazUsoContinuoGlimepiridaOnda3[which(!is.na(fazUsoContinuoGlimepiridaOnda3))]

idxFazUsoContinuoGlimepiridaOnda1 <- which(!is.na(fazUsoContinuoGlimepiridaOnda1))
idxFazUsoContinuoGlimepiridaOnda2 <- which(!is.na(fazUsoContinuoGlimepiridaOnda2))
idxFazUsoContinuoGlimepiridaOnda3 <- which(!is.na(fazUsoContinuoGlimepiridaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoGlimepiridaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoGlimepiridaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoGlimepiridaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoGlimepiridaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoGlimepiridaOnda1Ajustada)
fazUsoContinuoGlimepiridaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoGlimepiridaOnda2Ajustada)
fazUsoContinuoGlimepiridaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoGlimepiridaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoGlimepiridaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoGlimepiridaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoGlimepiridaOnda3Ajustada = 0:1)

fazUsoContinuoGlimepiridaOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoGlimepiridaOnda1, by = "fazUsoContinuoGlimepiridaOnda1Ajustada", all.x = TRUE)
fazUsoContinuoGlimepiridaOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoGlimepiridaOnda2, by = "fazUsoContinuoGlimepiridaOnda2Ajustada", all.x = TRUE)
fazUsoContinuoGlimepiridaOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoGlimepiridaOnda3, by = "fazUsoContinuoGlimepiridaOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoGlimepiridaOnda1_complet, aes(x = factor(fazUsoContinuoGlimepiridaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Glimepirida - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoGlimepiridaOnda2_complet, aes(x = factor(fazUsoContinuoGlimepiridaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Glimepirida - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoGlimepiridaOnda3_complet, aes(x = factor(fazUsoContinuoGlimepiridaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Glimepirida - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoGlimepiridaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoGlimepiridaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoGlimepiridaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Glimepririda") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Glimepirida - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoGlimepiridaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoGlimepiridaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoGlimepiridaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Glimepririda") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Glimepirida - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoGlimepiridaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoGlimepiridaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoGlimepiridaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Glimepririda") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Glimepirida - Onda 3")