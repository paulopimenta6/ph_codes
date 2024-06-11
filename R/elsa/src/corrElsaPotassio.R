source("./src/script_analise_dados_elsa_Var_Lib.R")
library(VIM)
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

taxaFiltracaoGlomerular_interp <- kNN(dfTaxaFiltracaoGlomerular, k = 5) 
taxaFiltracaoGlomerular_interp <- taxaFiltracaoGlomerular_interp[, -c(3:ncol(taxaFiltracaoGlomerular_interp))]

PAS_interp <- kNN(dfPAS, k = 5)
PAS_interp <- PAS_interp[, -c(4,ncol(PAS_interp))]

PAD_interp <- kNN(dfPAD, k = 5)
PAD_interp <- PAD_interp[,-c(4:ncol(PAD_interp))]

presencaHipertensaoSistem_interp <- kNN(dfPresencaHipertensaoSistem, k = 5)
presencaHipertensaoSistem_interp <- presencaHipertensaoSistem_interp[,-c(4,ncol(presencaHipertensaoSistem_interp))]
################################################################################
###VD: y -> razaoAlbuCreat_interp
###VI: x -> pot_interp
###Potassio
plot(pot_interp$onda1, razaoAlbuCreat_interp$onda1, main = "Onda 1", xlab = "Concentracao de Potassio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")
plot(pot_interp$onda2, razaoAlbuCreat_interp$onda2, main = "Onda 2", xlab = "Concentracao de Potassio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")

plot(pot_interp$onda1, taxaFiltracaoGlomerular_interp$onda1, main = "Onda 1", xlab = "Concentracao de potassio (meq/l)", 
     ylab = "Taxa de filtracao Glomerular", 
     sub = "1 - Maior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15"
     )
plot(pot_interp$onda2, taxaFiltracaoGlomerular_interp$onda2, main = "Onda 2", xlab = "Concentracao de potassio (meq/l)", 
     ylab = "Taxa de filtracao Glomerular", 
     sub = "1 - Maior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15"
     )

plot(pot_interp$onda1, PAS_interp$onda1, main = "Onda 1", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
plot(pot_interp$onda2, PAS_interp$onda2, main = "Onda 2", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
plot(pot_interp$onda3, PAS_interp$onda3, main = "Onda 3", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")

plot(pot_interp$onda1, PAD_interp$onda1, main = "Onda 1", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
plot(pot_interp$onda2, PAD_interp$onda2, main = "Onda 2", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
plot(pot_interp$onda3, PAD_interp$onda3, main = "Onda 3", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")

###Sodio
plot(sodio_interp$onda1, razaoAlbuCreat_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")
plot(sodio_interp$onda2, razaoAlbuCreat_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")

plot(sodio_interp$onda1, taxaFiltracaoGlomerular_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", 
     ylab = "Taxa de filtracao Glomerular", 
     sub = "1 - Maior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15"
)
plot(sodio_interp$onda2, taxaFiltracaoGlomerular_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", 
     ylab = "Taxa de filtracao Glomerular", 
     sub = "1 - Maior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15"
)

plot(sodio_interp$onda1, PAS_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
plot(sodio_interp$onda2, PAS_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
plot(sodio_interp$onda3, PAS_interp$onda3, main = "Onda 3", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")

plot(sodio_interp$onda1, PAD_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
plot(sodio_interp$onda2, PAD_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
plot(sodio_interp$onda3, PAD_interp$onda3, main = "Onda 3", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")

###Histogramas
###Potassio
hist(pot_interp$onda1, breaks = "Sturges", ylab = "Frequencia", xlab = "Concentracao de potassio (meq/l)",
     main = "Histograma Onda 1"
)
hist(pot_interp$onda2, breaks = "Sturges", ylab = "Frequencia", xlab = "Concentracao de potassio (meq/l)",
     main = "Histograma Onda 2"
)
hist(pot_interp$onda3, breaks = "Sturges", ylab = "Frequencia", xlab = "Concentracao de potassio (meq/l)",
     main = "Histograma Onda 3"
)
###Sodio
hist(sodio_interp$onda1, breaks = "Sturges", ylab = "Frequencia", xlab = "Concentracao de potassio (meq/l)",
     main = "Onda 1"
)
hist(sodio_interp$onda2, breaks = "Sturges", ylab = "Frequencia", xlab = "Concentracao de potassio (meq/l)",
     main = "Onda 2"
)
hist(sodio_interp$onda3, breaks = "Sturges", ylab = "Frequencia", xlab = "Concentracao de potassio (meq/l)",
     main = "Onda 3"
)
###Taxa de filtracao glomerular
hist(taxaFiltracaoGlomerular_interp$onda1, breaks = "Sturges", ylab = "Frequencia", xlab = "Niveis de taxa de filtracao glomerular",
     main = "Histograma Onda 1",
     sub = "\n1Maior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15"
     )
hist(taxaFiltracaoGlomerular_interp$onda2, breaks = "Sturges", ylab = "Frequencia", xlab = "Niveis de taxa de filtracao glomerular",
     main = "Histograma Onda 2",
     sub = "\nMaior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15"
     )
###Razao Creatinina-Albuminuria
hist(razaoAlbuCreat_interp$onda1, breaks = "Sturges", ylab = "Frequencia", xlab = "Razao creatinina-albuminuria (mg/g)",
     main = "Histograma Onda 1",
     sub = "\n1Maior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15"
)
hist(razaoAlbuCreat_interp$onda2, breaks = "Sturges", ylab = "Frequencia", xlab = "Razao creatinina-albuminuria (mg/g)",
     main = "Histograma Onda 2",
     sub = "\nMaior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15"
)
###PAS
hist(PAS_interp$onda1, breaks = "Sturges", ylab = "Frequencia", xlab = "Pressao Arterial Sistolica (mmhg)", main = "Onda 1")
hist(PAS_interp$onda2, breaks = "Sturges", ylab = "Frequencia", xlab = "Pressao Arterial Sistolica (mmhg)", main = "Onda 2")
hist(PAS_interp$onda3, breaks = "Sturges", ylab = "Frequencia", xlab = "Pressao Arterial Sistolica (mmhg)", main = "Onda 3")
###PAD
hist(PAD_interp$onda1, breaks = "Sturges", ylab = "Frequencia", xlab = "Pressao Arterial Diastolica (mmhg)", main = "Onda 1")
hist(PAD_interp$onda2, breaks = "Sturges", ylab = "Frequencia", xlab = "Pressao Arterial Diastolica (mmhg)", main = "Onda 2")
hist(PAD_interp$onda3, breaks = "Sturges", ylab = "Frequencia", xlab = "Pressao Arterial Diastolica (mmhg)", main = "Onda 3")

###Grafico de barras
###Presenca de Hipertensao Sistemica
presencaHipertensaoSistem_interp$onda1 <- factor(presencaHipertensaoSistem_interp$onda1, levels = c(0,1), labels= c("Nao", "Sim"))
presencaHipertensaoSistem_interp$onda2 <- factor(presencaHipertensaoSistem_interp$onda2, levels = c(0,1), labels= c("Nao", "Sim"))
presencaHipertensaoSistem_interp$onda3 <- factor(presencaHipertensaoSistem_interp$onda3, levels = c(0,1), labels= c("Nao", "Sim"))
baplot(table(presencaHipertensaoSistem_interp$onda1), ylab = "Quantidade", xlab = "Presenca de pressao Arterial Sistemica")
barplot(table(presencaHipertensaoSistem_interp$onda2), ylab = "Quantidade", xlab = "Presenca de pressao Arterial Sistemica")
barplot(table(presencaHipertensaoSistem_interp$onda3), ylab = "Quantidade", xlab = "Presenca de pressao Arterial Sistemica")
################################################################################
###Analises para verificar normalidade
###Potassio
mod_PotRazaoAlbumCreat1 <- lm(razaoAlbuCreat_interp$onda1 ~ pot_interp$onda1) 
mod_PotRazaoAlbumCreat2 <- lm(razaoAlbuCreat_interp$onda2 ~ pot_interp$onda2)

mod_PotTaxaFiltGlomerular1 <- lm(taxaFiltracaoGlomerular_interp$onda1 ~ pot_interp$onda1) 
mod_PotTaxaFiltGlomerular2 <- lm(taxaFiltracaoGlomerular_interp$onda2 ~ pot_interp$onda2)

mod_PotPAS1 <- lm(PAS_interp$onda1 ~ pot_interp$onda1) 
mod_PotPAS2 <- lm(PAS_interp$onda2 ~ pot_interp$onda2)
mod_PotPAS3 <- lm(PAS_interp$onda3 ~ pot_interp$onda3)

mod_PotPAD1 <- lm(PAD_interp$onda1 ~ pot_interp$onda1) 
mod_PotPAD2 <- lm(PAD_interp$onda2 ~ pot_interp$onda2)
mod_PotPAD3 <- lm(PAD_interp$onda3 ~ pot_interp$onda3)
###Sodio
mod_PotRazaoAlbumCreat1 <- lm(razaoAlbuCreat_interp$onda1 ~ sodio_interp$onda1) 
mod_PotRazaoAlbumCreat2 <- lm(razaoAlbuCreat_interp$onda2 ~ sodio_interp$onda2)

mod_PotTaxaFiltGlomerular1 <- lm(taxaFiltracaoGlomerular_interp$onda1 ~ sodio_interp$onda1) 
mod_PotTaxaFiltGlomerular2 <- lm(taxaFiltracaoGlomerular_interp$onda2 ~ sodio_interp$onda2)

mod_PotPAS1 <- lm(PAS_interp$onda1 ~ sodio_interp$onda1) 
mod_PotPAS2 <- lm(PAS_interp$onda2 ~ sodio_interp$onda2)
mod_PotPAS3 <- lm(PAS_interp$onda3 ~ sodio_interp$onda3)

mod_PotPAD1 <- lm(PAD_interp$onda1 ~ sodio_interp$onda1) 
mod_PotPAD2 <- lm(PAD_interp$onda2 ~ sodio_interp$onda2)
mod_PotPAD3 <- lm(PAD_interp$onda3 ~ sodio_interp$onda3)
################################################################################
#par(mfrow = c(2,2))
#plot(mod1, main = "Onda 1")
#plot(mod2, main = "Onda 2")