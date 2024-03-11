############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src") {   ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src")            ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions

barplot(table(microalbuminuriaOnda1), xlab = "Concentração em (mg/dl)", ylab = "Micro Albuminuria na onda 1") 
barplot(table(microalbuminuriaOnda2), xlab = "Concentração em (mg/dl)", ylab = "Micro Albuminuria na onda 2")

#microalbuminuriaOnda1DF = data.frame(value = microalbuminuriaOnda1)
#microalbuminuriaOnda2DF = data.frame(value = microalbuminuriaOnda2)

microalbuminuriaOnda1DF <- microalbuminuriaOnda1[!is.na(microalbuminuriaOnda1)]
microalbuminuriaOnda2DF <- microalbuminuriaOnda2[!is.na(microalbuminuriaOnda2)]

###############################################
#summary(microalbuminuriaOnda1DF$value)   #####
summary(microalbuminuriaOnda1DF)          #####
###############################################
#summary(microalbuminuriaOnda2DF$value)   #####
summary(microalbuminuriaOnda2DF)          #####
###############################################

#microalbuminuriaOnda1DF <- microalbuminuriaOnda1DF[!is.na(microalbuminuriaOnda1DF$value), ]
#microalbuminuriaOnda2DF <- microalbuminuriaOnda2DF[!is.na(microalbuminuriaOnda2DF$value), ]

microalbuminuriaOnda1DF = data.frame(value = microalbuminuriaOnda1DF)
microalbuminuriaOnda2DF = data.frame(value = microalbuminuriaOnda2DF)

###Onda1
microalbuminuriaOnda1DF$value <- as.numeric(as.character(microalbuminuriaOnda1DF$value))
ggplot(data = microalbuminuriaOnda1DF, mapping = aes(x = factor(value))) + 
  geom_bar() +
  xlab("Concentração em (mg/dl) - Onda 1") +
  ylab("Quantidade") +
  scale_x_discrete(breaks = seq(0, 2, by = 0.1)) +
  ggtitle("Distribuição da Microalbuminúria na Onda 1")

###Onda2
microalbuminuriaOnda2DF$value <- as.numeric(as.character(microalbuminuriaOnda2DF$value))
ggplot(data = microalbuminuriaOnda2DF, mapping = aes(x = factor(value))) + 
  geom_bar() +
  xlab("Concentração em (mg/dl) - Onda 2") +
  ylab("Quantidade") +
  scale_x_discrete(breaks = seq(0, 2, by = 0.1)) +
  ggtitle("Distribuição da Microalbuminúria na Onda 2")

