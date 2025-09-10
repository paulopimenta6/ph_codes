############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoContinuoGlibenclamidaOnda1Ajustada <- fazUsoContinuoGlibenclamidaOnda1[which(!is.na(fazUsoContinuoGlibenclamidaOnda1))]
fazUsoContinuoGlibenclamidaOnda2Ajustada <- fazUsoContinuoGlibenclamidaOnda2[which(!is.na(fazUsoContinuoGlibenclamidaOnda2))]
fazUsoContinuoGlibenclamidaOnda3Ajustada <- fazUsoContinuoGlibenclamidaOnda3[which(!is.na(fazUsoContinuoGlibenclamidaOnda3))]

idxFazUsoContinuoGlibenclamidaOnda1 <- which(!is.na(fazUsoContinuoGlibenclamidaOnda1))
idxFazUsoContinuoGlibenclamidaOnda2 <- which(!is.na(fazUsoContinuoGlibenclamidaOnda2))
idxFazUsoContinuoGlibenclamidaOnda3 <- which(!is.na(fazUsoContinuoGlibenclamidaOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxFazUsoContinuoGlibenclamidaOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoContinuoGlibenclamidaOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoContinuoGlibenclamidaOnda3]

################################################################################
###data.frame
################################################################################
fazUsoContinuoGlibenclamidaOnda1 <- data.frame(idadeNaOnda1Ajustada, fazUsoContinuoGlibenclamidaOnda1Ajustada)
fazUsoContinuoGlibenclamidaOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoContinuoGlibenclamidaOnda2Ajustada)
fazUsoContinuoGlibenclamidaOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoContinuoGlibenclamidaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda1 <- data.frame(fazUsoContinuoGlibenclamidaOnda1Ajustada = 0:1)
all_levels_Onda2 <- data.frame(fazUsoContinuoGlibenclamidaOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoContinuoGlibenclamidaOnda3Ajustada = 0:1)

fazUsoContinuoGlibenclamidaOnda1_complet <- merge(all_levels_Onda1, fazUsoContinuoGlibenclamidaOnda1, by = "fazUsoContinuoGlibenclamidaOnda1Ajustada", all.x = TRUE)
fazUsoContinuoGlibenclamidaOnda2_complet <- merge(all_levels_Onda2, fazUsoContinuoGlibenclamidaOnda2, by = "fazUsoContinuoGlibenclamidaOnda2Ajustada", all.x = TRUE)
fazUsoContinuoGlibenclamidaOnda3_complet <- merge(all_levels_Onda3, fazUsoContinuoGlibenclamidaOnda3, by = "fazUsoContinuoGlibenclamidaOnda3Ajustada", all.x = TRUE)

#Onda 1
ggplot(data = fazUsoContinuoGlibenclamidaOnda1_complet, aes(x = factor(fazUsoContinuoGlibenclamidaOnda1Ajustada), fill=as.factor(idadeNaOnda1Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Glibenclamida - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 2
ggplot(data = fazUsoContinuoGlibenclamidaOnda2_complet, aes(x = factor(fazUsoContinuoGlibenclamidaOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Glibenclamida - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoContinuoGlibenclamidaOnda3_complet, aes(x = factor(fazUsoContinuoGlibenclamidaOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso Glibenclamida - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = fazUsoContinuoGlibenclamidaOnda1_complet, aes(y = idadeNaOnda1Ajustada, x = factor(fazUsoContinuoGlibenclamidaOnda1Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoGlibenclamidaOnda1Ajustada)) +
  labs(y = "Idade na Onda 1", x = "Uso de Glibenclamida") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Glibenclamida - Onda 1")

###Onda 2
ggplot(data = fazUsoContinuoGlibenclamidaOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoContinuoGlibenclamidaOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoGlibenclamidaOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de Glibenclamida") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Glibenclamida - Onda 2")

###Onda 3
ggplot(data = fazUsoContinuoGlibenclamidaOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoContinuoGlibenclamidaOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoContinuoGlibenclamidaOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de Glibenclamida") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de Glibenclamida - Onda 3")