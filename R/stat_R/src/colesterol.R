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

################################################################################
###Colesterol
################################################################################
###colesterol total
colesterolTotalOnda1Ajustada1 <- colesterolTotalOnda1[which(!is.na(colesterolTotalOnda1))]
colesterolTotalOnda2Ajustada2 <- colesterolTotalOnda2[which(!is.na(colesterolTotalOnda2))]
colesterolTotalOnda3Ajustada3 <- colesterolTotalOnda3[which(!is.na(colesterolTotalOnda3))]

###colesterol hdl
colesterolHdlOnda1Ajustada1 <- colesterolHdlOnda1[which(!is.na(colesterolHdlOnda1))]
colesterolHdlOnda2Ajustada2 <- colesterolHdlOnda2[which(!is.na(colesterolHdlOnda2))]
colesterolHdlOnda3Ajustada3 <- colesterolHdlOnda3[which(!is.na(colesterolHdlOnda3))]

##colesterol ldl
colesterolLdlOnda1Ajustada1 <- colesterolLdlOnda1[which(!is.na(colesterolLdlOnda1))]
colesterolLdlOnda2Ajustada2 <- colesterolLdlOnda2[which(!is.na(colesterolLdlOnda2))]  
colesterolLdlOnda3Ajustada3 <- colesterolLdlOnda3[which(!is.na(colesterolLdlOnda3))]
################################################################################
###Idades
################################################################################
#indices
IdxcolesterolTotalOnda1Ajustada1 <- which(!is.na(colesterolTotalOnda1))
IdxcolesterolTotalOnda2Ajustada2 <- which(!is.na(colesterolTotalOnda2))
IdxcolesterolTotalOnda3Ajustada3 <- which(!is.na(colesterolTotalOnda3))

###colesterol hdl
IdxcolesterolHdlOnda1Ajustada1 <- which(!is.na(colesterolHdlOnda1))
IdxcolesterolHdlOnda2Ajustada2 <- which(!is.na(colesterolHdlOnda2))
IdxcolesterolHdlOnda3Ajustada3 <- which(!is.na(colesterolHdlOnda3))

##colesterol ldl
IdxcolesterolLdlOnda1Ajustada1 <- which(!is.na(colesterolLdlOnda1))
IdxcolesterolLdlOnda2Ajustada2 <- which(!is.na(colesterolLdlOnda2))  
IdxcolesterolLdlOnda3Ajustada3 <- which(!is.na(colesterolLdlOnda3))
################################################################################
#idades
################################################################################
idadeColTotalOnda1 <- idadeNaOnda1[IdxcolesterolTotalOnda1Ajustada1] 
idadeColTotalOnda2 <- idadeNaOnda2[IdxcolesterolTotalOnda2Ajustada2]
idadeColTotalOnda3 <- idadeNaOnda3[IdxcolesterolTotalOnda3Ajustada3]

###colesterol hdl
idadehdlOnda1 <- idadeNaOnda1[IdxcolesterolHdlOnda1Ajustada1]
idadehdlOnda2 <- idadeNaOnda2[IdxcolesterolHdlOnda2Ajustada2]
idadehdlOnda3 <- idadeNaOnda3[IdxcolesterolHdlOnda3Ajustada3]

##colesterol ldl
idadeLdlOnda1 <- idadeNaOnda1[IdxcolesterolLdlOnda1Ajustada1] 
idadeLdlOnda2 <- idadeNaOnda2[IdxcolesterolLdlOnda2Ajustada2]
idadeLdlOnda3 <- idadeNaOnda3[IdxcolesterolLdlOnda3Ajustada3]

################################################################################
###Graficos
################################################################################