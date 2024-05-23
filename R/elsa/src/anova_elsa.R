############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R")  
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
library(dplyr)                                
library(RVAideMemoire)                                        
library(car)                                
library(psych)                                
library(rstatix)                                
library(DescTools)
library(nortest)
################################################################################
normalize_data <- function(data) {
  normalized <- c()
  for (i in 1:length(data)){
  normalized <- c(normalized, (data[i] - min(data, na.rm=TRUE))/(max(data, na.rm=TRUE) - min(data, na.rm=TRUE)))
  }
  
  return(normalized)
}
################################################################################
###pressao diastolica
pressaoDiastolicamediaOnda1Ajustada <- pressaoDiastolicamediaOnda1[which(!is.na(pressaoDiastolicamediaOnda1))]  
pressaoDiastolicamediaOnda2Ajustada <- pressaoDiastolicamediaOnda2[which(!is.na(pressaoDiastolicamediaOnda2))]  
pressaoDiastolicamediaOnda3Ajustada <- pressaoDiastolicamediaOnda3[which(!is.na(pressaoDiastolicamediaOnda3))]  

###Pressao sistolica 
len_PAS1 <- length(pressaoDiastolicamediaOnda1Ajustada) 
len_PAS2 <- length(pressaoDiastolicamediaOnda2Ajustada) 
len_PAS3 <- length(pressaoDiastolicamediaOnda3Ajustada) 

PAS1_onda1 <- rep(c("O1"), each = len_PAS1)
PAS2_onda2 <- rep(c("O2"), each = len_PAS2)
PAS3_onda3 <- rep(c("O3"), each = len_PAS3)  
onda <- c(PAS1_onda1, PAS2_onda2, PAS3_onda3)
onda <- factor(onda)

pas <- c(pressaoDiastolicamediaOnda1Ajustada, pressaoDiastolicamediaOnda2Ajustada, pressaoDiastolicamediaOnda3Ajustada)
pasNorm <- scale(pas)
pasNorm <- data.frame(pasNorm)
df_PAS <- data.frame(pasNorm, onda)

ad_test <- ad.test(df_PAS$pasNorm)
leveneTest(df_PAS$pasNorm ~ df_PAS$onda, df_PAS, center = mean)
boxplot(df_PAS$pasNorm ~ df_PAS$onda, df_PAS)

model <- aov(df_PAS$pasNorm ~ df_PAS$onda, data = df_PAS)
model
summary(model)
leveneTest(df_PAS$pasNorm ~ df_PAS$onda, data = df_PAS)




