############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/classNormalMethods.R")

if(!require(dplyr)) install.packages("dplyr")
library(dplyr)                                
if(!require(rstatix)) install.packages("rstatix") 
library(rstatix) 
if(!require(reshape)) install.packages("reshape") 
library(reshape) 
if(!require(PMCMRplus)) install.packages("PMCMRplus") 
library(PMCMRplus)   
if(!require(ggplot2)) install.packages("ggplot2") 
library(ggplot2)
if(!require(VIM)) install.packages("VIM") 
library(VIM)
if(!require(nortest)) install.packages('nortest')
library(nortest)

dfRazaoAlbuminaCreatinina <- data.frame(ID = idElsa,
                               onda1 = razaoAlbuminaCreatininaRastreavelOnda1, 
                               onda2 = razaoAlbuminaCreatininaRastreavelOnda2 
)

################################################################################
###Identificando normalidade em cada onda
dfRazaoAlbuminaCreatinina <- kNN(dfRazaoAlbuminaCreatinina, k = 3)
dfRazaoAlbuminaCreatinina <- dfRazaoAlbuminaCreatinina[,-c(4:ncol(dfRazaoAlbuminaCreatinina))]
###realizando teste de normalidade de Anderson-Darling
ad_test1 <- ad.test(dfRazaoAlbuminaCreatinina$onda1)
ad_test2 <- ad.test(dfRazaoAlbuminaCreatinina$onda2)
print(ad_test1)
print(ad_test2)

# Passo 3: Realizacao do teste de Wilcoxon

wilcox.test(dfRazaoAlbuminaCreatinina$onda1, dfRazaoAlbuminaCreatinina$onda2, paired = TRUE)

dfRazaoAlbuminaCreatinina$dif <- dfRazaoAlbuminaCreatinina$onda1 - dfRazaoAlbuminaCreatinina$onda2
View(dfRazaoAlbuminaCreatinina)

dfRazaoAlbuminaCreatinina %>% get_summary_stats(onda1, onda2, dif, type = "median_iqr")