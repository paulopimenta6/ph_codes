if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(mice, ROSE, VIM)
library(dplyr)
source("./src/script_analise_dados_elsa_Var_Lib.R")

################################################################################
count_missing <- function(df){
  sapply(df, function(col) sum(is.na(col)))
}

dfPresencaHipertensaoSistem <- data.frame(hip_onda1 = presencaDeHipertensaoArterialSistemicaOnda1,
                                          hip_onda2 = presencaDeHipertensaoArterialSistemicaOnda2,
                                          hip_onda3 = presencaDeHipertensaoArterialSistemicaOnda3
)

dfPresencaHipertensaoSistem <- dfPresencaHipertensaoSistem %>%
  dplyr::mutate(
    hip_onda1 = as.factor(hip_onda1),
    hip_onda2 = as.factor(hip_onda2),
    hip_onda3 = as.factor(hip_onda3),
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
dfTaxaFiltracaoGlomerular <- dfTaxaFiltracaoGlomerular %>%
  dplyr::mutate(
    filt_onda1 = as.factor(filt_onda1),
    filt_onda2 = as.factor(filt_onda2)
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
### Hipertensao
agg_plot <- aggr(dfPresencaHipertensaoSistem, col = c('navyblue', 'red'), 
                 numbers = TRUE, sortvars = TRUE, 
                 labels = names(dfPresencaHipertensaoSistem), 
                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                 ylab = c("Histogram of missing data", "Pattern"))
### Potassio
agg_plot <- aggr(dfPotassio, col = c('navyblue', 'red'), 
                 numbers = TRUE, sortvars = TRUE, 
                 labels = names(dfPotassio), 
                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                 ylab = c("Histogram of missing data", "Pattern"))
### Sodio
agg_plot <- aggr(dfSodio, col = c('navyblue', 'red'), 
                 numbers = TRUE, sortvars = TRUE, 
                 labels = names(dfSodio), 
                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                 ylab = c("Histogram of missing data", "Pattern"))
### PAS
agg_plot <- aggr(dfPAS, col = c('navyblue', 'red'), 
                 numbers = TRUE, sortvars = TRUE, 
                 labels = names(dfPAS), 
                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                 ylab = c("Histogram of missing data", "Pattern"))
### PAD
agg_plot <- aggr(dfPAD, col = c('navyblue', 'red'), 
                 numbers = TRUE, sortvars = TRUE, 
                 labels = names(dfPAD), 
                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                 ylab = c("Histogram of missing data", "Pattern"))
### Glomerular filtering tax
agg_plot <- aggr(dfTaxaFiltracaoGlomerular, col = c('navyblue', 'red'), 
                 numbers = TRUE, sortvars = TRUE, 
                 labels = names(dfTaxaFiltracaoGlomerular), 
                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                 ylab = c("Histogram of missing data", "Pattern"))
### Albumina-Creatinina Ratio
agg_plot <- aggr(dfRazaoAlbuminaCreatinina, col = c('navyblue', 'red'), 
                 numbers = TRUE, sortvars = TRUE, 
                 labels = names(dfRazaoAlbuminaCreatinina), 
                 cex.axis = 0.7, cex.numbers = 0.5,  # Ajuste o tamanho dos números
                 ylab = c("Histogram of missing data", "Pattern"))
################################################################################
### 1 - Discovering NAs in Hipertension
summary(dfPresencaHipertensaoSistem)
nacounts_hip <- count_missing(dfPresencaHipertensaoSistem)
hasNA_hip <- which(nacounts_hip>0)
nacounts_hip[hasNA_hip]

### 2 - Discovering NAs in Potassium
summary(dfPotassio)
nacounts_pot <- count_missing(dfPotassio)
hasNA_pot <- which(nacounts_pot>0)
nacounts_pot[hasNA_pot]

### 3 - Discovering NAs in Sodium
summary(dfSodio)
nacounts_sod <- count_missing(dfSodio)
hasNA_sod <- which(nacounts_sod>0)
nacounts_sod[hasNA_sod]

### 4 - Discovering NAs in Albumina-Creatinina ratio
summary(dfRazaoAlbuminaCreatinina)
nacounts_AlbuminaCreatinina <- count_missing(dfRazaoAlbuminaCreatinina)
hasNA_AlbuminaCreatinina <- which(nacounts_AlbuminaCreatinina>0)
nacounts_AlbuminaCreatinina[hasNA_AlbuminaCreatinina]

### 5 - Discovering NAs in Glomerular Filtration
summary(dfTaxaFiltracaoGlomerular)
nacounts_TaxaFiltracaoGlomerular <- count_missing(dfTaxaFiltracaoGlomerular)
hasNA_TaxaFiltracaoGlomerular <- which(nacounts_TaxaFiltracaoGlomerular>0)
nacounts_TaxaFiltracaoGlomerular[hasNA_TaxaFiltracaoGlomerular]

### 6 - Discovering NAs in PAS
summary(dfPAS)
nacounts_PAS <- count_missing(dfPAS)
hasNA_PAS <- which(nacounts_PAS>0)
nacounts_PAS[hasNA_PAS]

### 7 - Discovering NAs in PAD
summary(dfPAD)
nacounts_PAD <- count_missing(dfPAD)
hasNA_PAD <- which(nacounts_PAD>0)
nacounts_PAD[hasNA_PAD]
################################################################################
### Imputando valores para Hipertensao com pmm
### Rodar o algoritmo de imputação múltipla
imputacao_hip <- mice(dfPresencaHipertensaoSistem, method = "pmm", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dfPresencaHipertensaoSistem_imputado <- complete(imputacao_hip, 1)

### Imputando valores para Potassio com pmm
### Rodar o algoritmo de imputação múltipla
imputacao_Potassio <- mice(dfPotassio, method = "pmm", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dfPotassio_imputado <- complete(imputacao_Potassio, 1)

### Imputando valores para Sodio com pmm
### Rodar o algoritmo de imputação múltipla
imputacao_Sodio <- mice(dfSodio, method = "pmm", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dfSodio_imputado <- complete(imputacao_Sodio, 1)

### Imputando valores para Razao albumina creatinina com pmm
### Rodar o algoritmo de imputação múltipla
imputacao_RazaoAlbuminaCreatinina <- mice(dfRazaoAlbuminaCreatinina, method = "pmm", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dfRazaoAlbuminaCreatinina_imputado <- complete(imputacao_RazaoAlbuminaCreatinina, 1)

### Imputando valores para Taxa de filtracao Glomerular com pmm
### Rodar o algoritmo de imputação múltipla
imputacao_TaxaFiltracaoGlomerular <- mice(dfTaxaFiltracaoGlomerular, method = "polyreg", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dfTaxaFiltracaoGlomerular_imputado <- complete(imputacao_TaxaFiltracaoGlomerular, 1)

### Imputando valores para PAS com pmm
### Rodar o algoritmo de imputação múltipla
imputacao_pas <- mice(dfPAS, method = "pmm", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dfPAS_imputado <- complete(imputacao_pas, 1)

### Imputando valores para PAD com pmm
### Rodar o algoritmo de imputação múltipla
imputacao_pad <- mice(dfPAD, method = "pmm", m = 5, seed = 123)
### Gerar dataset com valores imputados (usando a primeira imputação completa)
dfPAD_imputado <- complete(imputacao_pad, 1)
################################################################################
### exemplo de undersampling com ROSE
#set.seed(123)  # Para reprodutibilidade
#balanced_data <- ovun.sample(hip_onda1 ~ ., data = dfPresencaHipertensaoSistem_imputado, method = "under", N = 1653 * 2)$data
# Verificando a nova distribuição das classes
#table(balanced_data$hip_onda1)
################################################################################