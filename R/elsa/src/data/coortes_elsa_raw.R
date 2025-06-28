if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, ordinal, MuMIn, ggeffects, effects)
source("./src/data/script_analise_dados_elsa_Var_Lib.R")
################################################################################
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

############################ Indicador de diabetes #############################
dfHemoglobinaGlicada <- data.frame(hbac_onda1 = hemoglobinaGlicadaHba1cOnda1,
                                   hbac_onda2 = hemoglobinaGlicadaHba2cOnda2,
                                   hbac_onda3 = hemoglobinaGlicadaHba3cOnda3
)

dfFazUsoContinuoInsulina <- data.frame(insulina_onda1 = fazUsoContinuoInsulinaONda1,
                                       insulina_onda2 = fazUsoContinuoInsulinaONda2,
                                       insulina_onda3 = fazUsoContinuoInsulinaONda3
)

dfFazUsoContinuoInsulina <- dfFazUsoContinuoInsulina %>%
  dplyr::mutate(
    insulina_onda1 = as.factor(insulina_onda1),
    insulina_onda2 = as.factor(insulina_onda2),
    insulina_onda3 = as.factor(insulina_onda3),
  )

dfFazUsoAntidiabeticosOrais <- data.frame(antidiabeticos_onda1 = tomaAntidiabeticosOraisOnda1,
                                          antidiabeticos_onda2 = tomaAntidiabeticosOraisOnda2,
                                          antidiabeticos_onda3 = tomaAntidiabeticosOraisOnda3
)

dfFazUsoAntidiabeticosOrais <- dfFazUsoAntidiabeticosOrais %>%
  dplyr::mutate(
    antidiabeticos_onda1 = as.factor(antidiabeticos_onda1),
    antidiabeticos_onda2 = as.factor(antidiabeticos_onda2),
    antidiabeticos_onda3 = as.factor(antidiabeticos_onda3),
  )
################################################################################

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
### Criando os novos data frames que serao imputados
dadosOnda1 <- data.frame(
  idElsa = idElsa,
  sexo = sexo,
  hip = dfPresencaHipertensaoSistem$hip_onda1,
  pot = dfPotassio$pot_onda1,
  sod = dfSodio$sod_onda1,
  ###Inclusao de indicadores de diabetes
  hba1c = dfHemoglobinaGlicada$hbac_onda1,
  insulina = dfFazUsoContinuoInsulina$insulina_onda1,
  antidiabeticosOrais = dfFazUsoAntidiabeticosOrais$antidiabeticos_onda1,
  ###Fim dos indicadores de diabetes
  albCreat = dfRazaoAlbuminaCreatinina$albCreat_onda1,
  taxaFilt = dfTaxaFiltracaoGlomerular$filt_onda1,
  pas = dfPAS$PAS_onda1,
  pad = dfPAD$PAD_onda1
)

dadosOnda2 <- data.frame(
  idElsa = idElsa,
  sexo = sexo,
  hip = dfPresencaHipertensaoSistem$hip_onda2,
  pot = dfPotassio$pot_onda2,
  sod = dfSodio$sod_onda2,
  ###Inclusao de indicadores de diabetes
  hba1c = dfHemoglobinaGlicada$hbac_onda2,
  insulina = dfFazUsoContinuoInsulina$insulina_onda2,
  antidiabeticosOrais = dfFazUsoAntidiabeticosOrais$antidiabeticos_onda2,
  ###Fim dos indicadores de diabetes
  albCreat = dfRazaoAlbuminaCreatinina$albCreat_onda2,
  taxaFilt = dfTaxaFiltracaoGlomerular$filt_onda2,
  pas = dfPAS$PAS_onda2,
  pad = dfPAD$PAD_onda2
)

dadosOnda3 <- data.frame(
  idElsa = idElsa,
  sexo = sexo,
  hip = dfPresencaHipertensaoSistem$hip_onda3,
  pot = dfPotassio$pot_onda3,
  sod = dfSodio$sod_onda3,
  ###Inclusao de indicadores de diabetes
  hba1c = dfHemoglobinaGlicada$hbac_onda3,
  insulina = dfFazUsoContinuoInsulina$insulina_onda3,
  antidiabeticosOrais = dfFazUsoAntidiabeticosOrais$antidiabeticos_onda3,
  ###Fim dos indicadores de diabetes
  pas = dfPAS$PAS_onda3,
  pad = dfPAD$PAD_onda3
)
################################################################################
################ Criando coluna para diabetes mellitus #########################
### Onda 1
dadosOnda1$diabetes <- ifelse(
  dadosOnda1$hba1c >= 6.5, 1, 0
)
### Onda 2
dadosOnda2$diabetes <- ifelse(
  dadosOnda2$hba1c >= 6.5, 1, 0
)
### Onda 3
dadosOnda3$diabetes <- ifelse(
  dadosOnda3$hba1c >= 6.5, 1, 0
)
################################################################################
### Adiciona coluna de onda
dadosOnda1$onda <- 1
dadosOnda2$onda <- 2
dadosOnda3$onda <- 3

### Garante que todas as colunas existam nas três ondas (em especial taxaFilt ausente na Onda 3)
dadosOnda3$taxaFilt <- NA  # Se não tiver os dados da TFG na onda 3

### Junta tudo
dadosLong <- bind_rows(dadosOnda1, dadosOnda2, dadosOnda3)

### Prepara dados do modelo
dadosLong <- dadosLong %>%
  mutate(
    idElsa = as.factor(idElsa),
    onda = as.factor(onda),
    taxaFilt = as.factor(taxaFilt)  # TFG e categórica
)

### TFG e categorica ordinal ---> criando um modelo
#### Modelo 1
modelo_inicial <- clmm(
  taxaFilt ~ sexo + hip + pot + sod + hba1c + insulina + antidiabeticosOrais +
    albCreat + pas + pad + onda + (1 | idElsa),
  data = dadosLong
)
summary(modelo_inicial)

#### Modelo 2
#modelo2 <- lmer(
#  taxaFilt ~ sexo + hip + pot + sod + hba1c + insulina + antidiabeticosOrais +
#    albCreat + pas + pad + onda + (1 + onda | idElsa),
#  data = dadosLong
#)

#anova(modelo, modelo2)  # Testa se o modelo com slope aleatório melhora

# Rode modelo com todas as variáveis sem efeito aleatório para simplificar o dredge
modelo_fixed <- clm(
  taxaFilt ~ sexo + hip + pot + sod + hba1c + insulina + antidiabeticosOrais +
    albCreat + pas + pad + onda,
  data = dadosLong
)

### Seleção de modelos com base em AIC
modelo_dredge <- dredge(modelo_fixed, trace = TRUE)
best_model <- get.models(modelo_dredge, 1)[[1]]
summary(best_model)

modelo_final <- clmm(
  formula(best_model),
  random = ~ 1 | idElsa,
  data = dadosLong
)
summary(modelo_final)

plot(allEffects(modelo_final))