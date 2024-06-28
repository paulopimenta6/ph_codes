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
### Potassio
mod_potassio_PAS_onda1 <- lm(dfPAS$onda1 ~ dfPotassio$onda1, na.action = na.omit)
mod_potassio_PAS_onda2 <- lm(dfPAS$onda2 ~ dfPotassio$onda2, na.action = na.omit)
mod_potassio_PAS_onda3 <- lm(dfPAS$onda3 ~ dfPotassio$onda3, na.action = na.omit)
### Sodio
mod_sodio_PAS_onda1 <- lm(dfPAS$onda1 ~ dfSodio$onda1, na.action = na.omit)
mod_sodio_PAS_onda2 <- lm(dfPAS$onda2 ~ dfSodio$onda2, na.action = na.omit)
mod_sodio_PAS_onda3 <- lm(dfPAS$onda3 ~ dfSodio$onda3, na.action = na.omit)
################################################################################
par(mfrow=c(2,2))
plot(mod_potassio_PAS_onda1)
plot(mod_potassio_PAS_onda2)
plot(mod_potassio_PAS_onda3)

plot(mod_sodio_PAS_onda1)
plot(mod_sodio_PAS_onda2)
plot(mod_sodio_PAS_onda3)

shapiro.test(mod_potassio_PAS_onda1$residuals)
shapiro.test(mod_potassio_PAS_onda2$residuals)
shapiro.test(mod_potassio_PAS_onda3$residuals)

shapiro.test(mod_sodio_PAS_onda1$residuals)
shapiro.test(mod_sodio_PAS_onda2$residuals)
shapiro.test(mod_sodio_PAS_onda3$residuals)

summary(rstandard(mod_potassio_PAS_onda1))
summary(rstandard(mod_potassio_PAS_onda2))
summary(rstandard(mod_potassio_PAS_onda3))
