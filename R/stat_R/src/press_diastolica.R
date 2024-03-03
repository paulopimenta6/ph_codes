library(readr)
library(tidyverse)
library(dplyr)
source("script_analise_dados_elsa_Var_Lib.R")

pressaoDiastolicameiaOnda1 
pressaoDiastolicameiaOnda2 
pressaoDiastolicameiaOnda3 

ggplot(importaDadosLib, aes(x = pressaoDiastolicameiaOnda1)) + geom_bar(aes(fill=as.factor(idadeNaOnda1))) + labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "pressão arterial diastólica média (mmhg) - onda 1")
ggplot(importaDadosLib, aes(x = pressaoDiastolicameiaOnda2)) + geom_bar(aes(fill=as.factor(idadeNaOnda2))) + labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "pressão arterial diastólica média (mmhg) - onda 2")
ggplot(importaDadosLib, aes(x = pressaoDiastolicameiaOnda3)) + geom_bar(aes(fill=as.factor(idadeNaOnda3))) + labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "pressão arterial diastólica média (mmhg) - onda 3")


ggplot(data = importaDadosLib, mapping = aes(x = pressaoDiastolicameiaOnda1)) + geom_bar() + labs(y = "Quantidade de pessoas na onda 1", x = "pressão arterial diastólica média (mmhg) - onda 1")
ggplot(data = importaDadosLib, mapping = aes(x = pressaoDiastolicameiaOnda2)) + geom_bar() + labs(y = "Quantidade de pessoas na onda 2", x = "pressão arterial diastólica média (mmhg) - onda 2")
ggplot(data = importaDadosLib, mapping = aes(x = pressaoDiastolicameiaOnda3)) + geom_bar() + labs(y = "Quantidade de pessoas na onda 3", x = "pressão arterial diastólica média (mmhg) - onda 3")