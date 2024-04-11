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
densidadetrafegoPorDistanciaCasaOnda1Ajustada     <- densidadetrafegoPorDistanciaCasaOnda1[which(!is.na(densidadetrafegoPorDistanciaCasaOnda1))]
densidadetrafegoPorDistanciaTrabalhoOnda1Ajustada <- densidadetrafegoPorDistanciaTrabalhoOnda1[which(is.na(densidadetrafegoPorDistanciaTrabalhoOnda1))]

idxDensidadetrafegoPorDistanciaCasaOnda1     <- which(!is.na(densidadetrafegoPorDistanciaCasaOnda1))
idxDensidadetrafegoPorDistanciaTrabalhoOnda1 <- which(is.na(densidadetrafegoPorDistanciaTrabalhoOnda1))

