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

dfcreatRastSangue <- data.frame(ID = idElsa,
                    onda1 = creatininaRastreavelNaUrinaOnda1, 
                    onda2 = creatininaRastreavelNaUrinaOnda2, 
                    onda3 = creatininaRastreavelNaUrinaOnda3
)

dadoslcreatRastSangue <- melt(dfcreatRastSangue,
                  id = "ID",
                  measured = c("onda1", "onda2", "onda3"))

colnames(dadoslcreatRastSangue) = c("ID", "Onda", "creatRastSangue")
dadoslcreatRastSangue <- sort_df(dadoslcreatRastSangue, vars = "ID")
dadoslcreatRastSangue$ID <- factor(dadoslcreatRastSangue$ID)

dadoslcreatRastSangue_interpol <- kNN(dadoslcreatRastSangue, k = 3)
dadoslcreatRastSangue_interpol <- dadoslcreatRastSangue_interpol[,-c(4:ncol(dadoslcreatRastSangue_interpol))]

#friedman.test(dadoslcreatRastSangue$Hba, dadoslcreatRastSangue$Onda, dadoslcreatRastSangue$ID)
friedman.test(dadoslcreatRastSangue_interpol$creatRastSangue, dadoslcreatRastSangue_interpol$Onda, dadoslcreatRastSangue_interpol$ID)

#Testes de post-hoc

##Wilcoxon com correcao de Bonferroni
dadoslcreatRastSangue_interpol %>% wilcox_test(creatRastSangue ~ Onda, paired = TRUE, p.adjust.method = "bonferroni")
##post-hocs do pacote PMCMRplus: 
### Dunn-Bonferroni
frdAllPairsSiegelTest(dadoslcreatRastSangue_interpol$creatRastSangue, dadoslcreatRastSangue_interpol$Onda, dadoslcreatRastSangue_interpol$ID, p.adjust.method = "bonferroni")

##Outros com ajuste de bonferroni
frdAllPairsNemenyiTest(dadoslcreatRastSangue_interpol$creatRastSangue, dadoslcreatRastSangue_interpol$Onda, dadoslcreatRastSangue_interpol$ID, p.adjust.method = "bonferroni")
frdAllPairsConoverTest(dadoslcreatRastSangue_interpol$creatRastSangue, dadoslcreatRastSangue_interpol$Onda, dadoslcreatRastSangue_interpol$ID, p.adjust.method = "bonferroni")

# Analise descritiva dos dados
dadoslcreatRastSangue_interpol %>% group_by(Onda) %>% 
  get_summary_stats(creatRastSangue, type = "median_iqr")

png("./img/estat_nao_param/creatinina_rastreavel_sangue/creatRastSangue_friendman.png", width = 70, height = 20, units = "cm", res = 300)
par(mfrow=c(1,3))
# Onda 1
hist_data_onda1 <- dadoslcreatRastSangue_interpol$creatRastSangue[dadoslcreatRastSangue_interpol$Onda == "onda1"]
hist(hist_data_onda1,
     ylab = "Frequencia", xlab = "creatinina Rastreavel Sangue (mg/dl)", main="Onda 1")
abline(v = median(hist_data_onda1), col = "red")

# Onda 2
hist_data_onda2 <- dadoslcreatRastSangue_interpol$creatRastSangue[dadoslcreatRastSangue_interpol$Onda == "onda2"]
hist(hist_data_onda2,
     ylab = "Frequencia", xlab = "creatinina Rastreavel Sangue (mg/dl)", main="Onda 2")
abline(v = median(hist_data_onda2), col = "red")

# Onda 3
hist_data_onda3 <- dadoslcreatRastSangue_interpol$creatRastSangue[dadoslcreatRastSangue_interpol$Onda == "onda3"]
hist(hist_data_onda3,
     ylab = "Frequencia", xlab = "creatinina Rastreavel Sangue (mg/dl)", main="Onda 3")
abline(v = median(hist_data_onda3), col = "red")
dev.off()