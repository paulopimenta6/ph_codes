############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src") {   ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src")            ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions

idxPressaoSistolicamediaOnda1 <- which(!(is.na(pressaoArterialSistolicaMediaOnda1)))
idxPressaoSistolicamediaOnda2 <- which(!(is.na(pressaoArterialSistolicaMediaOnda2)))
idxPressaoSistolicamediaOnda3 <- which(!(is.na(pressaoArterialSistolicaMediaOnda3)))

pressaoArterialSistolicaMediaOnda1 <- pressaoArterialSistolicaMediaOnda1[which(!(is.na(pressaoArterialSistolicaMediaOnda1)))]
pressaoArterialSistolicaMediaOnda2 <- pressaoArterialSistolicaMediaOnda2[which(!(is.na(pressaoArterialSistolicaMediaOnda2)))]
pressaoArterialSistolicaMediaOnda3 <- pressaoArterialSistolicaMediaOnda3[which(!(is.na(pressaoArterialSistolicaMediaOnda3)))]

idadeNaOnda1Pres <- idadeNaOnda1[idxPressaoSistolicamediaOnda1]
idadeNaOnda2Pres <- idadeNaOnda2[idxPressaoSistolicamediaOnda2]
idadeNaOnda3Pres <- idadeNaOnda3[idxPressaoSistolicamediaOnda3]

presSistolicaOnda1 <- data.frame(idadeNaOnda1Pres, pressaoArterialSistolicaMediaOnda1)
presSistolicaOnda2 <- data.frame(idadeNaOnda2Pres, pressaoArterialSistolicaMediaOnda2)
presSistolicaOnda3 <- data.frame(idadeNaOnda3Pres, pressaoArterialSistolicaMediaOnda3)

ggplot(data = presSistolicaOnda1, aes(x = pressaoArterialSistolicaMediaOnda1)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Pres))) + 
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "pressão arterial sistólica média (mmhg) - onda 1")


ggplot(data = presSistolicaOnda2, aes(x = pressaoArterialSistolicaMediaOnda2)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Pres))) + 
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "pressão arterial sistólica média (mmhg) - onda 2")

ggplot(data = presSistolicaOnda3, aes(x = pressaoArterialSistolicaMediaOnda3)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Pres))) + 
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "pressão arterial sistólica média (mmhg) - onda 3")

##boxplot
#boxplot(idadeNaOnda1Pres~presDiastolicaOnda1$pressaoDiastolicamediaOnda1, data=presDiastolicaOnda1)
#boxplot(idadeNaOnda2Pres~presDiastolicaOnda2$pressaoDiastolicamediaOnda2, data=presDiastolicaOnda2)
#boxplot(idadeNaOnda3Pres~presDiastolicaOnda3$pressaoDiastolicamediaOnda3, data=presDiastolicaOnda3)

ggplot(data = presSistolicaOnda1, aes(y = idadeNaOnda1Pres, x = pressaoArterialSistolicaMediaOnda1)) +
  geom_boxplot(aes(group=pressaoArterialSistolicaMediaOnda1)) +
  labs(x = "pressão arterial sistólica média (mmhg)", y = "Idade") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Onda 1")


ggplot(data = presSistolicaOnda2, aes(y = idadeNaOnda2Pres, x = pressaoArterialSistolicaMediaOnda2)) +
  geom_boxplot(aes(group=pressaoArterialSistolicaMediaOnda2)) +
  labs(x = "pressão arterial sistólica média (mmhg)", y = "Idade") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Onda 2")

ggplot(data = presSistolicaOnda3, aes(y = idadeNaOnda3Pres, x = pressaoArterialSistolicaMediaOnda3)) +
  geom_boxplot(aes(group=pressaoArterialSistolicaMediaOnda3)) +
  labs(x = "pressão arterial sistólica média (mmhg)", y = "Idade") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Onda 3")

