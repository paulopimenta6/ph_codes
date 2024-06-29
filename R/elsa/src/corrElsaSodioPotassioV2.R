if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, ggplot2, VIM, nortest, lmtest, car, rstatix, ggpmisc, corrplot, corrplot)
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dataPreprocessing.R")
################################################################################
################################################################################
###Variaveis de referencia e tambem variaveis independentes (VI)
dfPotassio <- data.frame(onda1 = potassioOnda1,
                         onda2 = potassioOnda2,
                         onda3 = potassioOnda3
)

dfSodio <- data.frame(onda1 = sodioUrinaOnda1,
                      onda2 = sodioUrinaOnda2,
                      onda3 = sodioUrinaOnda3
)
################################################################################
##Variaveis a serem analisadas ou variaveis dependentes
dfRazaoAlbuminaCreatinina <- data.frame(onda1 = razaoAlbuminaCreatininaRastreavelOnda1,
                                        onda2 = razaoAlbuminaCreatininaRastreavelOnda2
)
dfTaxaFiltracaoGlomerular <- data.frame(onda1 = categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1,
                                        onda2 = categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2
)
dfPAS <- data.frame(onda1 = pressaoArterialSistolicaMediaOnda1,
                    onda2 = pressaoArterialSistolicaMediaOnda2,
                    onda3 = pressaoArterialSistolicaMediaOnda3
)

dfPAD <- data.frame(onda1 = pressaoDiastolicamediaOnda1,
                    onda2 = pressaoDiastolicamediaOnda2,
                    onda3 = pressaoDiastolicamediaOnda3
)

dfPresencaHipertensaoSistem <- data.frame(onda1 = presencaDeHipertensaoArterialSistemicaOnda1,
                                          onda2 = presencaDeHipertensaoArterialSistemicaOnda2,
                                          onda3 = presencaDeHipertensaoArterialSistemicaOnda3
)
################################################################################
###Identificando Outliers
### Potassio
outliers_dfPotassio_onda1 <- identify_outliers_vector(dfPotassio$onda1)
outliers_dfPotassio_onda2 <- identify_outliers_vector(dfPotassio$onda2)
outliers_dfPotassio_onda3 <- identify_outliers_vector(dfPotassio$onda3)
### Sodio
outliers_dfSodio_onda1 <- identify_outliers_vector(dfSodio$onda1)
outliers_dfSodio_onda2 <- identify_outliers_vector(dfSodio$onda2)
outliers_dfSodio_onda3 <- identify_outliers_vector(dfSodio$onda3)
### Razao Albumina-Creatinina 
outliers_dfRazaoAlbuminaCreatinina_onda1 <- identify_outliers_vector(dfRazaoAlbuminaCreatinina$onda1)
outliers_dfRazaoAlbuminaCreatinina_onda2 <- identify_outliers_vector(dfRazaoAlbuminaCreatinina$onda2)
### Taxa Filtracao Glomerular
outliers_dfTaxaFiltracaoGlomerular_onda1 <- identify_outliers_vector(dfTaxaFiltracaoGlomerular$onda1)
outliers_dfTaxaFiltracaoGlomerular_onda2 <- identify_outliers_vector(dfTaxaFiltracaoGlomerular$onda2)
### PAD
outliers_dfPAD_onda1 <- identify_outliers_vector(dfPAD$onda1)
outliers_dfPAD_onda2 <- identify_outliers_vector(dfPAD$onda2)
outliers_dfPAD_onda3 <- identify_outliers_vector(dfPAD$onda3)
### PAS
outliers_dfPAS_onda1 <- identify_outliers_vector(dfPAS$onda1)
outliers_dfPAS_onda2 <- identify_outliers_vector(dfPAS$onda2)
outliers_dfPAS_onda3 <- identify_outliers_vector(dfPAS$onda3)
################################################################################
### indices dos outliers do Potassio
idx_out_dfPotassio_onda1 <- which(outliers_dfPotassio_onda1)
idx_out_dfPotassio_onda2 <- which(outliers_dfPotassio_onda2)
idx_out_dfPotassio_onda3 <- which(outliers_dfPotassio_onda3)
### indices dos outliers do Sodio
idx_out_dfSodio_onda1 <- which(outliers_dfSodio_onda1)
idx_out_dfSodio_onda2 <- which(outliers_dfSodio_onda2)
idx_out_dfSodio_onda3 <- which(outliers_dfSodio_onda3)
### indices dos outliers da razao albumina-creatinina
idx_out_dfRazaoAlbuminaCreatinina_onda1 <- which(outliers_dfRazaoAlbuminaCreatinina_onda1)
idx_out_dfRazaoAlbuminaCreatinina_onda2 <- which(outliers_dfRazaoAlbuminaCreatinina_onda2)
### indices dos Outliers da Taxa de filtracao glomerular
idx_out_dfTaxaFiltracaoGlomerular_onda1 <- which(outliers_dfTaxaFiltracaoGlomerular_onda1)
idx_out_dfTaxaFiltracaoGlomerular_onda2 <- which(outliers_dfTaxaFiltracaoGlomerular_onda2)
### indices dos Outliers do PAD
idx_out_dfPAD_onda1 <- which(outliers_dfPAD_onda1)
idx_out_dfPAD_onda2 <- which(outliers_dfPAD_onda2)
idx_out_dfPAD_onda3 <- which(outliers_dfPAD_onda3)
### indices dos Outliers do PAS
idx_out_dfPAS_onda1 <- which(outliers_dfPAS_onda1)
idx_out_dfPAS_onda2 <- which(outliers_dfPAS_onda2)
idx_out_dfPAS_onda3 <- which(outliers_dfPAS_onda3)
### Removendo Outliers
################################################################################
potassio_onda1_no_outliers <- dfPotassio$onda1[-c(idx_out_dfPotassio_onda1, idx_out_dfPAD_onda1)]
PAD_onda1_no_outliers <- dfPAD$onda1[-c(idx_out_dfPotassio_onda1, idx_out_dfPAD_onda1)]
################################################################################
correlacao <- cor.test(potassio_onda1_no_outliers, PAD_onda1_no_outliers, use = "complete.obs", method = "pearson")
################################################################################
### Potassio
mod_potassio_PAS_onda1 <- lm(dfPAS$onda1 ~ dfPotassio$onda1, na.action = na.omit)
mod_potassio_PAS_onda2 <- lm(dfPAS$onda2 ~ dfPotassio$onda2, na.action = na.omit)
mod_potassio_PAS_onda3 <- lm(dfPAS$onda3 ~ dfPotassio$onda3, na.action = na.omit)
mod_potassio_AlbuCreat_onda1 <- lm(dfRazaoAlbuminaCreatinina$onda1 ~ dfPotassio$onda1, na.action = na.omit)
mod_potassio_AlbuCreat_onda2 <- lm(dfRazaoAlbuminaCreatinina$onda2 ~ dfPotassio$onda2, na.action = na.omit)
### Sodio
mod_sodio_PAS_onda1 <- lm(dfPAS$onda1 ~ dfSodio$onda1, na.action = na.omit)
mod_sodio_PAS_onda2 <- lm(dfPAS$onda2 ~ dfSodio$onda2, na.action = na.omit)
mod_sodio_PAS_onda3 <- lm(dfPAS$onda3 ~ dfSodio$onda3, na.action = na.omit)
mod_sodio_AlbuCreat_onda1 <- lm(dfRazaoAlbuminaCreatinina$onda1 ~ dfSodio$onda1, na.action = na.omit)
mod_sodio_AlbuCreat_onda2 <- lm(dfRazaoAlbuminaCreatinina$onda2 ~ dfSodio$onda2, na.action = na.omit)
################################################################################
################################################################################