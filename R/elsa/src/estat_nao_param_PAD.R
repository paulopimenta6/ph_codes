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
if(!require(VIM)) install.packages("VIM") 
library(VIM)

dfPAD <- data.frame(ID = idElsa,
                    onda1 = pressaoDiastolicamediaOnda1, 
                    onda2 = pressaoDiastolicamediaOnda2, 
                    onda3 = pressaoDiastolicamediaOnda3
)

dadoslPAD <- melt(dfPAD,
                  id = "ID",
                  measured = c("onda1", "onda2", "onda3"))

colnames(dadoslPAD) = c("ID", "Onda", "PAD")
dadoslPAD <- sort_df(dadoslPAD, vars = "ID")
dadoslPAD$ID <- factor(dadoslPAD$ID)

dadoslPAD_interpol <- kNN(dadoslPAD, k = 3)
dadoslPAD_interpol <- dadoslPAD_interpol[,-c(4:ncol(dadoslPAD_interpol))]

#friedman.test(dadoslPAD$Hba, dadoslPAD$Onda, dadoslPAD$ID)
friedman.test(dadoslPAD_interpol$PAD, dadoslPAD_interpol$Onda, dadoslPAD_interpol$ID)

#Testes de post-hoc

##Wilcoxon com correcao de Bonferroni
dadoslPAD_interpol %>% wilcox_test(PAD ~ Onda, paired = TRUE, p.adjust.method = "bonferroni")
##post-hocs do pacote PMCMRplus: 
### Dunn-Bonferroni
frdAllPairsSiegelTest(dadoslPAD_interpol$PAD, dadoslPAD_interpol$Onda, dadoslPAD_interpol$ID, p.adjust.method = "bonferroni")

##Outros com ajuste de bonferroni
frdAllPairsNemenyiTest(dadoslPAD_interpol$PAD, dadoslPAD_interpol$Onda, dadoslPAD_interpol$ID, p.adjust.method = "bonferroni")
frdAllPairsConoverTest(dadoslPAD_interpol$PAD, dadoslPAD_interpol$Onda, dadoslPAD_interpol$ID, p.adjust.method = "bonferroni")

# Analise descritiva dos dados
dadoslPAD_interpol %>% group_by(Onda) %>% 
  get_summary_stats(PAD, type = "median_iqr")

png("./img/estat_nao_param/pad/PAD_friendman.png", width = 70, height = 20, units = "cm", res = 300)
par(mfrow=c(1,3))
hist_data_onda1 <- dadoslPAD_interpol$PAD[dadoslPAD_interpol$Onda == "onda1"] 
hist(hist_data_onda1,
     ylab = "Frquencia", xlab = "PAD (mmgh)", main="Onda 1")
abline(v=median(hist_data_onda1), col="red")

hist_data_onda2 <- dadoslPAD_interpol$PAD[dadoslPAD_interpol$Onda == "onda2"]
hist(hist_data_onda2,
     ylab = "Frequencia", xlab = "PAD (mmgh)", main="Onda 2")
abline(v=median(hist_data_onda2), col="red")

hist_data_onda3 <- dadoslPAD_interpol$PAD[dadoslPAD_interpol$Onda == "onda3"]
hist(hist_data_onda3,
     ylab = "Frequencia", xlab = "PAD (mmgh)", main="Onda 3")
abline(v=median(hist_data_onda3), col="red")
dev.off()