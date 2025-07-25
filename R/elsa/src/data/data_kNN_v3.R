if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(mice, ROSE, VIM)
library(dplyr)
source("./src/data/script_analise_dados_elsa_Var_Lib.R")
################################################################################
count_missing <- function(df){
  sapply(df, function(col) sum(is.na(col)))
}

dfPresencaHipertensaoSistem <- data.frame(hip_onda1 = presencaDeHipertensaoArterialSistemicaOnda1,
                                          hip_onda2 = presencaDeHipertensaoArterialSistemicaOnda2,
                                          hip_onda3 = presencaDeHipertensaoArterialSistemicaOnda3
)

dfPresencaHipertensaoSistem <- dfPresencaHipertensaoSistem %>%
  dplyr::mutate(
    hip_onda1 = as.factor(hip_onda1),
    hip_onda2 = as.factor(hip_onda2),
    hip_onda3 = as.factor(hip_onda3),
)

dfPotassio <- data.frame(pot_onda1 = potassioOnda1,
                         pot_onda2 = potassioOnda2,
                         pot_onda3 = potassioOnda3
)

dfSodio <- data.frame(sod_onda1 = sodioUrinaOnda1,
                      sod_onda2 = sodioUrinaOnda2,
                      sod_onda3 = sodioUrinaOnda3
)

############################ Indicador de diabetes #############################
dfHemoglobinaGlicada <- data.frame(hbac_onda1 = hemoglobinaGlicadaHba1cOnda1,
                                   hbac_onda2 = hemoglobinaGlicadaHba2cOnda2,
                                   hbac_onda3 = hemoglobinaGlicadaHba3cOnda3
)

dfFazUsoContinuoInsulina <- data.frame(insulina_onda1 = fazUsoContinuoInsulinaONda1,
                                       insulina_onda2 = fazUsoContinuoInsulinaONda2,
                                       insulina_onda3 = fazUsoContinuoInsulinaONda3
)

dfFazUsoContinuoInsulina <- dfFazUsoContinuoInsulina %>%
  dplyr::mutate(
    insulina_onda1 = as.factor(insulina_onda1),
    insulina_onda2 = as.factor(insulina_onda2),
    insulina_onda3 = as.factor(insulina_onda3),
)

dfFazUsoAntidiabeticosOrais <- data.frame(antidiabeticos_onda1 = tomaAntidiabeticosOraisOnda1,
                                          antidiabeticos_onda2 = tomaAntidiabeticosOraisOnda2,
                                          antidiabeticos_onda3 = tomaAntidiabeticosOraisOnda3
)

dfFazUsoAntidiabeticosOrais <- dfFazUsoAntidiabeticosOrais %>%
  dplyr::mutate(
    antidiabeticos_onda1 = as.factor(antidiabeticos_onda1),
    antidiabeticos_onda2 = as.factor(antidiabeticos_onda2),
    antidiabeticos_onda3 = as.factor(antidiabeticos_onda3),
)
################################################################################

dfRazaoAlbuminaCreatinina <- data.frame(albCreat_onda1 = razaoAlbuminaCreatininaRastreavelOnda1,
                                        albCreat_onda2 = razaoAlbuminaCreatininaRastreavelOnda2
)

dfTaxaFiltracaoGlomerular <- data.frame(filt_onda1 = categoriasTaxaFiltracaoGlomerularAjustadaOnda1,
                                        filt_onda2 = categoriasTaxaFiltracaoGlomerularAjustadaOnda2
)
dfTaxaFiltracaoGlomerular <- dfTaxaFiltracaoGlomerular %>%
  dplyr::mutate(
    filt_onda1 = as.factor(filt_onda1),
    filt_onda2 = as.factor(filt_onda2)
)

dfTaxaFiltracaoGlomerularCal <- data.frame(filt_cal_onda1 = taxaFiltracaoGlomerularComCalibracaoOnda1,
                                           filt_cal_onda2 = taxaFiltracaoGlomerularComCalibracaoOnda2
)

dfPAS <- data.frame(PAS_onda1 = pressaoArterialSistolicaMediaOnda1,
                    PAS_onda2 = pressaoArterialSistolicaMediaOnda2,
                    PAS_onda3 = pressaoArterialSistolicaMediaOnda3
)

dfPAD <- data.frame(PAD_onda1 = pressaoDiastolicamediaOnda1,
                    PAD_onda2 = pressaoDiastolicamediaOnda2,
                    PAD_onda3 = pressaoDiastolicamediaOnda3
)
################################################################################
### Criando os novos data frames que serao imputados
dadosOnda1kNN <- data.frame(
  idElsa = idElsa,
  sexo = sexo,
  hip = dfPresencaHipertensaoSistem$hip_onda1,
  pot = dfPotassio$pot_onda1,
  sod = dfSodio$sod_onda1,
  ###Inclusao de indicadores de diabetes
  hba1c = dfHemoglobinaGlicada$hbac_onda1,
  insulina = dfFazUsoContinuoInsulina$insulina_onda1,
  antidiabeticosOrais = dfFazUsoAntidiabeticosOrais$antidiabeticos_onda1,
  ###Fim dos indicadores de diabetes
  albCreat = dfRazaoAlbuminaCreatinina$albCreat_onda1,
  taxaFilt = dfTaxaFiltracaoGlomerular$filt_onda1,
  taxaFiltCal = dfTaxaFiltracaoGlomerularCal$filt_cal_onda1,
  pas = dfPAS$PAS_onda1,
  pad = dfPAD$PAD_onda1
)

dadosOnda2kNN <- data.frame(
  idElsa = idElsa,
  sexo = sexo,
  hip = dfPresencaHipertensaoSistem$hip_onda2,
  pot = dfPotassio$pot_onda2,
  sod = dfSodio$sod_onda2,
  ###Inclusao de indicadores de diabetes
  hba1c = dfHemoglobinaGlicada$hbac_onda2,
  insulina = dfFazUsoContinuoInsulina$insulina_onda2,
  antidiabeticosOrais = dfFazUsoAntidiabeticosOrais$antidiabeticos_onda2,
  ###Fim dos indicadores de diabetes
  albCreat = dfRazaoAlbuminaCreatinina$albCreat_onda2,
  taxaFilt = dfTaxaFiltracaoGlomerular$filt_onda2,
  taxaFiltCal = dfTaxaFiltracaoGlomerularCal$filt_cal_onda2,
  pas = dfPAS$PAS_onda2,
  pad = dfPAD$PAD_onda2
)

dadosOnda3kNN <- data.frame(
  idElsa = idElsa,
  sexo = sexo,
  hip = dfPresencaHipertensaoSistem$hip_onda3,
  pot = dfPotassio$pot_onda3,
  sod = dfSodio$sod_onda3,
  ###Inclusao de indicadores de diabetes
  hba1c = dfHemoglobinaGlicada$hbac_onda3,
  insulina = dfFazUsoContinuoInsulina$insulina_onda3,
  antidiabeticosOrais = dfFazUsoAntidiabeticosOrais$antidiabeticos_onda3,
  ###Fim dos indicadores de diabetes
  pas = dfPAS$PAS_onda3,
  pad = dfPAD$PAD_onda3
)
################################################################################
#agg_plot <- aggr(dadosOnda1kNN, col = c('navyblue', 'red'), 
#                 numbers = TRUE, sortvars = TRUE, 
#                 labels = names(dadosOnda1kNN), 
#                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
#                 ylab = c("Histogram of missing data - onda 1", "Pattern - onda 1"))

#agg_plot <- aggr(dadosOnda2kNN, col = c('navyblue', 'red'), 
#                 numbers = TRUE, sortvars = TRUE, 
#                 labels = names(dadosOnda2kNN), 
#                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
#                 ylab = c("Histogram of missing data - onda 2", "Pattern - onda 2"))

#agg_plot <- aggr(dadosOnda3kNN, col = c('navyblue', 'red'), 
#                 numbers = TRUE, sortvars = TRUE, 
#                 labels = names(dadosOnda3kNN), 
#                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
#                 ylab = c("Histogram of missing data - onda 3", "Pattern - onda 3"))
################################################################################
### onda 1
summary(dadosOnda1kNN)
nacounts_onda1 <- count_missing(dadosOnda1kNN)
hasNA_onda1 <- which(nacounts_onda1>0)
nacounts_onda1[hasNA_onda1]

### onda 2
summary(dadosOnda2kNN)
nacounts_onda2 <- count_missing(dadosOnda2kNN)
hasNA_onda2 <- which(nacounts_onda2>0)
nacounts_onda2[hasNA_onda2]

### onda 3
summary(dadosOnda3kNN)
nacounts_onda3 <- count_missing(dadosOnda3kNN)
hasNA_onda3 <- which(nacounts_onda3>0)
nacounts_onda3[hasNA_onda3]
################################################################################
### Imputando valores para Hipertensao com kNN
### Rodar o algoritmo de imputação múltipla

### Onda 1
dadosOnda1kNN_inp <- VIM::kNN(dadosOnda1kNN, k = 10)
dadosOnda1kNN_inp <- subset(dadosOnda1kNN_inp, select = idElsa:pad)

### Onda 2
dadosOnda2kNN_inp <- VIM::kNN(dadosOnda2kNN, k = 10)
dadosOnda2kNN_inp <- subset(dadosOnda2kNN_inp, select = idElsa:pad)

### Onda 3
dadosOnda3kNN_inp <- VIM::kNN(dadosOnda3kNN, k = 10)
dadosOnda3kNN_inp <- subset(dadosOnda3kNN_inp, select = idElsa:pad)
################################################################################
################ Criando coluna para diabetes mellitus #########################
### Onda 1
dadosOnda1kNN_inp$diabetes <- ifelse(
  dadosOnda1kNN_inp$hba1c >= 6.5, 1, 0
)
### Onda 2
dadosOnda2kNN_inp$diabetes <- ifelse(
  dadosOnda2kNN_inp$hba1c >= 6.5, 1, 0
)
### Onda 3
dadosOnda3kNN_inp$diabetes <- ifelse(
  dadosOnda3kNN_inp$hba1c >= 6.5, 1, 0
)
################################################################################