############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src") {     ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src")              ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
################################################################################
imc6Levels <- c("1", "2", "3", "4", "5", "6")
imc6categoriasOnda1Ajustada <- imc6categoriasOnda1[which(!is.na(imc6categoriasOnda1))]
imc6categoriasOnda2Ajustada <- imc6categoriasOnda2[which(!is.na(imc6categoriasOnda2))]
imc6categoriasOnda3Ajustada <- imc6categoriasOnda3[which(!is.na(imc6categoriasOnda3))]

idxImc6categoriasOnda1 <- which(!is.na(imc6categoriasOnda1))
idxImc6categoriasOnda2 <- which(!is.na(imc6categoriasOnda2))
idxImc6categoriasOnda3 <- which(!is.na(imc6categoriasOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxImc6categoriasOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxImc6categoriasOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxImc6categoriasOnda3]

imc6categoriasOnda1X1 <- factor(imc6categoriasOnda1Ajustada, levels = imc6Levels)
################################################################################
###data.frame
################################################################################
imc6categoriasOnda1 <- data.frame(Y = idadeNaOnda1Ajustada, X = imc6categoriasOnda1X1)

################################################################################
###
################################################################################
imc6categoriasOnda1
str(imc6categoriasOnda1)
modelo.anova <- lm(Y ~ X, data = imc6categoriasOnda1)
summary(modelo.anova)
anova(modelo.anova)
plot(modelo.anova)
################################################################################
modelo.anova2 <- aov(Y ~ X, data = imc6categoriasOnda1)