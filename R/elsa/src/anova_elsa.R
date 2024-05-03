############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R")  
library(scales) # to access break formatting functions
library(tidyverse)
library(dplyr)
library(ggplot2)
library(car)
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
#pressaoDiastolicamediaOnda1 
#pressaoDiastolicamediaOnda2 
#pressaoDiastolicamediaOnda3 

###Pressao sistolica 
len_PAS1 <- length(pressaoArterialSistolicaMediaOnda1) 
len_PAS2 <- length(pressaoArterialSistolicaMediaOnda2) 
len_PAS3 <- length(pressaoArterialSistolicaMediaOnda3) 

PAS1_onda1 <- rep(c("O1"), each = len_PAS1)
PAS2_onda2 <- rep(c("O2"), each = len_PAS2)
PAS3_onda3 <- rep(c("O3"), each = len_PAS3)  
onda <- c(PAS1_onda1, PAS2_onda2, PAS3_onda3)
onda <- factor(onda)

pas <- c(pressaoArterialSistolicaMediaOnda1, pressaoArterialSistolicaMediaOnda2, pressaoArterialSistolicaMediaOnda3)
normalized_df <- normalize_data(pas)
df_PAS <- data.frame(PAS = normalized_df, Onda = onda)

model <- aov(df_PAS$PAS ~ df_PAS$Onda, data = df_PAS)
model
summary(model)
leveneTest(df_PAS$PAS ~ df_PAS$Onda, data = df_PAS)




