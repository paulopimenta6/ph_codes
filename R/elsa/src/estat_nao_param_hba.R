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

dfHba <- data.frame(ID = idElsa,
                   onda1 = hemoglobinaGlicadaHba1cOnda1, 
                   onda2 = hemoglobinaGlicadaHba2cOnda2, 
                   onda3 = hemoglobinaGlicadaHba3cOnda3
                  )

################################################################################
dfHba <- kNN(dfHba, k = 3)
dfHba <- dfHba[,-c(5:ncol(dfHba))]
###realizando teste de normalidade de Anderson-Darling
ad_test1 <- ad.test(dfHba$onda1)
ad_test2 <- ad.test(dfHba$onda2)
ad_test3 <- ad.test(dfHba$onda3)
print(ad_test1)
print(ad_test2)
print(ad_test3)
################################################################################

dadoslHba_interpol <- melt(dfHba,
               id = "ID",
               measured = c("onda1", "onda2", "onda3"))

colnames(dadoslHba_interpol) = c("ID", "Onda", "Hba")
dadoslHba_interpol <- sort_df(dadoslHba_interpol, vars = "ID")
dadoslHba_interpol$ID <- factor(dadoslHba_interpol$ID)

################################################################################
###Identificando outliers na totalidade
dadoslHba_interpol %>% group_by(Onda) %>% identify_outliers(PAD) 
###Identificando normalidade na totalidade agrupada pela Onda

# Aplicar o teste de Anderson-Darling por grupo
normalTestAdersonDarlingGroup <- dadoslHba_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ad_test = list(anderson_darling_test(Hba))) %>%
  unnest(cols = ad_test)
print(normalTestAdersonDarlingGroup)

# Aplicar o teste de Komolgorov-Smirnov por grupo
normalTesteKomolgorovSmirnovGroup <- dadoslHba_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ks_test = list(ks_test(Hba))) %>%
  unnest(cols = ks_test)
print(normalTesteKomolgorovSmirnovGroup)
################################################################################

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