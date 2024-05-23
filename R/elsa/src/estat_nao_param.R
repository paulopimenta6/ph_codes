############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R") 
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

df1 <- data.frame(ID = idElsa,
                   onda1 = hemoglobinaGlicadaHba1cOnda1, 
                   onda2 = hemoglobinaGlicadaHba2cOnda2, 
                   onda3 = hemoglobinaGlicadaHba3cOnda3
                  )

dadosl <- melt(df1,
               id = "ID",
               measured = c("onda1", "onda2", "onda3"))

colnames(dadosl) = c("ID", "Onda", "Hba")
dadosl <- sort_df(dadosl, vars = "ID")
dadosl$ID <- factor(dadosl$ID)

friedman.test(dadosl$Hba, dadosl$Onda, dadosl$ID)

#Testes de post-hoc

##Wilcoxon com correcao de Bonferroni
dadosl %>% wilcox_test(Hba ~ Onda, paired = TRUE, p.adjust.method = "bonferroni")

#frdAllPairsSiegelTest(dadosl$Hba, dadosl$Onda, dadosl$ID, p.adjust.method = "bonferroni")
#frdAllPairsNemenyiTest(dadosl$Hba, dadosl$Onda, dadosl$ID, p.adjust.method = "bonferroni")
#frdAllPairsConoverTest(dadosl$Hba, dadosl$Onda, dadosl$ID, p.adjust.method = "bonferroni")



