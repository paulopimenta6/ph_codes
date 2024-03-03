library(readr)
library(tidyverse)
library(dplyr)
source("script_analise_dados_elsa_Var_Lib.R")

barplot(table(microalbuminuriaOnda1), xlab = "Concentração em (mg/dl)", ylab = "Microalbuminuria na onda 1") 
barplot(table(microalbuminuriaOnda2), xlab = "Concentração em (mg/dl)", ylab = "Microalbuminuria na onda 2") 

ggplot(importaDadosLib, aes(y=microalbuminuriaOnda1, x=idadeNaOnda1)) + geom_point() + xlab("Idade na onda 1") + ylab("microalbuminuria  - mcg/min")
ggplot(importaDadosLib, aes(y=microalbuminuriaOnda2, x=idadeNaOnda2)) + geom_point() + xlab("Idade na onda 2") + ylab("microalbuminuria  - mcg/min")

ggplot(importaDadosLib, aes(y=microalbuminuriaOnda1, x=idadeNaOnda1)) + geom_point() + xlab("Idade na onda 1") + ylab("microalbuminuria  - mcg/min") + ylim(0, 400)
ggplot(importaDadosLib, aes(y=microalbuminuriaOnda2, x=idadeNaOnda2)) + geom_point() + xlab("Idade na onda 2") + ylab("microalbuminuria  - mcg/min") + ylim(0, 400)

ggplot(importaDadosLib, aes(y=microalbuminuriaOnda1, x=idadeNaOnda1)) + geom_point() + xlab("Idade na onda 1") + ylab("microalbuminuria  - mcg/min") + ylim(0, 100)
ggplot(importaDadosLib, aes(y=microalbuminuriaOnda2, x=idadeNaOnda2)) + geom_point() + xlab("Idade na onda 2") + ylab("microalbuminuria  - mcg/min") + ylim(0, 100)

ggplot(importaDadosLib, aes(y=microalbuminuriaOnda1, x=idadeNaOnda1)) + geom_point() + xlab("Idade na onda 1") + ylab("microalbuminuria  - mcg/min") + ylim(0, 25)
ggplot(importaDadosLib, aes(y=microalbuminuriaOnda2, x=idadeNaOnda2)) + geom_point() + xlab("Idade na onda 2") + ylab("microalbuminuria  - mcg/min") + ylim(0, 25)

ggplot(importaDadosLib, aes(y=microalbuminuriaOnda1, x=idadeNaOnda1)) + geom_point() + xlab("Idade na onda 1") + ylab("microalbuminuria  - mcg/min") + ylim(0, 5)
ggplot(importaDadosLib, aes(y=microalbuminuriaOnda2, x=idadeNaOnda2)) + geom_point() + xlab("Idade na onda 2") + ylab("microalbuminuria  - mcg/min") + ylim(0, 5)

#####################################################################################################################################################################
ggplot(data = importaDadosLib, mapping = aes(x = microalbuminuriaOnda1)) + geom_bar() + xlim(0, 10) + ylim(0, 30)
ggplot(data = importaDadosLib, mapping = aes(x = microalbuminuriaOnda2)) + geom_bar() + xlim(0, 10) + ylim(0, 30)