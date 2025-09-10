############################################################################################
############################################################################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
fazUsoHipolipemiantesEstatinasOnda2Ajustada <- fazUsoEsporadicoCetorolacoOnda2[which(!is.na(fazUsoEsporadicoCetorolacoOnda2))]
fazUsoHipolipemiantesEstatinasOnda3Ajustada <- fazUsoEsporadicoCetorolacoOnda3[which(!is.na(fazUsoEsporadicoCetorolacoOnda3))]

idxFazUsoHipolipemiantesEstatinasOnda2 <- which(!is.na(fazUsoHipolipemiantesEstatinasOnda2))
idxFazUsoHipolipemiantesEstatinasOnda3 <- which(!is.na(fazUsoHipolipemiantesEstatinasOnda3))

idadeNaOnda2Ajustada <- idadeNaOnda2[idxFazUsoHipolipemiantesEstatinasOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxFazUsoHipolipemiantesEstatinasOnda3]

################################################################################
###data.frame
################################################################################
fazUsoHipolipemiantesEstatinasOnda2 <- data.frame(idadeNaOnda2Ajustada, fazUsoHipolipemiantesEstatinasOnda2Ajustada)
fazUsoHipolipemiantesEstatinasOnda3 <- data.frame(idadeNaOnda3Ajustada, fazUsoHipolipemiantesEstatinasOnda3Ajustada)

################################################################################
###Graficos
################################################################################
all_levels_Onda2 <- data.frame(fazUsoHipolipemiantesEstatinasOnda2Ajustada = 0:1)
all_levels_Onda3 <- data.frame(fazUsoHipolipemiantesEstatinasOnda3Ajustada = 0:1)

fazUsoHipolipemiantesEstatinasOnda2_complet <- merge(all_levels_Onda2, fazUsoHipolipemiantesEstatinasOnda2, by = "fazUsoHipolipemiantesEstatinasOnda2Ajustada", all.x = TRUE)
fazUsoHipolipemiantesEstatinasOnda3_complet <- merge(all_levels_Onda3, fazUsoHipolipemiantesEstatinasOnda3, by = "fazUsoHipolipemiantesEstatinasOnda3Ajustada", all.x = TRUE)

#Onda 2
ggplot(data = fazUsoHipolipemiantesEstatinasOnda2_complet, aes(x = factor(fazUsoHipolipemiantesEstatinasOnda2Ajustada), fill=as.factor(idadeNaOnda2Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso hipomeliantes estatinas - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

#Onda 3
ggplot(data = fazUsoHipolipemiantesEstatinasOnda3_complet, aes(x = factor(fazUsoHipolipemiantesEstatinasOnda3Ajustada), fill=as.factor(idadeNaOnda3Ajustada))) + 
  geom_bar() +
  ggtitle("Faz uso hipomeliantes estatinas - Onda 3") +
  labs(fill = "Idade - Onda 3", y = "Quantidade de pessoas", x = "0: Não, 1: Sim")

################################################################################
###Boxplot
################################################################################

###Onda 2
ggplot(data = fazUsoHipolipemiantesEstatinasOnda2_complet, aes(y = idadeNaOnda2Ajustada, x = factor(fazUsoHipolipemiantesEstatinasOnda2Ajustada))) +
  geom_boxplot(aes(group=fazUsoHipolipemiantesEstatinasOnda2Ajustada)) +
  labs(y = "Idade na Onda 2", x = "Uso de hipomeliantes estatinas") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de hipomeliantes estatinas - Onda 2")

###Onda 3
ggplot(data = fazUsoHipolipemiantesEstatinasOnda3_complet, aes(y = idadeNaOnda3Ajustada, x = factor(fazUsoHipolipemiantesEstatinasOnda3Ajustada))) +
  geom_boxplot(aes(group=fazUsoHipolipemiantesEstatinasOnda3Ajustada)) +
  labs(y = "Idade na Onda 3", x = "Uso de hipomeliantes estatinas") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Uso de hipomeliantes estatinas - Onda 3")