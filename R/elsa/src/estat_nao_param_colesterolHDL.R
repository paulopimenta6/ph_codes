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

###Colesterol Total
dfColesterolHDL <- data.frame(ID = idElsa,
                                onda1 = colesterolHdlOnda1, 
                                onda2 = colesterolHdlOnda2, 
                                onda3 = colesterolHdlOnda3
)

################################################################################
dfColesterolHDL <- kNN(dfColesterolHDL, k = 3)
dfColesterolHDL <- dfColesterolHDL[,-c(5:ncol(dfColesterolHDL))]
###realizando teste de normalidade de Anderson-Darling
ad_test1 <- ad.test(dfColesterolHDL$onda1)
ad_test2 <- ad.test(dfColesterolHDL$onda2)
ad_test3 <- ad.test(dfColesterolHDL$onda3)
print(ad_test1)
print(ad_test2)
print(ad_test3)
################################################################################

dadoslcolesterolHDL_interpol <- melt(dfColesterolHDL,
                                  id = "ID",
                                  measured = c("onda1", "onda2", "onda3"))

colnames(dadoslcolesterolHDL_interpol) = c("ID", "Onda", "colesterolHDL")
dadoslcolesterolHDL_interpol <- sort_df(dadoslcolesterolHDL_interpol, vars = "ID")
dadoslcolesterolHDL_interpol$ID <- factor(dadoslcolesterolHDL_interpol$ID)

################################################################################
###Identificando outliers na totalidade
dadoslcolesterolHDL_interpol %>% group_by(Onda) %>% identify_outliers(colesterolHDL) 
###Identificando normalidade na totalidade agrupada pela Onda

# Aplicar o teste de Anderson-Darling por grupo
normalTestAdersonDarlingGroup <- dadoslcolesterolHDL_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ad_test = list(anderson_darling_test(colesterolHDL))) %>%
  unnest(cols = ad_test)
print(normalTestAdersonDarlingGroup)

# Aplicar o teste de Komolgorov-Smirnov por grupo
normalTesteKomolgorovSmirnovGroup <- dadoslcolesterolHDL_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ks_test = list(ks_test(colesterolHDL))) %>%
  unnest(cols = ks_test)
print(normalTesteKomolgorovSmirnovGroup)
################################################################################

#friedman.test(dadoslcreatRastSangue$Hba, dadoslcreatRastSangue$Onda, dadoslcreatRastSangue$ID)
friedman.test(dadoslcolesterolHDL_interpol$colesterolHDL, dadoslcolesterolHDL_interpol$Onda, dadoslcolesterolHDL_interpol$ID)

#Testes de post-hoc

##Wilcoxon com correcao de Bonferroni
dadoslcolesterolHDL_interpol %>% wilcox_test(colesterolHDL ~ Onda, paired = TRUE, p.adjust.method = "bonferroni")
##post-hocs do pacote PMCMRplus: 
### Dunn-Bonferroni
frdAllPairsSiegelTest(dadoslcolesterolHDL_interpol$colesterolHDL, dadoslcolesterolHDL_interpol$Onda, dadoslcolesterolHDL_interpol$ID, p.adjust.method = "bonferroni")

##Outros com ajuste de bonferroni
frdAllPairsNemenyiTest(dadoslcolesterolHDL_interpol$colesterolHDL, dadoslcolesterolHDL_interpol$Onda, dadoslcolesterolHDL_interpol$ID, p.adjust.method = "bonferroni")
frdAllPairsConoverTest(dadoslcolesterolHDL_interpol$colesterolHDL, dadoslcolesterolHDL_interpol$Onda, dadoslcolesterolHDL_interpol$ID, p.adjust.method = "bonferroni")

# Analise descritiva dos dados
dadoslcolesterolHDL_interpol %>% group_by(Onda) %>% 
  get_summary_stats(colesterolHDL, type = "median_iqr")

png("./img/estat_nao_param/colesterol/colesterolHDL_friendman.png", width = 70, height = 20, units = "cm", res = 300)
par(mfrow=c(1,3))
# Onda 1
hist_data_onda1 <- dadoslcolesterolHDL_interpol$colesterolHDL[dadoslcolesterolHDL_interpol$Onda == "onda1"]
hist(hist_data_onda1,
     ylab = "Frequencia", xlab = "Colesterol HDL (mg/dl)", main="Onda 1")
abline(v = median(hist_data_onda1), col = "red")

# Onda 2
hist_data_onda2 <- dadoslcolesterolHDL_interpol$colesterolHDL[dadoslcolesterolHDL_interpol$Onda == "onda2"]
hist(hist_data_onda2,
     ylab = "Frequencia", xlab = "Colesterol HDL (mg/dl)", main="Onda 2")
abline(v = median(hist_data_onda2), col = "red")

# Onda 3
hist_data_onda3 <- dadoslcolesterolHDL_interpol$colesterolHDL[dadoslcolesterolHDL_interpol$Onda == "onda3"]
hist(hist_data_onda3,
     ylab = "Frequencia", xlab = "Colesterol HDL (mg/dl)", main="Onda 3")
abline(v = median(hist_data_onda3), col = "red")
dev.off()