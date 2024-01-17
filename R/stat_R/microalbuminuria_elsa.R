library(readr)
library(tidyverse)
library(dplyr)
source("script_analise_dados_elsa_Var_Lib.R")

barplot(table(microalbuminuriaOnda1), xlab = "Concentração em (mg/dl)", ylab = "Micro Albuminuria na onda 1") 
barplot(table(microalbuminuriaOnda2), xlab = "Concentração em (mg/dl)", ylab = "Micro Albuminuria na onda 2") 

ggplot(importaDadosLib, aes(y=microalbuminuriaOnda1, x=idadeNaOnda1)) + geom_point() + xlab("Idade na onda 1") + ylab("microalbuminuria  - mcg/min")
ggplot(importaDadosLib, aes(y=microalbuminuriaOnda2, x=idadeNaOnda2)) + geom_point() + xlab("Idade na onda 1") + ylab("microalbuminuria  - mcg/min")

ggplot(importaDadosLib, aes(x=1:length(microalbuminuriaMInOnda1), y = microalbuminuriaMInOnda1)) + geom_bar(stat = "identity")
ggplot(importaDadosLib, aes(x=1:length(microalbuminuriaMInOnda1), y = microalbuminuriaMInOnda1)) + geom_point()
