source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
###sodio - urina
################################################################################
sodioUrinaOnda1Ajustada <- sodioUrinaOnda1[which(!is.na(sodioUrinaOnda1))]
sodioUrinaOnda2Ajustada <- sodioUrinaOnda2[which(!is.na(sodioUrinaOnda2))]
sodioUrinaOnda3Ajustada <- sodioUrinaOnda3[which(!is.na(sodioUrinaOnda3))]

idxSodioUrinaOnda1 <- which(!is.na(sodioUrinaOnda1))
idxSodioUrinaOnda2 <- which(!is.na(sodioUrinaOnda2))
idxSodioUrinaOnda3 <- which(!is.na(sodioUrinaOnda3))

idadeSodio1Ajustada <- idadeNaOnda1[idxSodioUrinaOnda1]
idadeSodio2Ajustada <- idadeNaOnda2[idxSodioUrinaOnda2]
idadeSodio3Ajustada <- idadeNaOnda3[idxSodioUrinaOnda3] 
################################################################################
################################################################################
###Criando Data Frames
################################################################################
sodioUrinaOnda1 <- data.frame(idadeSodio1Ajustada, sodioUrinaOnda1Ajustada)
sodioUrinaOnda2 <- data.frame(idadeSodio2Ajustada, sodioUrinaOnda2Ajustada)
sodioUrinaOnda3 <- data.frame(idadeSodio3Ajustada, sodioUrinaOnda3Ajustada)

################################################################################
###Graficos
################################################################################
#Onda 1
ggplot(data = sodioUrinaOnda1, aes(x = sodioUrinaOnda1$sodioUrinaOnda1Ajustada)) + 
  geom_bar(aes(fill=as.factor(sodioUrinaOnda1$idadeSodio1Ajustada))) +
  ggtitle("Sódio - Onda 1") +
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas", x = "Sódio (meq/l)")

#Onda 2
ggplot(data = sodioUrinaOnda2, aes(x = sodioUrinaOnda2$sodioUrinaOnda2Ajustada)) + 
  geom_bar(aes(fill=as.factor(sodioUrinaOnda2$idadeSodio2Ajustada))) +
  ggtitle("Sódio - Onda 2") +
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas", x = "Sódio (meq/l)")

#Onda 3
ggplot(data = sodioUrinaOnda3, aes(x = sodioUrinaOnda3$sodioUrinaOnda3Ajustada)) + 
  geom_bar(aes(fill=as.factor(sodioUrinaOnda3$idadeSodio3Ajustada))) +
  ggtitle("Sódio - Onda 3") +
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas", x = "Sódio (meq/l)")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = sodioUrinaOnda1, aes(x = sodioUrinaOnda1$idadeSodio1Ajustada, y = sodioUrinaOnda1$sodioUrinaOnda1Ajustada)) +
  geom_boxplot(aes(group=sodioUrinaOnda1$idadeSodio1Ajustada)) +
  labs(x = "Idade na Onda 1", y = "Sódio - Onda 1") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Sódio - Onda 1")

###Onda 2
ggplot(data = sodioUrinaOnda2, aes(x = sodioUrinaOnda2$idadeSodio2Ajustada, y = sodioUrinaOnda2$sodioUrinaOnda2Ajustada)) +
  geom_boxplot(aes(group=sodioUrinaOnda2$idadeSodio2Ajustada)) +
  labs(x = "Idade na Onda 2", y = "Sódio - Onda 2") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Sódio - Onda 2")

###Onda 1
ggplot(data = sodioUrinaOnda3, aes(x = sodioUrinaOnda3$idadeSodio3Ajustada, y = sodioUrinaOnda3$sodioUrinaOnda3Ajustada)) +
  geom_boxplot(aes(group=sodioUrinaOnda3$idadeSodio3Ajustada)) +
  labs(x = "Idade na Onda 3", y = "Sódio - Onda 3") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Sódio - Onda 3")