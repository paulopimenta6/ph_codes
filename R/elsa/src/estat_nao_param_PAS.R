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

dfPAS <- data.frame(ID = idElsa,
                    onda1 = pressaoArterialSistolicaMediaOnda1, 
                    onda2 = pressaoArterialSistolicaMediaOnda2, 
                    onda3 = pressaoArterialSistolicaMediaOnda3
)

################################################################################
dfPAS <- kNN(dfPAS, k = 3)
dfPAS <- dfPAS[,-c(5:ncol(dfPAS))]
###realizando teste de normalidade de Anderson-Darling
ad_test1 <- ad.test(dfPAS$onda1)
ad_test2 <- ad.test(dfPAS$onda2)
ad_test3 <- ad.test(dfPAS$onda3)
print(ad_test1)
print(ad_test2)
print(ad_test3)

################################################################################
dadoslPAS_interpol <- reshape2::melt(dfPAS,
                  id = "ID",
                  measured = c("onda1", "onda2", "onda3"))

colnames(dadoslPAS_interpol) = c("ID", "Onda", "PAS")
dadoslPAS_interpol <- sort_df(dadoslPAS_interpol, vars = "ID")
dadoslPAS_interpol$ID <- factor(dadoslPAS_interpol$ID)

################################################################################
###Identificando outliers na totalidade
dadoslPAS_interpol %>% group_by(Onda) %>% identify_outliers(PAS) 
###Identificando normalidade na totalidade agrupada pela Onda

# Aplicar o teste de Anderson-Darling por grupo
normalTestAdersonDarlingGroup <- dadoslPAS_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ad_test = list(anderson_darling_test(PAS))) %>%
  unnest(cols = ad_test)
print(normalTestAdersonDarlingGroup)

# Aplicar o teste de Komolgorov-Smirnov por grupo
normalTesteKomolgorovSmirnovGroup <- dadoslPAS_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ks_test = list(ks_test(PAS))) %>%
  unnest(cols = ks_test)
print(normalTesteKomolgorovSmirnovGroup)
################################################################################

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