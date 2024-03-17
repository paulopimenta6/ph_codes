############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src") {   ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/stat_R/src")            ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions

idxHemoglobinaGlicadaHba1cOnda1 <- which(!(is.na(hemoglobinaGlicadaHba1cOnda1)))
idxHemoglobinaGlicadaHba2cOnda2 <- which(!(is.na(hemoglobinaGlicadaHba2cOnda2)))
idxHemoglobinaGlicadaHba3cOnda3 <- which(!(is.na(hemoglobinaGlicadaHba3cOnda3)))

hemoglobinaGlicadaHba1cOnda1Ajustada <- hemoglobinaGlicadaHba1cOnda1[which(!(is.na(hemoglobinaGlicadaHba1cOnda1)))]
hemoglobinaGlicadaHba2cOnda2Ajustada <- hemoglobinaGlicadaHba2cOnda2[which(!(is.na(hemoglobinaGlicadaHba2cOnda2)))]
hemoglobinaGlicadaHba3cOnda3Ajustada <- hemoglobinaGlicadaHba3cOnda3[which(!(is.na(hemoglobinaGlicadaHba3cOnda3)))]

idadeNaOnda1Ajustado <- idadeNaOnda1[idxHemoglobinaGlicadaHba1cOnda1]
idadeNaOnda2Ajustado <- idadeNaOnda2[idxHemoglobinaGlicadaHba2cOnda2]
idadeNaOnda3Ajustado <- idadeNaOnda3[idxHemoglobinaGlicadaHba3cOnda3]

hemoglobinaGlicadaHba1cOnda1 <- data.frame(idadeNaOnda1Ajustado, hemoglobinaGlicadaHba1cOnda1Ajustada)
hemoglobinaGlicadaHba2cOnda2 <- data.frame(idadeNaOnda2Ajustado, hemoglobinaGlicadaHba2cOnda2Ajustada)
hemoglobinaGlicadaHba3cOnda3 <- data.frame(idadeNaOnda3Ajustado, hemoglobinaGlicadaHba3cOnda3Ajustada)

ggplot(data = hemoglobinaGlicadaHba1cOnda1, aes(x = hemoglobinaGlicadaHba1cOnda1Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda1Ajustado))) + 
  labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "Hemoglobina Glicada hbac (%) - Onda 1")

ggplot(data = hemoglobinaGlicadaHba2cOnda2, aes(x = hemoglobinaGlicadaHba2cOnda2Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda2Ajustado))) + 
  labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 3", x = "Hemoglobina Glicada hbac (%) - Onda 2")

ggplot(data = hemoglobinaGlicadaHba3cOnda3, aes(x = hemoglobinaGlicadaHba3cOnda3Ajustada)) + 
  geom_bar(aes(fill=as.factor(idadeNaOnda3Ajustado))) + 
  labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "Hemoglobina Glicada hbac (%) - Onda 3")

###
ggplot(data = hemoglobinaGlicadaHba1cOnda1, aes(y = hemoglobinaGlicadaHba1cOnda1Ajustada, x = idadeNaOnda1Ajustado)) +
  geom_boxplot(aes(group=idadeNaOnda1Ajustado)) +
  labs(x = "Idade", y = "Hemoglobina Glicada hbac (%) - Onda") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Onda 1")

ggplot(data = hemoglobinaGlicadaHba2cOnda2, aes(y = hemoglobinaGlicadaHba2cOnda2Ajustada, x = idadeNaOnda2Ajustado)) +
  geom_boxplot(aes(group=idadeNaOnda2Ajustado)) +
  labs(x = "Idade", y = "Hemoglobina Glicada hbac (%) - Onda") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Onda 2")

ggplot(data = hemoglobinaGlicadaHba3cOnda3, aes(y = hemoglobinaGlicadaHba3cOnda3Ajustada, x = idadeNaOnda3Ajustado)) +
  geom_boxplot(aes(group=idadeNaOnda3Ajustado)) +
  labs(x = "Idade", y = "Hemoglobina Glicada hbac (%) - Onda") +
  theme(plot.title = element_text(hjust = 0.5, size = 12)) +
  ggtitle("Onda 3")