if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, ggplot2, VIM, nortest, lmtest, car, rstatix, ggpmisc, corrplot, corrplot)
source("./src/script_analise_dados_elsa_Var_Lib.R")
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
idx_potassio_onda1 <- which(is.na(dfPotassio$onda1))
idx_potassio_onda2 <- which(is.na(dfPotassio$onda2))
idx_potassio_onda3 <- which(is.na(dfPotassio$onda3))
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
resid_potassio_PAS_onda1 <- resid(mod_potassio_PAS_onda1, type = "pearson")
plot(resid_potassio_PAS_onda1, pch = 20, main = "Gráfico de Resíduos Padronizados")
abline(h = c(-3, 3), col = "red", lty = 2)
index_outliers <- which(abs(resid_potassio_PAS_onda1)>3)
dfPAS_onda1_no_Outliers <- dfPAS$onda1[-index_outliers]
dfPotassio_onda1_no_Outliers <- dfPotassio$onda1[-index_outliers]
mod_potassio_PAS_onda1_no_Outliers <- lm((dfPAS_onda1_no_Outliers) ~ (dfPotassio_onda1_no_Outliers), na.action=na.omit)
par(mfrow = c(2, 2))
plot(mod_potassio_PAS_onda1_no_Outliers)
#plot(dfPotassio_onda1_no_Outliers, dfPAS_onda1_no_Outliers)

