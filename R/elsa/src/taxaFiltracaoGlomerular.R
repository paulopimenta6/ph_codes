############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src") {   ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src")            ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
###Taxa filtração glomerular com calibração
################################################################################
taxaFiltracaoGlomerularCalOnda1 <- categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1[which(!is.na(categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1))]
taxaFiltracaoGlomerularCalOnda2 <- categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2[which(!is.na(categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2))]

idxTaxaFiltracaoGlomerularCalOnda1 <- which(!is.na(categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1))
idxTaxaFiltracaoGlomerularCalOnda2 <- which(!is.na(categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2))

idadeTaxaOnda1 <- idadeNaOnda1[idxTaxaFiltracaoGlomerularCalOnda1]
idadeTaxaOnda2 <- idadeNaOnda2[idxTaxaFiltracaoGlomerularCalOnda2]

################################################################################
###Criando Data Frames
################################################################################
taxaFiltracaoGlomerularCalOnda1Ajustada <- data.frame(idadeTaxaOnda1, taxaFiltracaoGlomerularCalOnda1)
taxaFiltracaoGlomerularCalOnda2Ajustada <- data.frame(idadeTaxaOnda2, taxaFiltracaoGlomerularCalOnda2)

################################################################################
###Graficos
################################################################################
#Onda 1
ggplot(data = taxaFiltracaoGlomerularCalOnda1Ajustada, aes(x = taxaFiltracaoGlomerularCalOnda1)) + 
  geom_bar(aes(fill=as.factor(idadeTaxaOnda1))) +
  ggtitle("Taxa de filtração glomerular - Onda 1") +
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas", x = "1 - Maior ou igual a 90. 2 - Entre 60 e 90. 3 - Entre 45 e 60. 4 - Entre 30 e 45. 5 - Entre 15 e 30. 6 - Menor do que 15")
#Onda 2
ggplot(data = taxaFiltracaoGlomerularCalOnda2Ajustada, aes(x = taxaFiltracaoGlomerularCalOnda2)) + 
  geom_bar(aes(fill=as.factor(idadeTaxaOnda2))) +
  ggtitle("Taxa de filtração glomerular - Onda 2") +
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas", x = "1 - Maior ou igual a 90. 2 - Entre 60 e 90. 3 - Entre 45 e 60. 4 - Entre 30 e 45. 5 - Entre 15 e 30. 6 - Menor do que 15")

################################################################################
###Boxplot
################################################################################
###Onda 1
ggplot(data = taxaFiltracaoGlomerularCalOnda1Ajustada, aes(y = idadeTaxaOnda1, x = taxaFiltracaoGlomerularCalOnda1)) +
  geom_boxplot(aes(group=taxaFiltracaoGlomerularCalOnda1)) +
  labs(y = "Idade na Onda 1", x = "Taxa de Filtração Glomerular") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Taxa de Filtração Glomerular - Onda 1")
###Onda 2
ggplot(data = taxaFiltracaoGlomerularCalOnda2Ajustada, aes(y = idadeTaxaOnda2, x = taxaFiltracaoGlomerularCalOnda2)) +
  geom_boxplot(aes(group=taxaFiltracaoGlomerularCalOnda2)) +
  labs(y = "Idade na Onda 2", x = "Taxa de Filtração Glomerular") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Taxa de Filtração Glomerular - Onda 2")