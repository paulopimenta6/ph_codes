if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(VIM)
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
###Fazendo interpolacao via VIM::kNN
presencaHipertensaoSistem_interp <- VIM::kNN(dfPresencaHipertensaoSistem, k = 5)
presencaHipertensaoSistem_interp <- presencaHipertensaoSistem_interp[,
                                                                     -c(4:ncol(presencaHipertensaoSistem_interp))]

pot_interp <- VIM::kNN(dfPotassio, k=5)
pot_interp <- pot_interp[,-c(4:ncol(pot_interp))]

sodio_interp <- VIM::kNN(dfSodio, k=5)
sodio_interp <- sodio_interp[,-c(4:ncol(sodio_interp))]

razaoAlbuCreat_interp <- VIM::kNN(dfRazaoAlbuminaCreatinina, k = 5) 
razaoAlbuCreat_interp <- razaoAlbuCreat_interp[, -c(3:ncol(razaoAlbuCreat_interp))]

PAS_interp <- VIM::kNN(dfPAS, k = 5)
PAS_interp <- PAS_interp[, -c(4:ncol(PAS_interp))]

PAD_interp <- VIM::kNN(dfPAD, k = 5)
PAD_interp <- PAD_interp[,-c(4:ncol(PAD_interp))]

#Variavel_ordinal
taxaFiltracaoGlomerular_interp <- VIM::kNN(dfTaxaFiltracaoGlomerular, k = 5) 
taxaFiltracaoGlomerular_interp <- taxaFiltracaoGlomerular_interp[, 
                                                                 -c(3:ncol(taxaFiltracaoGlomerular_interp))]
################################################################################

###Transformando em factors
presencaHipertensaoSistem_interp[colunas_hip] <- lapply(presencaHipertensaoSistem_interp[colunas_hip], transformFractor, c("N", "S"), c(0, 1))
taxaFiltracaoGlomerular_interp[colunas_filt] <- lapply(taxaFiltracaoGlomerular_interp[colunas_filt], 
                                                       transformFractor, c("1", "2", "3", "4", "5", "6"), c(1, 2, 3, 4, 5, 6))

################################################################################
dataGLM <- cbind(presencaHipertensaoSistem_interp, pot_interp, sodio_interp, razaoAlbuCreat_interp,
                 PAS_interp, PAD_interp, taxaFiltracaoGlomerular_interp)

dataGLM_Hip_PAS_Onda1 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda1, PAS = PAS_interp$PAS_onda1)
dataGLM_Hip_PAS_Onda2 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda2, PAS = PAS_interp$PAS_onda2)
dataGLM_Hip_PAS_Onda3 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda3, PAS = PAS_interp$PAS_onda3)

dataGLM_Hip_PAD_Onda1 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda1, PAD = PAD_interp$PAD_onda1)
dataGLM_Hip_PAD_Onda2 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda2, PAD = PAD_interp$PAD_onda2)
dataGLM_Hip_PAD_Onda3 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda3, PAD = PAD_interp$PAD_onda3)

dataGLM_Hip_pot_Onda1 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda1, pot = pot_interp$pot_onda1)
dataGLM_Hip_pot_Onda2 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda2, pot =  pot_interp$pot_onda2)
dataGLM_Hip_pot_Onda3 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda3, pot =  pot_interp$pot_onda3)

dataGLM_Hip_sod_Onda1 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda1, sod = sodio_interp$sod_onda1)
dataGLM_Hip_sod_Onda2 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda2, sod = sodio_interp$sod_onda2)
dataGLM_Hip_sod_Onda3 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda3, sod = sodio_interp$sod_onda3)

dataGLM_Hip_albCreat1 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda1, albuCreat = razaoAlbuCreat_interp$albCreat_onda1)
dataGLM_Hip_albCreat2 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda2, albuCreat = razaoAlbuCreat_interp$albCreat_onda2)

dataGLM_Hip_taxaFiltracaoGlomerular_Onda1 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda1, taxaFiltracaoGlomerular = taxaFiltracaoGlomerular_interp$filt_onda1)
dataGLM_Hip_taxaFiltracaoGlomerular_Onda2 <- data.frame(Hip = presencaHipertensaoSistem_interp$hip_onda2, taxaFiltracaoGlomerular = taxaFiltracaoGlomerular_interp$filt_onda2)
