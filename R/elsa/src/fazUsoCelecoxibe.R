############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoCelecoxibeOnda1Ajustada <- fazUsoContinuoCelecoxibeOnda1[which(!is.na(fazUsoContinuoCelecoxibeOnda1))]
fazUsoContinuoCelecoxibeOnda2Ajustada <- fazUsoContinuoCelecoxibeOnda2[which(!is.na(fazUsoContinuoCelecoxibeOnda2))]
fazUsoContinuoCelecoxibeOnda3Ajustada <- fazUsoContinuoCelecoxibeOnda3[which(!is.na(fazUsoContinuoCelecoxibeOnda3))]

idxFazUsoContinuoCelecoxibeOnda1 <- which(!is.na(fazUsoContinuoCelecoxibeOnda1))
idxFazUsoContinuoCelecoxibeOnda2 <- which(!is.na(fazUsoContinuoCelecoxibeOnda2))
idxFazUsoContinuoCelecoxibeOnda3 <- which(!is.na(fazUsoContinuoCelecoxibeOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoCelecoxibeOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoCelecoxibeOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoCelecoxibeOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoCelecoxibeOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoCelecoxibeOnda1Ajustada)
fazUsoContinuoCelecoxibeOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoCelecoxibeOnda2Ajustada)
fazUsoContinuoCelecoxibeOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoCelecoxibeOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoCelecoxibeOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoCelecoxibeOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoCelecoxibeOnda3Ajustada = 0:1)

fazUsoContinuoCelecoxibeOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoCelecoxibeOnda1, by = "fazUsoContinuoCelecoxibeOnda1Ajustada", all.x = TRUE)
fazUsoContinuoCelecoxibeOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoCelecoxibeOnda2, by = "fazUsoContinuoCelecoxibeOnda2Ajustada", all.x = TRUE)
fazUsoContinuoCelecoxibeOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoCelecoxibeOnda3, by = "fazUsoContinuoCelecoxibeOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoCelecoxibeOnda1_complet, aes(x = factor(fazUsoContinuoCelecoxibeOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Celecoxibe - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoCelecoxibeOnda2_complet, aes(x = factor(fazUsoContinuoCelecoxibeOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Celecoxibe - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoCelecoxibeOnda3_complet, aes(x = factor(fazUsoContinuoCelecoxibeOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Celecoxibe - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoCelecoxibeOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoCelecoxibeOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoCelecoxibeOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Celecoxibe") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Celecoxibe - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoCelecoxibeOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoCelecoxibeOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoCelecoxibeOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Celecoxibe") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Celecoxibe - Onda 2")

###Onda 1
ggplot(data = fazUsoContinuoCelecoxibeOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoCelecoxibeOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoCelecoxibeOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Celecoxibe") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Celecoxibe - Onda 3")