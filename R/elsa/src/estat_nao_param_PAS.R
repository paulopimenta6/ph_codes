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

dfPAS <- data.frame(ID = idElsa,
                    onda1 = pressaoArterialSistolicaMediaOnda1, 
                    onda2 = pressaoArterialSistolicaMediaOnda2, 
                    onda3 = pressaoArterialSistolicaMediaOnda3
)

dadoslPAS <- melt(dfPAS,
                  id = "ID",
                  measured = c("onda1", "onda2", "onda3"))

colnames(dadoslPAS) = c("ID", "Onda", "PAS")
dadoslPAS <- sort_df(dadoslPAS, vars = "ID")
dadoslPAS$ID <- factor(dadoslPAS$ID)

dadoslPAS_interpol <- kNN(dadoslPAS, k = 3)
dadoslPAS_interpol <- dadoslPAS_interpol[,-c(4:ncol(dadoslPAS_interpol))]

#friedman.test(dadoslPAS$Hba, dadoslPAS$Onda, dadoslPAS$ID)
friedman.test(dadoslPAS_interpol$PAS, dadoslPAS_interpol$Onda, dadoslPAS_interpol$ID)

#Testes de post-hoc

##Wilcoxon com correcao de Bonferroni
dadoslPAS_interpol %>% wilcox_test(PAS ~ Onda, paired = TRUE, p.adjust.method = "bonferroni")
##post-hocs do pacote PMCMRplus: 
### Dunn-Bonferroni
frdAllPairsSiegelTest(dadoslPAS_interpol$PAS, dadoslPAS_interpol$Onda, dadoslPAS_interpol$ID, p.adjust.method = "bonferroni")

##Outros com ajuste de bonferroni
frdAllPairsNemenyiTest(dadoslPAS_interpol$PAS, dadoslPAS_interpol$Onda, dadoslPAS_interpol$ID, p.adjust.method = "bonferroni")
frdAllPairsConoverTest(dadoslPAS_interpol$PAS, dadoslPAS_interpol$Onda, dadoslPAS_interpol$ID, p.adjust.method = "bonferroni")

# Analise descritiva dos dados
dadoslPAS_interpol %>% group_by(Onda) %>% 
  get_summary_stats(PAS, type = "median_iqr")

png("./img/estat_nao_param/pas/PAS_friendman.png", width = 70, height = 20, units = "cm", res = 300)
par(mfrow=c(1,3))
hist_data_onda1 <- dadoslPAS_interpol$PAS[dadoslPAS_interpol$Onda == "onda1"] 
hist(hist_data_onda1,
     ylab = "Frquencia", xlab = "PAS (mmgh)", main="Onda 1")
abline(v=median(hist_data_onda1), col="red")

hist_data_onda2 <- dadoslPAS_interpol$PAS[dadoslPAS_interpol$Onda == "onda2"]
hist(hist_data_onda2,
     ylab = "Frequencia", xlab = "PAS (mmgh)", main="Onda 2")
abline(v=median(hist_data_onda2), col="red")

hist_data_onda3 <- dadoslPAS_interpol$PAS[dadoslPAS_interpol$Onda == "onda3"]
hist(hist_data_onda3,
     ylab = "Frequencia", xlab = "PAS (mmgh)", main="Onda 3")
abline(v=median(hist_data_onda3), col="red")
dev.off()