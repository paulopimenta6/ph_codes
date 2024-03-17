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

################################################################################
###grafico de barra
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

################################################################################
###grafico de pontos
###Removendo outliers
###Tratamento dos dados >> remocao de outliers e dados nulos
indicesMicroalbuminuriaOnda1 <- which(!(microalbuminuriaOnda1 > 5 | is.na(microalbuminuriaOnda1)))
indicesMicroalbuminuriaOnda2 <- which(!(microalbuminuriaOnda2 > 5 | is.na(microalbuminuriaOnda2)))

microalbuminuriaOnda1 <- microalbuminuriaOnda1[!(microalbuminuriaOnda1 > 5 | is.na(microalbuminuriaOnda1))]
microalbuminuriaOnda2 <- microalbuminuriaOnda2[!(microalbuminuriaOnda2 > 5 | is.na(microalbuminuriaOnda2))]

idadeNaOnda1MicroalbuminuriaOnda1 <- idadeNaOnda1[indicesMicroalbuminuriaOnda1]
idadeNaOnda2MicroalbuminuriaOnda2 <- idadeNaOnda1[indicesMicroalbuminuriaOnda2]

microalbuminuriaOnda1Ajustada1 <- data.frame(idadeNaOnda1MicroalbuminuriaOnda1,microalbuminuriaOnda1)
microalbuminuriaOnda2Ajustada2 <- data.frame(idadeNaOnda2MicroalbuminuriaOnda2,microalbuminuriaOnda2)

###graficos
ggplot(data = microalbuminuriaOnda1Ajustada1, mapping = aes(y = idadeNaOnda1MicroalbuminuriaOnda1 , x = microalbuminuriaOnda1)) + 
  geom_point() +
  xlab("Concentração em (mg/dl) - Onda 1") +
  ylab("Idade") +
  ggtitle("Distribuição da Microalbuminúria na Onda 1")

ggplot(data = microalbuminuriaOnda2Ajustada2, mapping = aes(y = idadeNaOnda2MicroalbuminuriaOnda2 , x = microalbuminuriaOnda2)) + 
  geom_point() +
  xlab("Concentração em (mg/dl) - Onda 2") +
  ylab("Idade") +
  ggtitle("Distribuição da Microalbuminúria na Onda 2")


###grafico de barra
###Onda1
ggplot(data = microalbuminuriaOnda1Ajustada1, mapping = aes(x = microalbuminuriaOnda1)) + 
  geom_bar() +
  xlab("Concentração em (mg/dl) - Onda 1") +
  ylab("Quantidade") +
  ggtitle("Distribuição da Microalbuminúria na Onda 1")

ggplot(data = microalbuminuriaOnda2Ajustada2, mapping = aes(x = microalbuminuriaOnda2)) + 
  geom_bar() +
  xlab("Concentração em (mg/dl) - Onda 2") +
  ylab("Quantidade") +
  ggtitle("Distribuição da Microalbuminúria na Onda 2")

###
#graficos mais expositivos
ggplot(data = microalbuminuriaOnda1Ajustada1, mapping = aes(x = microalbuminuriaOnda1)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1MicroalbuminuriaOnda1))) + 
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "Concentração em (mg/dl) - Onda 1 - onda 1")


ggplot(data = microalbuminuriaOnda2Ajustada2, aes(x = microalbuminuriaOnda2)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2MicroalbuminuriaOnda2))) + 
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "Concentração em (mg/dl) - Onda 2 - onda 2")

