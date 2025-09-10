############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoHipolipemiantesOnda1Ajustada <- fazUsoHipolipemiantesOnda1[which(!is.na(fazUsoHipolipemiantesOnda1))]
fazUsoHipolipemiantesOnda2Ajustada <- fazUsoHipolipemiantesOnda2[which(!is.na(fazUsoHipolipemiantesOnda2))]
fazUsoHipolipemiantesOnda3Ajustada <- fazUsoHipolipemiantesOnda3[which(!is.na(fazUsoHipolipemiantesOnda3))]

idxFazUsoHipolipemiantesOnda1 <- which(!is.na(fazUsoHipolipemiantesOnda1))
idxFazUsoHipolipemiantesOnda2 <- which(!is.na(fazUsoHipolipemiantesOnda2))
idxFazUsoHipolipemiantesOnda3 <- which(!is.na(fazUsoHipolipemiantesOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoHipolipemiantesOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoHipolipemiantesOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoHipolipemiantesOnda3]

################################################################################
###data.frame
################################################################################
fazUsoHipolipemiantesOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoHipolipemiantesOnda1Ajustada)
fazUsoHipolipemiantesOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoHipolipemiantesOnda2Ajustada)
fazUsoHipolipemiantesOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoHipolipemiantesOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoHipolipemiantesOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoHipolipemiantesOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoHipolipemiantesOnda3Ajustada = 0:1)

fazUsoHipolipemiantesOnda1_complet <- merge(all_levels_Onda1, fazUsoHipolipemiantesOnda1, by = "fazUsoHipolipemiantesOnda1Ajustada", all.x = TRUE)
fazUsoHipolipemiantesOnda2_complet <- merge(all_levels_Onda2, fazUsoHipolipemiantesOnda2, by = "fazUsoHipolipemiantesOnda2Ajustada", all.x = TRUE)
fazUsoHipolipemiantesOnda3_complet <- merge(all_levels_Onda3, fazUsoHipolipemiantesOnda3, by = "fazUsoHipolipemiantesOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoHipolipemiantesOnda1_complet, aes(x = factor(fazUsoHipolipemiantesOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Hipomeliantes - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoHipolipemiantesOnda2_complet, aes(x = factor(fazUsoHipolipemiantesOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Hipomeliantes - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoHipolipemiantesOnda3_complet, aes(x = factor(fazUsoHipolipemiantesOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Hipomeliantes - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoHipolipemiantesOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoHipolipemiantesOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoHipolipemiantesOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Hipomeliantes") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Hipomeliantes - Onda 1")

###Onda 2
ggplot(data = fazUsoHipolipemiantesOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoHipolipemiantesOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoHipolipemiantesOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Hipomeliantes") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Hipomeliantes - Onda 2")

###Onda 3
ggplot(data = fazUsoHipolipemiantesOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoHipolipemiantesOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoHipolipemiantesOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Hipomeliantes") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Hipomeliantes - Onda 3")