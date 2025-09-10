############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./script_analise_dados_elsa_Var_Lib.R")
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)

#############################################################################################################################
###fazendo alguns graficos
###metodos quantitativos
ggplot(importaDadosLib, aes(x=((idadeNaOnda1)))) + geom_bar() + xlab("idades na onda 1") + ylab("Quantidade de pacientes")
ggplot(importaDadosLib, aes(x=((idadeNaOnda2)))) + geom_bar() + xlab("idades na onda 2") + ylab("Quantidade de pacientes")
ggplot(importaDadosLib, aes(x=((idadeNaOnda3)))) + geom_bar() + xlab("idades na onda 3") + ylab("Quantidade de pacientes")