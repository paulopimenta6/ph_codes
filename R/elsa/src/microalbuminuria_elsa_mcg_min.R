############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src") {   ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src")            ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)

barplot(table(microalbuminuriaMInOnda1), xlab = "Concentração em (mg/dl)", ylab = "Microalbuminuria na onda 1", ylim = c(0, 700)) 
barplot(table(microalbuminuriaMInOnda2), xlab = "Concentração em (mg/dl)", ylab = "Microalbuminuria na onda 2", ylim = c(0, 700)) 

microalbuminuriaMInOnda1DF <- microalbuminuriaMInOnda1[!is.na(microalbuminuriaMInOnda1)]
microalbuminuriaMInOnda2DF <- microalbuminuriaMInOnda2[!is.na(microalbuminuriaMInOnda2)]

###############################################
#summary(microalbuminuriaMInOnda1DF)      #####
summary(microalbuminuriaMInOnda1DF)       #####
###############################################
#summary(microalbuminuriaMInOnda2DF)      #####
summary(microalbuminuriaMInOnda2DF)       #####
###############################################

microalbuminuriaMInOnda1DF = data.frame(value = microalbuminuriaMInOnda1DF)
microalbuminuriaMInOnda2DF = data.frame(value = microalbuminuriaMInOnda2DF)

################################################################################
###grafico de barra
###Onda1
microalbuminuriaMInOnda1DF$value <- as.numeric(as.character(microalbuminuriaMInOnda1DF$value))
ggplot(data = microalbuminuriaMInOnda1DF, mapping = aes(x = factor(value))) + 
  geom_bar() +
  xlab("Concentração em (mcg/min) - Onda 1") +
  ylab("Quantidade") +
  scale_x_discrete(breaks = seq(0, 2, by = 0.1)) +
  ggtitle("Distribuição da Microalbuminúria (mcg/min) na Onda 1")

###Onda2
microalbuminuriaMInOnda2DF$value <- as.numeric(as.character(microalbuminuriaMInOnda2DF$value))
ggplot(data = microalbuminuriaMInOnda2DF, mapping = aes(x = factor(value))) + 
  geom_bar() +
  xlab("Concentração em (mcg/min) - Onda 2") +
  ylab("Quantidade") +
  scale_x_discrete(breaks = seq(0, 100, by = 5.0)) +
  ggtitle("Distribuição da Microalbuminúria (mcg/min) na Onda 2")

################################################################################
###grafico de pontos
###Removendo outliers
###Tratamento dos dados >> remocao de outliers e dados nulos
indicesmicroalbuminuriaMInOnda1 <- which(!(microalbuminuriaMInOnda1 > 2 | is.na(microalbuminuriaMInOnda1)))
indicesmicroalbuminuriaMInOnda2 <- which(!(microalbuminuriaMInOnda2 > 2 | is.na(microalbuminuriaMInOnda2)))

microalbuminuriaMInOnda1 <- microalbuminuriaMInOnda1[!(microalbuminuriaMInOnda1 > 2 | is.na(microalbuminuriaMInOnda1))]
microalbuminuriaMInOnda2 <- microalbuminuriaMInOnda2[!(microalbuminuriaMInOnda2 > 2 | is.na(microalbuminuriaMInOnda2))]

idadeNaOnda1MicroalbuminuriaMInOnda1 <- idadeNaOnda1[indicesmicroalbuminuriaMInOnda1]
idadeNaOnda2microalbuminuriaMInOnda2 <- idadeNaOnda2[indicesmicroalbuminuriaMInOnda2]

microalbuminuriaMInOnda1Ajustada1 <- data.frame(idadeNaOnda1MicroalbuminuriaMInOnda1,microalbuminuriaMInOnda1)
microalbuminuriaMInOnda2Ajustada2 <- data.frame(idadeNaOnda2microalbuminuriaMInOnda2,microalbuminuriaMInOnda2)

###graficos
ggplot(data = microalbuminuriaMInOnda1Ajustada1, mapping = aes(y = idadeNaOnda1MicroalbuminuriaMInOnda1 , x = microalbuminuriaMInOnda1)) + 
  geom_point() +
  xlab("Concentração em (mcg/min) - Onda 1") +
  ylab("Idade") +
  ggtitle("Distribuição da Microalbuminúria (mcg/min) na Onda 1")

ggplot(data = microalbuminuriaMInOnda2Ajustada2, mapping = aes(y = idadeNaOnda2microalbuminuriaMInOnda2 , x = microalbuminuriaMInOnda2)) + 
  geom_point() +
  xlab("Concentração em (mcg/min) - Onda 2") +
  ylab("Idade") +
  ggtitle("Distribuição da Microalbuminúria (mcg/min) na Onda 2")


###grafico de barra
###Onda1
ggplot(data = microalbuminuriaMInOnda1Ajustada1, mapping = aes(x = microalbuminuriaMInOnda1)) + 
  geom_bar() +
  xlab("Concentração em (mcg/min) - Onda 1") +
  ylab("Quantidade") +
  ggtitle("Distribuição da Microalbuminúria (mcg/min) na Onda 1")

ggplot(data = microalbuminuriaMInOnda2Ajustada2, mapping = aes(x = microalbuminuriaMInOnda2)) + 
  geom_bar() +
  xlab("Concentração em (mcg/min) - Onda 2") +
  ylab("Quantidade") +
  ggtitle("Distribuição da Microalbuminúria (mcg/min) na Onda 2")

###
#graficos mais expositivos
ggplot(data = microalbuminuriaMInOnda1Ajustada1, mapping = aes(x = microalbuminuriaMInOnda1)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1MicroalbuminuriaMInOnda1))) +
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "Concentração em (mcg/min) - Onda 1 - onda 1")


ggplot(data = microalbuminuriaMInOnda2Ajustada2, aes(x = microalbuminuriaMInOnda2)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2microalbuminuriaMInOnda2))) +
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "Concentração em (mcg/min) - Onda 2 - onda 2")