if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(mice, ROSE, VIM)
library(dplyr)
source("./src/script_analise_dados_elsa_Var_Lib.R")
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
dadosOnda1kNN <- data.frame(
  hip = dfPresencaHipertensaoSistem$hip_onda1,
  pot = dfPotassio$pot_onda1,
  sod = dfSodio$sod_onda1,
  albCreat = dfRazaoAlbuminaCreatinina$albCreat_onda1,
  taxaFilt = dfTaxaFiltracaoGlomerular$filt_onda1,
  pas = dfPAS$PAS_onda1,
  pad = dfPAD$PAD_onda1
)

dadosOnda2kNN <- data.frame(
  hip = dfPresencaHipertensaoSistem$hip_onda2,
  pot = dfPotassio$pot_onda2,
  sod = dfSodio$sod_onda2,
  albCreat = dfRazaoAlbuminaCreatinina$albCreat_onda2,
  taxaFilt = dfTaxaFiltracaoGlomerular$filt_onda2,
  pas = dfPAS$PAS_onda2,
  pad = dfPAD$PAD_onda2
)

dadosOnda3kNN <- data.frame(
  hip = dfPresencaHipertensaoSistem$hip_onda3,
  pot = dfPotassio$pot_onda3,
  sod = dfSodio$sod_onda3,
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
dadosOnda1kNN_inp <- subset(dadosOnda1kNN_inp, select = hip:pad)

### Onda 2
dadosOnda2kNN_inp <- VIM::kNN(dadosOnda2kNN, k = 10)
dadosOnda2kNN_inp <- subset(dadosOnda2kNN_inp, select = hip:pad)

### Onda 3
dadosOnda3kNN_inp <- VIM::kNN(dadosOnda3kNN, k = 10)
dadosOnda3kNN_inp <- subset(dadosOnda3kNN_inp, select = hip:pad)
################################################################################