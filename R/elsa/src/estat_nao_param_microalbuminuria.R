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

dfMicroalbuminuria <- data.frame(ID = idElsa,
                               onda1 = microalbuminuriaOnda1, 
                               onda2 = microalbuminuriaOnda2
)

################################################################################
###Identificando normalidade em cada onda
dfMicroalbuminuria <- kNN(dfMicroalbuminuria, k = 3)
dfMicroalbuminuria <- dfMicroalbuminuria[,-c(5:ncol(dfMicroalbuminuria))]
###realizando teste de normalidade de Anderson-Darling
ad_test1 <- ad.test(dfMicroalbuminuria$onda1)
ad_test2 <- ad.test(dfMicroalbuminuria$onda2)
print(ad_test1)
print(ad_test2)
################################################################################
# Passo 3: Realizacao do teste de Wilcoxon

wilcox.test(dfMicroalbuminuria$onda1, dfMicroalbuminuria$onda2, paired = TRUE)

dfMicroalbuminuria$dif <- dfMicroalbuminuria$onda1 - dfMicroalbuminuria$onda2
View(dfMicroalbuminuria)

dfMicroalbuminuria %>% get_summary_stats(onda1, onda2, dif, type = "median_iqr")