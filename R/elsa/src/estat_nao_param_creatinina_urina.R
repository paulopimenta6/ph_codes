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

dfcreatRastUrina <- data.frame(ID = idElsa,
                                onda1 = creatininaRastreavelNaUrinaOnda1, 
                                onda2 = creatininaRastreavelNaUrinaOnda2, 
                                onda3 = creatininaRastreavelNaUrinaOnda3
)

################################################################################
###Identificando normalidade em cada onda
dfcreatRastUrina <- kNN(dfcreatRastUrina, k = 3)
dfcreatRastUrina <- dfcreatRastUrina[,-c(5:ncol(dfcreatRastUrina))]
###realizando teste de normalidade de Anderson-Darling
ad_test1 <- ad.test(dfcreatRastUrina$onda1)
ad_test2 <- ad.test(dfcreatRastUrina$onda2)
ad_test3 <- ad.test(dfcreatRastUrina$onda3)
print(ad_test1)
print(ad_test2)
print(ad_test3)
################################################################################
dadoslcreatRastUrina_interpol <- melt(dfcreatRastUrina,
                                       id = "ID",
                                       measured = c("onda1", "onda2", "onda3"))

colnames(dadoslcreatRastUrina_interpol) = c("ID", "Onda", "creatRastUrina")
dadoslcreatRastUrina_interpol <- sort_df(dadoslcreatRastUrina_interpol, vars = "ID")
dadoslcreatRastUrina_interpol$ID <- factor(dadoslcreatRastUrina_interpol$ID)

################################################################################
###Identificando outliers na totalidade
dadoslcreatRastUrina_interpol %>% group_by(Onda) %>% identify_outliers(creatRastUrina) 
###Identificando normalidade na totalidade agrupada pela Onda

# Aplicar o teste de Anderson-Darling por grupo
normalTestAdersonDarlingGroup <- dadoslcreatRastUrina_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ad_test = list(anderson_darling_test(creatRastUrina))) %>%
  unnest(cols = ad_test)
print(normalTestAdersonDarlingGroup)

# Aplicar o teste de Komolgorov-Smirnov por grupo
normalTesteKomolgorovSmirnovGroup <- dadoslcreatRastUrina_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ks_test = list(ks_test(creatRastUrina))) %>%
  unnest(cols = ks_test)
print(normalTesteKomolgorovSmirnovGroup)
################################################################################

#friedman.test(dadoslcreatRastUrina$Hba, dadoslcreatRastUrina$Onda, dadoslcreatRastUrina$ID)
friedman.test(dadoslcreatRastUrina_interpol$creatRastUrina, dadoslcreatRastUrina_interpol$Onda, dadoslcreatRastUrina_interpol$ID)

#Testes de post-hoc

##Wilcoxon com correcao de Bonferroni
dadoslcreatRastUrina_interpol %>% wilcox_test(creatRastUrina ~ Onda, paired = TRUE, p.adjust.method = "bonferroni")
##post-hocs do pacote PMCMRplus: 
### Dunn-Bonferroni
frdAllPairsSiegelTest(dadoslcreatRastUrina_interpol$creatRastUrina, dadoslcreatRastUrina_interpol$Onda, dadoslcreatRastUrina_interpol$ID, p.adjust.method = "bonferroni")

##Outros com ajuste de bonferroni
frdAllPairsNemenyiTest(dadoslcreatRastUrina_interpol$creatRastUrina, dadoslcreatRastUrina_interpol$Onda, dadoslcreatRastUrina_interpol$ID, p.adjust.method = "bonferroni")
frdAllPairsConoverTest(dadoslcreatRastUrina_interpol$creatRastUrina, dadoslcreatRastUrina_interpol$Onda, dadoslcreatRastUrina_interpol$ID, p.adjust.method = "bonferroni")

# Analise descritiva dos dados
dadoslcreatRastUrina_interpol %>% group_by(Onda) %>% 
  get_summary_stats(creatRastUrina, type = "median_iqr")

png("./img/estat_nao_param/creatinina_rastreavel_Urina/creatRastUrina_friendman.png", width = 70, height = 20, units = "cm", res = 300)
par(mfrow=c(1,3))
# Onda 1
hist_data_onda1 <- dadoslcreatRastUrina_interpol$creatRastUrina[dadoslcreatRastUrina_interpol$Onda == "onda1"]
hist(hist_data_onda1,
     ylab = "Frequencia", xlab = "creatinina Rastreavel Urina (mg/dl)", main="Onda 1")
abline(v = median(hist_data_onda1), col = "red")

# Onda 2
hist_data_onda2 <- dadoslcreatRastUrina_interpol$creatRastUrina[dadoslcreatRastUrina_interpol$Onda == "onda2"]
hist(hist_data_onda2,
     ylab = "Frequencia", xlab = "creatinina Rastreavel Urina (mg/dl)", main="Onda 2")
abline(v = median(hist_data_onda2), col = "red")

# Onda 3
hist_data_onda3 <- dadoslcreatRastUrina_interpol$creatRastUrina[dadoslcreatRastUrina_interpol$Onda == "onda3"]
hist(hist_data_onda3,
     ylab = "Frequencia", xlab = "creatinina Rastreavel Urina (mg/dl)", main="Onda 3")
abline(v = median(hist_data_onda3), col = "red")
dev.off()