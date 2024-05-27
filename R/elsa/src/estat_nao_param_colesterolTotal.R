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
dfColesterolTotal <- data.frame(ID = idElsa,
                                onda1 = colesterolTotalOnda1, 
                                onda2 = colesterolTotalOnda2, 
                                onda3 = colesterolTotalOnda3
)

################################################################################
dfColesterolTotal <- kNN(dfColesterolTotal, k = 3)
dfColesterolTotal <- dfColesterolTotal[,-c(5:ncol(dfColesterolTotal))]
###realizando teste de normalidade de Anderson-Darling
ad_test1 <- ad.test(dfColesterolTotal$onda1)
ad_test2 <- ad.test(dfColesterolTotal$onda2)
ad_test3 <- ad.test(dfColesterolTotal$onda3)
print(ad_test1)
print(ad_test2)
print(ad_test3)
################################################################################

dadoslcolesterol_interpol <- melt(dfColesterolTotal,
                                       id = "ID",
                                       measured = c("onda1", "onda2", "onda3"))

colnames(dadoslcolesterol_interpol) = c("ID", "Onda", "colesterolTotal")
dadoslcolesterol_interpol <- sort_df(dadoslcolesterol_interpol, vars = "ID")
dadoslcolesterol_interpol$ID <- factor(dadoslcolesterol_interpol$ID)

################################################################################
###Identificando outliers na totalidade
dadoslcolesterol_interpol %>% group_by(Onda) %>% identify_outliers(colesterolTotal) 
###Identificando normalidade na totalidade agrupada pela Onda

# Aplicar o teste de Anderson-Darling por grupo
normalTestAdersonDarlingGroup <- dadoslcolesterol_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ad_test = list(anderson_darling_test(colesterolTotal))) %>%
  unnest(cols = ad_test)
print(normalTestAdersonDarlingGroup)

# Aplicar o teste de Komolgorov-Smirnov por grupo
normalTesteKomolgorovSmirnovGroup <- dadoslcolesterol_interpol %>%
  group_by(Onda) %>%
  filter(n() >= 3) %>%
  summarize(ks_test = list(ks_test(colesterolTotal))) %>%
  unnest(cols = ks_test)
print(normalTesteKomolgorovSmirnovGroup)
################################################################################

#friedman.test(dadoslcreatRastSangue$Hba, dadoslcreatRastSangue$Onda, dadoslcreatRastSangue$ID)
friedman.test(dadoslcolesterol_interpol$colesterolTotal, dadoslcolesterol_interpol$Onda, dadoslcolesterol_interpol$ID)

#Testes de post-hoc

##Wilcoxon com correcao de Bonferroni
dadoslcolesterol_interpol %>% wilcox_test(colesterolTotal ~ Onda, paired = TRUE, p.adjust.method = "bonferroni")
##post-hocs do pacote PMCMRplus: 
### Dunn-Bonferroni
frdAllPairsSiegelTest(dadoslcolesterol_interpol$colesterolTotal, dadoslcolesterol_interpol$Onda, dadoslcolesterol_interpol$ID, p.adjust.method = "bonferroni")

##Outros com ajuste de bonferroni
frdAllPairsNemenyiTest(dadoslcolesterol_interpol$colesterolTotal, dadoslcolesterol_interpol$Onda, dadoslcolesterol_interpol$ID, p.adjust.method = "bonferroni")
frdAllPairsConoverTest(dadoslcolesterol_interpol$colesterolTotal, dadoslcolesterol_interpol$Onda, dadoslcolesterol_interpol$ID, p.adjust.method = "bonferroni")

# Analise descritiva dos dados
dadoslcolesterol_interpol %>% group_by(Onda) %>% 
  get_summary_stats(colesterolTotal, type = "median_iqr")

png("./img/estat_nao_param/colesterol/colesterolTotal_friendman.png", width = 70, height = 20, units = "cm", res = 300)
par(mfrow=c(1,3))
# Onda 1
hist_data_onda1 <- dadoslcolesterol_interpol$colesterolTotal[dadoslcolesterol_interpol$Onda == "onda1"]
hist(hist_data_onda1,
     ylab = "Frequencia", xlab = "Colesterol (mg/dl)", main="Onda 1")
abline(v = median(hist_data_onda1), col = "red")

# Onda 2
hist_data_onda2 <- dadoslcolesterol_interpol$colesterolTotal[dadoslcolesterol_interpol$Onda == "onda2"]
hist(hist_data_onda2,
     ylab = "Frequencia", xlab = "Colesterol (mg/dl)", main="Onda 2")
abline(v = median(hist_data_onda2), col = "red")

# Onda 3
hist_data_onda3 <- dadoslcolesterol_interpol$colesterolTotal[dadoslcolesterol_interpol$Onda == "onda3"]
hist(hist_data_onda3,
     ylab = "Frequencia", xlab = "Colesterol (mg/dl)", main="Onda 3")
abline(v = median(hist_data_onda3), col = "red")
dev.off()