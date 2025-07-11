if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(mice, VIM)
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

dfTaxaFiltracaoGlomerular <- data.frame(filt_onda1 = categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1,
                                        filt_onda2 = categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2
)
dfTaxaFiltracaoGlomerular <- dfTaxaFiltracaoGlomerular %>%
  dplyr::mutate(
    filt_onda1 = as.factor(filt_onda1),
    filt_onda2 = as.factor(filt_onda2)
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
dadosOnda1Mice <- data.frame(
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
  pas = dfPAS$PAS_onda1,
  pad = dfPAD$PAD_onda1
)

dadosOnda2Mice <- data.frame(
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
  pas = dfPAS$PAS_onda2,
  pad = dfPAD$PAD_onda2
)

dadosOnda3Mice <- data.frame(
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
agg_plot <- VIM::aggr(dadosOnda1Mice, col = c('navyblue', 'red'), 
                      numbers = TRUE, sortvars = TRUE, 
                      labels = names(dadosOnda1Mice), 
                      cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                      ylab = c("Histogram of missing data - onda 1", "Pattern - onda 1"))

agg_plot <- VIM::aggr(dadosOnda2Mice, col = c('navyblue', 'red'), 
                      numbers = TRUE, sortvars = TRUE, 
                      labels = names(dadosOnda2Mice), 
                      cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                      ylab = c("Histogram of missing data - onda 2", "Pattern - onda 2"))

agg_plot <- VIM::aggr(dadosOnda3Mice, col = c('navyblue', 'red'), 
                      numbers = TRUE, sortvars = TRUE, 
                      labels = names(dadosOnda3Mice), 
                      cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                      ylab = c("Histogram of missing data - onda 3", "Pattern - onda 3"))
################################################################################
### onda 1
summary(dadosOnda1Mice)
nacounts_onda1 <- count_missing(dadosOnda1Mice)
hasNA_onda1 <- which(nacounts_onda1>0)
nacounts_onda1[hasNA_onda1]

### onda 2
summary(dadosOnda2Mice)
nacounts_onda2 <- count_missing(dadosOnda2Mice)
hasNA_onda2 <- which(nacounts_onda2>0)
nacounts_onda2[hasNA_onda2]

### onda 3
summary(dadosOnda3Mice)
nacounts_onda3 <- count_missing(dadosOnda3Mice)
hasNA_onda3 <- which(nacounts_onda3>0)
nacounts_onda3[hasNA_onda3]
################################################################################
### Imputando valores para Hipertensao com pmm
### Rodar o algoritmo de imputação múltipla

### Onda 1 
dadosOnda1Mice_tmp_inp <- mice(dadosOnda1Mice, method = "pmm", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dadosOnda1Mice_inp <- complete(dadosOnda1Mice_tmp_inp, 1)

### Onda 2 
dadosOnda2Mice_tmp_inp <- mice(dadosOnda2Mice, method = "pmm", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dadosOnda2Mice_inp <- complete(dadosOnda2Mice_tmp_inp, 1)

### Onda 3 
dadosOnda3Mice_tmp_inp <- mice(dadosOnda3Mice, method = "pmm", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dadosOnda3Mice_inp <- complete(dadosOnda3Mice_tmp_inp, 1)
################################################################################
################ Criando coluna para diabetes mellitus #########################
### Onda 1
dadosOnda1Mice_inp$diabetes <- ifelse(
  dadosOnda1Mice_inp$hba1c >= 6.5, 1, 0
)
### Onda 2
dadosOnda2Mice_inp$diabetes <- ifelse(
  dadosOnda2Mice_inp$hba1c >= 6.5, 1, 0
)
### Onda 3
dadosOnda3Mice_inp$diabetes <- ifelse(
  dadosOnda3Mice_inp$hba1c >= 6.5, 1, 0
)