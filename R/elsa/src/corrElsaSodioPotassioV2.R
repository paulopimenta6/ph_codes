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
### Potassio
shapiro.test(na.omit(dfPotassio$onda1))
shapiro.test(na.omit(dfPotassio$onda2))
shapiro.test(na.omit(dfPotassio$onda3))
### Sodio
shapiro.test(na.omit(dfSodio$onda1))
shapiro.test(na.omit(dfSodio$onda2))
shapiro.test(na.omit(dfSodio$onda3))
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
mod_potassio_PAS_onda1 <- lm(dfPAS$onda1 ~ dfPotassio$onda1, na.action = na.omit)
shapiro.test(mod_potassio_PAS_onda1$residuals)