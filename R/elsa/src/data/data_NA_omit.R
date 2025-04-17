source("./src/data/script_analise_dados_elsa_Var_Lib.R")

colunas_hip <- c("hip_onda1", "hip_onda2", "hip_onda3")
colunas_filt <- c("filt_onda1", "filt_onda2")

transformFractor <- function(df, lab, lev){
  return(factor(df, label = lab, levels = lev))
}
################################################################################
### Presenca de hipertensao ajustada
dfHip <- data.frame(hip_onda1 = presencaDeHipertensaoArterialSistemicaOnda1,
                    hip_onda2 = presencaDeHipertensaoArterialSistemicaOnda2,
                    hip_onda3 = presencaDeHipertensaoArterialSistemicaOnda3
)
dfHip <- na.omit(dfHip)

### Concentracao de potassio ajustada
dfPotassio <- data.frame(pot_onda1 = potassioOnda1,
                         pot_onda2 = potassioOnda2,
                         pot_onda3 = potassioOnda3
)
dfPotassio <- na.omit(dfPotassio)

### Concentracao de sodio ajustada
dfSodio <- data.frame(sod_onda1 = sodioUrinaOnda1,
                      sod_onda2 = sodioUrinaOnda2,
                      sod_onda3 = sodioUrinaOnda3
)
dfSodio <- na.omit(dfSodio)

### Razao albumina-creatinina ajustada
dfRazaoAlbuminaCreatinina <- data.frame(albCreat_onda1 = razaoAlbuminaCreatininaRastreavelOnda1,
                                        albCreat_onda2 = razaoAlbuminaCreatininaRastreavelOnda2
)
dfRazaoAlbuminaCreatinina <- na.omit(dfRazaoAlbuminaCreatinina)

### Taxa de filtração glomerular ajustada
dfTaxaFiltracaoGlomerular <- data.frame(filt_onda1 = categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1,
                                        filt_onda2 = categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2
)
dfTaxaFiltracaoGlomerular <- na.omit(dfTaxaFiltracaoGlomerular)

### PAS ajustado
dfPAS <- data.frame(PAS_onda1 = pressaoArterialSistolicaMediaOnda1,
                    PAS_onda2 = pressaoArterialSistolicaMediaOnda2,
                    PAS_onda3 = pressaoArterialSistolicaMediaOnda3
)
dfPAS <- na.omit(dfPAS)

### PAD ajustado sem NAs
dfPAD <- data.frame(PAD_onda1 = pressaoDiastolicamediaOnda1,
                    PAD_onda2 = pressaoDiastolicamediaOnda2,
                    PAD_onda3 = pressaoDiastolicamediaOnda3
)
dfPAD <- na.omit(dfPAD)
################################################################################
