source("./src/script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
razaoAlbuminaCreatininaRastreavelOnda1Ajustada <- razaoAlbuminaCreatininaRastreavelOnda1[which(!(is.na(razaoAlbuminaCreatininaRastreavelOnda1) | razaoAlbuminaCreatininaRastreavelOnda1 > 20))]
razaoAlbuminaCreatininaRastreavelOnda2Ajustada <- razaoAlbuminaCreatininaRastreavelOnda2[which(!(is.na(razaoAlbuminaCreatininaRastreavelOnda2) | razaoAlbuminaCreatininaRastreavelOnda2 > 20))]

idxRazaoAlbuminaCreatininaRastreavelOnda1 <- which(!(is.na(razaoAlbuminaCreatininaRastreavelOnda1) | razaoAlbuminaCreatininaRastreavelOnda1 > 20))
idxRazaoAlbuminaCreatininaRastreavelOnda2 <- which(!(is.na(razaoAlbuminaCreatininaRastreavelOnda2) | razaoAlbuminaCreatininaRastreavelOnda2 > 20))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxRazaoAlbuminaCreatininaRastreavelOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxRazaoAlbuminaCreatininaRastreavelOnda2]

################################################################################
###data frame
################################################################################
razaoAlbuminaCreatininaRastreavelOnda1 <- data.frame(idadeNaOnda1Ajustada, razaoAlbuminaCreatininaRastreavelOnda1Ajustada)
razaoAlbuminaCreatininaRastreavelOnda2 <- data.frame(idadeNaOnda2Ajustada, razaoAlbuminaCreatininaRastreavelOnda2Ajustada)

################################################################################
###Graficos
################################################################################
#Onda 1
ggplot(data = razaoAlbuminaCreatininaRastreavelOnda1, aes(x = razaoAlbuminaCreatininaRastreavelOnda1Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Ajustada))) +
  ggtitle("Razão albumina-creatinina rastreável (mg/g) - Onda 1") +
  labs(fill = "Idade - Onda 1", y = "Quantidade de pessoas", x = "Concentração em mg/g")

#Onda 2
ggplot(data = razaoAlbuminaCreatininaRastreavelOnda2, aes(x = razaoAlbuminaCreatininaRastreavelOnda2Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Ajustada))) +
  ggtitle("Razão albumina-creatinina rastreável (mg/g) - Onda 2") +
  labs(fill = "Idade - Onda 2", y = "Quantidade de pessoas", x = "Concentração em mg/g")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = razaoAlbuminaCreatininaRastreavelOnda1, aes(x = idadeNaOnda1Ajustada, y = razaoAlbuminaCreatininaRastreavelOnda1Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda1Ajustada)) +
  labs(x = "Idade na Onda 1", y = "Concentração em mg/g") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Razão albumina-creatinina rastreável (mg/g) - Onda 1")

###Onda 2
ggplot(data = razaoAlbuminaCreatininaRastreavelOnda2, aes(x = idadeNaOnda2Ajustada, y = razaoAlbuminaCreatininaRastreavelOnda2Ajustada)) +
  geom_boxplot(aes(group=idadeNaOnda2Ajustada)) +
  labs(x = "Idade na Onda 2", y = "Concentração em mg/g") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Razão albumina-creatinina rastreável (mg/g) - Onda 2")