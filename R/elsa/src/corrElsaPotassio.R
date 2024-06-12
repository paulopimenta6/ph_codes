if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, ggplot2, VIM, nortest, car, rstatix, ggpmisc) 
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
###Interpolacao pelo metodo do KNN das variaveis que eventualmente estao faltantes
###Variaveis Independentes
pot_interp <- kNN(dfPotassio, k=5)
pot_interp <- pot_interp[,-c(4:ncol(pot_interp))]

sodio_interp <- kNN(dfSodio, k=5)
sodio_interp <- sodio_interp[,-c(4:ncol(sodio_interp))]
################################################################################
###Variaveis Dependentes
razaoAlbuCreat_interp <- kNN(dfRazaoAlbuminaCreatinina, k = 5) 
razaoAlbuCreat_interp <- razaoAlbuCreat_interp[, -c(3:ncol(razaoAlbuCreat_interp))]

PAS_interp <- kNN(dfPAS, k = 5)
PAS_interp <- PAS_interp[, -c(4,ncol(PAS_interp))]

PAD_interp <- kNN(dfPAD, k = 5)
PAD_interp <- PAD_interp[,-c(4:ncol(PAD_interp))]

#Variavel_ordinal
taxaFiltracaoGlomerular_interp <- kNN(dfTaxaFiltracaoGlomerular, k = 5) 
taxaFiltracaoGlomerular_interp <- taxaFiltracaoGlomerular_interp[, -c(3:ncol(taxaFiltracaoGlomerular_interp))]

#variavel_binaria
presencaHipertensaoSistem_interp <- kNN(dfPresencaHipertensaoSistem, k = 5)
presencaHipertensaoSistem_interp <- presencaHipertensaoSistem_interp[,-c(4,ncol(presencaHipertensaoSistem_interp))]
###Exemplo de rotulacao de fatores
###presencaHipertensaoSistem_interp$onda1 <- factor(presencaHipertensaoSistem_interp$onda1, levels = c(0,1), labels= c("Nao", "Sim"))
################################################################################
###VD: y -> razaoAlbuCreat_interp
###VI: x -> pot_interp
###Potassio
plot(pot_interp$onda1, razaoAlbuCreat_interp$onda1, main = "Onda 1", xlab = "Concentracao de Potassio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")
plot(pot_interp$onda2, razaoAlbuCreat_interp$onda2, main = "Onda 2", xlab = "Concentracao de Potassio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")

plot(pot_interp$onda1, PAS_interp$onda1, main = "Onda 1", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
plot(pot_interp$onda2, PAS_interp$onda2, main = "Onda 2", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
plot(pot_interp$onda3, PAS_interp$onda3, main = "Onda 3", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")

plot(pot_interp$onda1, PAD_interp$onda1, main = "Onda 1", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
plot(pot_interp$onda2, PAD_interp$onda2, main = "Onda 2", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
plot(pot_interp$onda3, PAD_interp$onda3, main = "Onda 3", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")

###Sodio
plot(sodio_interp$onda1, razaoAlbuCreat_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")
plot(sodio_interp$onda2, razaoAlbuCreat_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")

plot(sodio_interp$onda1, PAS_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
plot(sodio_interp$onda2, PAS_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
plot(sodio_interp$onda3, PAS_interp$onda3, main = "Onda 3", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")

plot(sodio_interp$onda1, PAD_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
plot(sodio_interp$onda2, PAD_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
plot(sodio_interp$onda3, PAD_interp$onda3, main = "Onda 3", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
################################################################################
###Analises para verificar normalidade via modelo linear e analise grafica
###Potassio
mod_PotRazaoAlbumCreat1 <- lm(razaoAlbuCreat_interp$onda1 ~ pot_interp$onda1) 
mod_PotRazaoAlbumCreat2 <- lm(razaoAlbuCreat_interp$onda2 ~ pot_interp$onda2)

mod_PotPAS1 <- lm(PAS_interp$onda1 ~ pot_interp$onda1) 
mod_PotPAS2 <- lm(PAS_interp$onda2 ~ pot_interp$onda2)
mod_PotPAS3 <- lm(PAS_interp$onda3 ~ pot_interp$onda3)

mod_PotPAD1 <- lm(PAD_interp$onda1 ~ pot_interp$onda1) 
mod_PotPAD2 <- lm(PAD_interp$onda2 ~ pot_interp$onda2)
mod_PotPAD3 <- lm(PAD_interp$onda3 ~ pot_interp$onda3)
###Sodio
mod_SodRazaoAlbumCreat1 <- lm(razaoAlbuCreat_interp$onda1 ~ sodio_interp$onda1) 
mod_SodRazaoAlbumCreat2 <- lm(razaoAlbuCreat_interp$onda2 ~ sodio_interp$onda2)

mod_SodPAS1 <- lm(PAS_interp$onda1 ~ sodio_interp$onda1) 
mod_SodPAS2 <- lm(PAS_interp$onda2 ~ sodio_interp$onda2)
mod_SodPAS3 <- lm(PAS_interp$onda3 ~ sodio_interp$onda3)

mod_SodPAD1 <- lm(PAD_interp$onda1 ~ sodio_interp$onda1) 
mod_SodPAD2 <- lm(PAD_interp$onda2 ~ sodio_interp$onda2)
mod_SodPAD3 <- lm(PAD_interp$onda3 ~ sodio_interp$onda3)
################################################################################
###Potassio
par(mfrow = c(2,2))
plot(mod_PotRazaoAlbumCreat1, main = "Onda 1 - Potassio x Razao albumina-creatinina")
plot(mod_PotRazaoAlbumCreat2, main = "Onda 2 - Potassio x Razao albumina-creatinina")

plot(mod_PotPAS1, main = "Onda 1 - Potassio X PAS")
plot(mod_PotPAS2, main = "Onda 2 - Potassio X PAS")
plot(mod_PotPAS3, main = "Onda 3 - Potassio X PAS")

plot(mod_PotPAD1, main = "Onda 1 - Potassio X PAD")
plot(mod_PotPAD2, main = "Onda 2 - Potassio X PAD")
plot(mod_PotPAD3, main = "Onda 3 - Potassio X PAD")
###Sodio
plot(mod_SodRazaoAlbumCreat1, main = "Onda 1 - Sodio x Razao albumina-creatinina")
plot(mod_SodRazaoAlbumCreat2, main = "Onda 2 - Sodio x Razao albumina-creatinina")

plot(mod_SodPAS1, main = "Onda 1 - Sodio X PAS")
plot(mod_SodPAS2, main = "Onda 2 - Sodio X PAS")
plot(mod_SodPAS3, main = "Onda 3 - Sodio X PAS")

plot(mod_SodPAD1, main = "Onda 1 - Sodio X PAD")
plot(mod_SodPAD2, main = "Onda 2 - Sodio X PAD")
plot(mod_SodPAD3, main = "Onda 3 - Sodio X PAD")
################################################################################
###Realizando os testes teoricos
par(mfrow=c(1,1))
## Normalidade dos residuos:
ad.test(mod_SodPAD3$residuals) #A = 8.1019, p-value < 2.2e-16
                               #p =< 0.05 entao residuo nao e normal    
## Outliers nos residuos:
summary(rstandard(mod_SodPAD3)) #Outliers e pontos de alavancagem
                                # summary(rstandard(mod_SodPAD3))
                                #Min.        1st Qu.    Median      Mean   3rd Qu.      Max. 
                                #-2.650854 -0.701977 -0.070930 -0.000004  0.627776  5.362959
                                #Residuos "max" acima do valor 3, ou seja, nao esta entre -3 a 3
                                #Com valor max acima de 3, ou seja, presenca de outlier e ponto de alavancagem
                                

## Independencia dos residuos (Durbin-Watson):
durbinWatsonTest(mod_SodPAD3)   #lag Autocorrelation D-W Statistic p-value
                                #1      0.01433648      1.971243   0.332
                                #Alternative hypothesis: rho != 0
                                #D-W deve ser entre 1 a 3, logo o valor esta ok 
                                #H0: p > 0.05: autocorrelacao = 0: independencia dos residuos
                                #H: p =< 0.05: autocorrelacao != 0: nao independencia dos residuos 
                                #p > 0.05  

## Homocedasticidade (Breusch-Pagan):
bptest(mod_SodPAD3)             #data:  mod_SodPAD3
                                #BP = 1.2236, df = 1, p-value = 0.2687
                                #p > 0.05: existe homocedasticidade   

# Passo 4: Analise do modelo
summary(mod_SodPAD3)            #Call:
                                #lm(formula = PAD_interp$onda3 ~ sodio_interp$onda3)

                                #Residuals: (Nao padronizados, por isso nao serao interpretados)
                                #Min      1Q  Median      3Q     Max 
                                #-27.170  -7.195  -0.727   6.434  54.965 

                                #Coefficients:
                                                    #Estimate   Std.     Error   t value Pr(>|t|)    
                                #(Intercept)        74.279514   0.375315 197.913 < 2e-16 ***
                                #sodio_interp$onda3  0.024708   0.003038   8.133 5.23e-16 *** p > 0.05: coeficiente = 0: sodio_interp$onda3 nao tem impacto no PAD
                                                                                             #p =< 0.05: coeficiente != 0 sodio_interp$onda3 tem impacto no PAD
                                                                                             #A cada 1 meq/l de sodio eu tenho 0.024mmhg de Pressao arterial   

                                #---
                                #Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

                                #Residual standard error: 10.25 on 5059 degrees of freedom
                                #Multiple R-squared:  0.01291,	Adjusted R-squared:  0.01271  #R^2 e melhor pois diz respeito a regressao simples (linear) 
                                #F-statistic: 66.14 on 1 and 5059 DF,  p-value: 5.226e-16     #R^2 o consumo de aproximadamente 1% de sodio explica do PAD
                                                                                              #p =< 0.05 existe uma diferenca entre os modelos
                                                                                              #H0: o valor da media da PAD acontece independente do consumo de sodio (sem previsor)
                                                                                              #H: o valor da PAD acontece decorrente do consumo de sodio (com previsor)  