############################################################################################
##############################Especificando diretorio src###################################
############################################################################################
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/classNormalMethods.R")

if (!require(tidyr)) install.packages("tidyr")
library(tidyr)
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

###Usando knn para interpolar os valores por cada onda
###considernado que são valores de mesma magnitude nao e necessario normalizar 

dfPAD <- data.frame(ID = idElsa,
                    onda1 = pressaoDiastolicamediaOnda1, 
                    onda2 = pressaoDiastolicamediaOnda2, 
                    onda3 = pressaoDiastolicamediaOnda3
)

################################################################################
dfPAD <- kNN(dfPAD, k = 3)
dfPAD <- dfPAD[,-c(5:ncol(dfPAD))]
###realizando teste de normalidade de Anderson-Darling
ad_test1 <- ad.test(dfPAD$onda1)
ad_test2 <- ad.test(dfPAD$onda2)
ad_test3 <- ad.test(dfPAD$onda3)
print(ad_test1)
print(ad_test2)
print(ad_test3)
################################################################################

dadoslPAD_interpol <- reshape2::melt(dfPAD,
                  id = "ID",
                  measured = c("onda1", "onda2", "onda3"))

colnames(dadoslPAD_interpol) = c("ID", "Onda", "PAD")
dadoslPAD_interpol <- sort_df(dadoslPAD_interpol, vars = "ID")
dadoslPAD_interpol$ID <- factor(dadoslPAD_interpol$ID)

################################################################################
###Identificando outliers na totalidade
dadoslPAD_interpol %>% group_by(Onda) %>% identify_outliers(PAD) 
###Identificando normalidade na totalidade agrupada pela Onda

# Aplicar o teste de Anderson-Darling por grupo
normalTestAdersonDarlingGroup <- dadoslPAD_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ad_test = list(anderson_darling_test(PAD))) %>%
  unnest(cols = ad_test)
print(normalTestAdersonDarlingGroup)

# Aplicar o teste de Komolgorov-Smirnov por grupo
normalTesteKomolgorovSmirnovGroup <- dadoslPAD_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ks_test = list(ks_test(PAD))) %>%
  unnest(cols = ks_test)
print(normalTesteKomolgorovSmirnovGroup)
################################################################################

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