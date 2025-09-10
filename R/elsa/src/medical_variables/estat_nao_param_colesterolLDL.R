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
dfColesterolLDL <- data.frame(ID = idElsa,
                              onda1 = colesterolLdlOnda1, 
                              onda2 = colesterolLdlOnda2, 
                              onda3 = colesterolLdlOnda3
)

################################################################################
dfColesterolLDL <- kNN(dfColesterolLDL, k = 3)
dfColesterolLDL <- dfColesterolLDL[,-c(5:ncol(dfColesterolLDL))]
###realizando teste de normalidade de Anderson-Darling
ad_test1 <- ad.test(dfColesterolLDL$onda1)
ad_test2 <- ad.test(dfColesterolLDL$onda2)
ad_test3 <- ad.test(dfColesterolLDL$onda3)
print(ad_test1)
print(ad_test2)
print(ad_test3)
################################################################################

dadoslcolesterolLDL_interpol <- melt(dfColesterolLDL,
                                     id = "ID",
                                     measured = c("onda1", "onda2", "onda3"))

colnames(dadoslcolesterolLDL_interpol) = c("ID", "Onda", "colesterolLDL")
dadoslcolesterolLDL_interpol <- sort_df(dadoslcolesterolLDL_interpol, vars = "ID")
dadoslcolesterolLDL_interpol$ID <- factor(dadoslcolesterolLDL_interpol$ID)

################################################################################
###Identificando outliers na totalidade
dadoslcolesterolLDL_interpol %>% group_by(Onda) %>% identify_outliers(colesterolLDL) 
###Identificando normalidade na totalidade agrupada pela Onda

# Aplicar o teste de Anderson-Darling por grupo
normalTestAdersonDarlingGroup <- dadoslcolesterolLDL_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ad_test = list(anderson_darling_test(colesterolLDL))) %>%
  unnest(cols = ad_test)
print(normalTestAdersonDarlingGroup)

# Aplicar o teste de Komolgorov-Smirnov por grupo
normalTesteKomolgorovSmirnovGroup <- dadoslcolesterolLDL_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ks_test = list(ks_test(colesterolLDL))) %>%
  unnest(cols = ks_test)
print(normalTesteKomolgorovSmirnovGroup)
################################################################################

#friedman.test(dadoslcreatRastSangue$Hba, dadoslcreatRastSangue$Onda, dadoslcreatRastSangue$ID)
friedman.test(dadoslcolesterolLDL_interpol$colesterolLDL, dadoslcolesterolLDL_interpol$Onda, dadoslcolesterolLDL_interpol$ID)

#Testes de post-hoc

##Wilcoxon com correcao de Bonferroni
dadoslcolesterolLDL_interpol %>% wilcox_test(colesterolLDL ~ Onda, paired = TRUE, p.adjust.method = "bonferroni")
##post-hocs do pacote PMCMRplus: 
### Dunn-Bonferroni
frdAllPairsSiegelTest(dadoslcolesterolLDL_interpol$colesterolLDL, dadoslcolesterolLDL_interpol$Onda, dadoslcolesterolLDL_interpol$ID, p.adjust.method = "bonferroni")

##Outros com ajuste de bonferroni
frdAllPairsNemenyiTest(dadoslcolesterolLDL_interpol$colesterolLDL, dadoslcolesterolLDL_interpol$Onda, dadoslcolesterolLDL_interpol$ID, p.adjust.method = "bonferroni")
frdAllPairsConoverTest(dadoslcolesterolLDL_interpol$colesterolLDL, dadoslcolesterolLDL_interpol$Onda, dadoslcolesterolLDL_interpol$ID, p.adjust.method = "bonferroni")

# Analise descritiva dos dados
dadoslcolesterolLDL_interpol %>% group_by(Onda) %>% 
  get_summary_stats(colesterolLDL, type = "median_iqr")

png("./img/estat_nao_param/colesterol/colesterolLDL_friendman.png", width = 70, height = 20, units = "cm", res = 300)
par(mfrow=c(1,3))
# Onda 1
hist_data_onda1 <- dadoslcolesterolLDL_interpol$colesterolLDL[dadoslcolesterolLDL_interpol$Onda == "onda1"]
hist(hist_data_onda1,
     ylab = "Frequencia", xlab = "Colesterol LDL (mg/dl)", main="Onda 1")
abline(v = median(hist_data_onda1), col = "red")

# Onda 2
hist_data_onda2 <- dadoslcolesterolLDL_interpol$colesterolLDL[dadoslcolesterolLDL_interpol$Onda == "onda2"]
hist(hist_data_onda2,
     ylab = "Frequencia", xlab = "Colesterol LDL (mg/dl)", main="Onda 2")
abline(v = median(hist_data_onda2), col = "red")

# Onda 3
hist_data_onda3 <- dadoslcolesterolLDL_interpol$colesterolLDL[dadoslcolesterolLDL_interpol$Onda == "onda3"]
hist(hist_data_onda3,
     ylab = "Frequencia", xlab = "Colesterol LDL (mg/dl)", main="Onda 3")
abline(v = median(hist_data_onda3), col = "red")
dev.off()