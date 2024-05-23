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

dfHba <- data.frame(ID = idElsa,
                   onda1 = hemoglobinaGlicadaHba1cOnda1, 
                   onda2 = hemoglobinaGlicadaHba2cOnda2, 
                   onda3 = hemoglobinaGlicadaHba3cOnda3
                  )

dadoslHba <- melt(dfHba,
               id = "ID",
               measured = c("onda1", "onda2", "onda3"))

colnames(dadoslHba) = c("ID", "Onda", "Hba")
dadoslHba <- sort_df(dadoslHba, vars = "ID")
dadoslHba$ID <- factor(dadoslHba$ID)

dadoslHba_interpol <- kNN(dadoslHba, k = 3)
dadoslHba_interpol <- dadoslHba_interpol[,-c(4:ncol(dadoslHba_interpol))]

#friedman.test(dadoslHba$Hba, dadoslHba$Onda, dadoslHba$ID)
friedman.test(dadoslHba_interpol$Hba, dadoslHba_interpol$Onda, dadoslHba_interpol$ID)

#Testes de post-hoc

##Wilcoxon com correcao de Bonferroni
dadoslHba_interpol %>% wilcox_test(Hba ~ Onda, paired = TRUE, p.adjust.method = "bonferroni")
##post-hocs do pacote PMCMRplus: 
### Dunn-Bonferroni
frdAllPairsSiegelTest(dadoslHba_interpol$Hba, dadoslHba_interpol$Onda, dadoslHba_interpol$ID, p.adjust.method = "bonferroni")

##Outros com ajuste de bonferroni
frdAllPairsNemenyiTest(dadoslHba_interpol$Hba, dadoslHba_interpol$Onda, dadoslHba_interpol$ID, p.adjust.method = "bonferroni")
frdAllPairsConoverTest(dadoslHba_interpol$Hba, dadoslHba_interpol$Onda, dadoslHba_interpol$ID, p.adjust.method = "bonferroni")

# Analise descritiva dos dados
dadoslHba_interpol %>% group_by(Onda) %>% 
  get_summary_stats(Hba, type = "median_iqr")

png("./img/estat_nao_param/hba/Hba_friendman.png", width = 70, height = 20, units = "cm", res = 300)
par(mfrow=c(1,3))
hist_data_onda1 <- dadoslHba_interpol$Hba[dadoslHba_interpol$Onda == "onda1"]
hist(hist_data_onda1,
     ylab = "Frquencia", xlab = "Hba (%)", main="Onda 1")
abline(v=median(hist_data_onda1), col="red")

hist_data_onda2 <- dadoslHba_interpol$Hba[dadoslHba_interpol$Onda == "onda2"]
hist(hist_data_onda2,
     ylab = "Frequencia", xlab = "Hba (%)", main="Onda 2")
abline(v=median(hist_data_onda2), col="red")

hist_data_onda3 <- dadoslHba_interpol$Hba[dadoslHba_interpol$Onda == "onda3"]
hist(hist_data_onda3,
     ylab = "Frequencia", xlab = "Hba (%)", main="Onda 3")
abline(v=median(hist_data_onda3), col="red")
dev.off()