if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(VIM)
source("./src/script_analise_dados_elsa_Var_Lib.R")

colunas_hip <- c("hip_onda1", "hip_onda2", "hip_onda3")
colunas_filt <- c("filt_onda1", "filt_onda2")

transformFactor <- function(df, lab, lev){
  return(factor(df, labels = lab, levels = lev))
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
###Fazendo interpolacao via VIM::kNN
presencaHipertensaoSistem_interp <- VIM::kNN(dfPresencaHipertensaoSistem, k = 3)
presencaHipertensaoSistem_interp <- presencaHipertensaoSistem_interp[,-c(4:ncol(presencaHipertensaoSistem_interp))]

pot_interp <- VIM::kNN(dfPotassio, k=3)
pot_interp <- pot_interp[,-c(4:ncol(pot_interp))]

sodio_interp <- VIM::kNN(dfSodio, k=3)
sodio_interp <- sodio_interp[,-c(4:ncol(sodio_interp))]

razaoAlbuCreat_interp <- VIM::kNN(dfRazaoAlbuminaCreatinina, k = 3) 
razaoAlbuCreat_interp <- razaoAlbuCreat_interp[,-c(3:ncol(razaoAlbuCreat_interp))]

PAS_interp <- VIM::kNN(dfPAS, k = 3)
PAS_interp <- PAS_interp[, -c(4:ncol(PAS_interp))]

PAD_interp <- VIM::kNN(dfPAD, k = 3)
PAD_interp <- PAD_interp[,-c(4:ncol(PAD_interp))]

#Variavel_ordinal
taxaFiltracaoGlomerular_interp <- VIM::kNN(dfTaxaFiltracaoGlomerular, k = 3) 
taxaFiltracaoGlomerular_interp <- taxaFiltracaoGlomerular_interp[, -c(3:ncol(taxaFiltracaoGlomerular_interp))]
################################################################################

###Transformando em factors
presencaHipertensaoSistem_interp[colunas_hip] <- lapply(presencaHipertensaoSistem_interp[colunas_hip], transformFactor, c("N", "S"), c(0, 1))
#taxaFiltracaoGlomerular_interp[colunas_filt] <- lapply(taxaFiltracaoGlomerular_interp[colunas_filt], transformFactor, c("1", "2", "3", "4", "5", "6"), c(1, 2, 3, 4, 5, 6))
taxaFiltracaoGlomerular_interp[colunas_filt] <- lapply(
  taxaFiltracaoGlomerular_interp[colunas_filt],
  function(x) factor(x, levels = c(1,2,3,4,5,6), ordered = TRUE)
)

################################################################################
data <- cbind(presencaHipertensaoSistem_interp, pot_interp, sodio_interp, razaoAlbuCreat_interp,
                 PAS_interp, PAD_interp, taxaFiltracaoGlomerular_interp)