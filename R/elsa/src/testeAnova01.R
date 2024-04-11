############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src") {     ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src")              ##  
}                                                                                         ##
############################################################################################
source("script_analise_dados_elsa_Var_Lib.R") 
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
library(RVAideMemoire)
library(car)
library(rstatix)
library(DescTools)
################################################################################
imc6Levels <- c("1", "2", "3", "4", "5", "6")
ondaLevels <- c("1", "2", "3")
imc6categoriasOnda1Ajustada <- imc6categoriasOnda1[which(!is.na(imc6categoriasOnda1))]
imc6categoriasOnda2Ajustada <- imc6categoriasOnda2[which(!is.na(imc6categoriasOnda2))]
imc6categoriasOnda3Ajustada <- imc6categoriasOnda3[which(!is.na(imc6categoriasOnda3))]

idxImc6categoriasOnda1 <- which(!is.na(imc6categoriasOnda1))
idxImc6categoriasOnda2 <- which(!is.na(imc6categoriasOnda2))
idxImc6categoriasOnda3 <- which(!is.na(imc6categoriasOnda3))

idadeNaOnda1Ajustada <- idadeNaOnda1[idxImc6categoriasOnda1]
idadeNaOnda2Ajustada <- idadeNaOnda2[idxImc6categoriasOnda2]
idadeNaOnda3Ajustada <- idadeNaOnda3[idxImc6categoriasOnda3]

###This will be the categorical variable
#imc6categoriasOnda1X1 <- factor(imc6categoriasOnda1Ajustada, levels = imc6Levels)
#imc6categoriasOnda2X2 <- factor(imc6categoriasOnda2Ajustada, levels = imc6Levels)
#imc6categoriasOnda3X3 <- factor(imc6categoriasOnda3Ajustada, levels = imc6Levels)
################################################################################
###data.frame
################################################################################
#imc6categoriasOnda1 <- data.frame(idade = idadeNaOnda1Ajustada, imc = imc6categoriasOnda1X1)
#imc6categoriasOnda2 <- data.frame(idade = idadeNaOnda2Ajustada, imc = imc6categoriasOnda2X2)
#imc6categoriasOnda3 <- data.frame(idade = idadeNaOnda3Ajustada, imc = imc6categoriasOnda3X3)

imc6categoriasOnda1 <- data.frame(idade = idadeNaOnda1Ajustada, imc = imc6categoriasOnda1Ajustada)
imc6categoriasOnda2 <- data.frame(idade = idadeNaOnda2Ajustada, imc = imc6categoriasOnda2Ajustada)
imc6categoriasOnda3 <- data.frame(idade = idadeNaOnda3Ajustada, imc = imc6categoriasOnda3Ajustada)

onda1 <- factor(rep(c("1"),each=dim(imc6categoriasOnda1)[1]), levels = ondaLevels)
onda2 <- factor(rep(c("2"),each=dim(imc6categoriasOnda2)[1]), levels = ondaLevels)
onda3 <- factor(rep(c("3"),each=dim(imc6categoriasOnda3)[1]), levels = ondaLevels)

imc6categoriasOnda1["onda"] <- onda1
imc6categoriasOnda2["onda"] <- onda2 
imc6categoriasOnda3["onda"] <- onda3

totalIMC <- rbind(imc6categoriasOnda1, imc6categoriasOnda2, imc6categoriasOnda3)
################################################################################
###Teste de normalidade
###Teste de Levene
###Verificcao de boxplot
################################################################################
byf.shapiro(imc ~ onda, totalIMC)
leveneTest(Y ~ X, imc6categoriasOnda1, center=mean)
boxplot(Y ~ X, imc6categoriasOnda1, ylab = "Idades na Onda 1", xlab = "IMC - 6 categorias")

imc6categoriasOnda1 %>%  
  group_by(X) %>% 
  identify_outliers(Y)

anova_imc6_onda1 <- aov(Y ~ X, imc6categoriasOnda1)
summary(anova_imc6_onda1)

################################################################################
PostHocTest(anova_imc6_onda1, method = "duncan", con.level = 0.95) #Teste liberal
PostHocTest(anova_imc6_onda1, method = "hsd", con.level = 0.95) #Teste moderado
PostHocTest(anova_imc6_onda1, method = "bonf", con.level = 0.95) #Teste conservador
################################################################################
###
################################################################################
imc6categoriasOnda1
str(imc6categoriasOnda1)
modelo.anova <- lm(Y ~ X, data = imc6categoriasOnda1)
summary(modelo.anova)
anova(modelo.anova)
plot(modelo.anova)
################################################################################
modelo.anova2 <- aov(Y ~ X, data = imc6categoriasOnda1)