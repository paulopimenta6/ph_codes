source("script_analise_dados_elsa_Var_Lib.R") 
library(readr)
library(tidyverse)
library(dplyr)

ggplot() + geom_point(data = importaDadosLib,
                      mapping = aes(y = microalbuminuriaOnda1,
                                    x = idadeNaOnda1))


ggplot() + geom_point(data = importaDadosLib,
                  mapping = aes(y = microalbuminuriaOnda2,
                                x = idadeNaOnda2))

#microalbuminuriaMInOnda1<-importaDadosLib$A_LABA19MCGMIN
#microalbuminuriaMInOnda2<-importaDadosLib$B_LABB19MCGMIN

microalb1 <- group_by(importaDadosLib, A_LABA19MCGMIN)  
data_microalb1 <- summarize(microalb1,
                            cout = n())

#barplot(table(microalbuminuriaOnda1), xlab = "Concentração em (mg/dl)", ylab = "Micro Albuminuria na onda 1") 
#barplot(table(microalbuminuriaOnda2), xlab = "Concentração em (mg/dl)", ylab = "Micro Albuminuria na onda 2")