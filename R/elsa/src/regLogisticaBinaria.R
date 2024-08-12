if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, VIM)
source("./src/script_analise_dados_elsa_Var_Lib.R")

colunas_hip <- c("hip_onda1", "hip_onda2", "hip_onda3")
colunas_filt <- c("filt_onda1", "filt_onda2")

transformFractor <- function(df, lab, lev){
  return(factor(df, label = lab, levels = lev))
  
  
}
################################################################################
dfPresencaHipertensaoSistem <- data.frame(hip_onda1 = presencaDeHipertensaoArterialSistemicaOnda1,
                                          hip_onda2 = presencaDeHipertensaoArterialSistemicaOnda2,
                                          hip_onda3 = presencaDeHipertensaoArterialSistemicaOnda3
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

dfPAS <- data.frame(PAS_onda1 = pressaoArterialSistolicaMediaOnda1,
                    PAS_onda2 = pressaoArterialSistolicaMediaOnda2,
                    PAS_onda3 = pressaoArterialSistolicaMediaOnda3
                    )

dfPAD <- data.frame(PAD_onda1 = pressaoDiastolicamediaOnda1,
                    PAD_onda2 = pressaoDiastolicamediaOnda2,
                    PAD_onda3 = pressaoDiastolicamediaOnda3
                    )

################################################################################
###Fazendo interpolacao via kNN
presencaHipertensaoSistem_interp <- kNN(dfPresencaHipertensaoSistem, k = 5)
presencaHipertensaoSistem_interp <- presencaHipertensaoSistem_interp[,
                                                                     -c(4:ncol(presencaHipertensaoSistem_interp))]

pot_interp <- kNN(dfPotassio, k=5)
pot_interp <- pot_interp[,-c(4:ncol(pot_interp))]

sodio_interp <- kNN(dfSodio, k=5)
sodio_interp <- sodio_interp[,-c(4:ncol(sodio_interp))]

razaoAlbuCreat_interp <- kNN(dfRazaoAlbuminaCreatinina, k = 5) 
razaoAlbuCreat_interp <- razaoAlbuCreat_interp[, -c(3:ncol(razaoAlbuCreat_interp))]

PAS_interp <- kNN(dfPAS, k = 5)
PAS_interp <- PAS_interp[, -c(4:ncol(PAS_interp))]

PAD_interp <- kNN(dfPAD, k = 5)
PAD_interp <- PAD_interp[,-c(4:ncol(PAD_interp))]

#Variavel_ordinal
taxaFiltracaoGlomerular_interp <- kNN(dfTaxaFiltracaoGlomerular, k = 5) 
taxaFiltracaoGlomerular_interp <- taxaFiltracaoGlomerular_interp[, 
                                                                 -c(3:ncol(taxaFiltracaoGlomerular_interp))]
################################################################################

###Transformando em factors
presencaHipertensaoSistem_interp[colunas_hip] <- lapply(presencaHipertensaoSistem_interp[colunas_hip], transformFractor, c("N", "S"), c(0, 1))
taxaFiltracaoGlomerular_interp[colunas_filt] <- lapply(taxaFiltracaoGlomerular_interp[colunas_filt], 
                                                       transformFractor, c("1", "2", "3", "4", "5", "6"), c(1, 2, 3, 4, 5, 6))

###Analisando os dados
#view(presencaHipertensaoSistem_interp)
glimpse(presencaHipertensaoSistem_interp)

###Fazendo uma analise exploratoria
table(presencaHipertensaoSistem_interp$hip_onda1)
table(presencaHipertensaoSistem_interp$hip_onda2)
table(presencaHipertensaoSistem_interp$hip_onda3)
###Um conjunto de dados geralmente é considerado desbalanceado quando uma das classes 
###representa menos de 10% a 20% do total de observações.
###Neste caso, a classe S representa aproximadamente 32.7% dos dados, enquanto a classe N representa 67.3%.

################################################################################
dataGLM <- cbind(presencaHipertensaoSistem_interp, pot_interp, sodio_interp, razaoAlbuCreat_interp,
                PAS_interp, PAD_interp, taxaFiltracaoGlomerular_interp)

mod1 <- glm(data = dataGLM, hip_onda1 ~ PAS_onda1, family = binomial(link = "logit"))
plot(mod1, which = 5)

###Ausencia de multicolinearidade
#pairs.panels(dataGLM) #r > 0.9 (ou r > 0.8), mas como temos somente uma VI, entao nao faz sentido analisar isto.