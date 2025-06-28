if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, ordinal, MuMIn, ggeffects, effects)

# Carrega os dados
source("./src/data/script_analise_dados_elsa_Var_Lib.R")

# Organiza variáveis por onda
dfPresencaHipertensaoSistem <- data.frame(
  hip_onda1 = as.factor(presencaDeHipertensaoArterialSistemicaOnda1),
  hip_onda2 = as.factor(presencaDeHipertensaoArterialSistemicaOnda2),
  hip_onda3 = as.factor(presencaDeHipertensaoArterialSistemicaOnda3)
)

dfPotassio <- data.frame(
  pot_onda1 = potassioOnda1,
  pot_onda2 = potassioOnda2,
  pot_onda3 = potassioOnda3
)

dfSodio <- data.frame(
  sod_onda1 = sodioUrinaOnda1,
  sod_onda2 = sodioUrinaOnda2,
  sod_onda3 = sodioUrinaOnda3
)

dfHemoglobinaGlicada <- data.frame(
  hbac_onda1 = hemoglobinaGlicadaHba1cOnda1,
  hbac_onda2 = hemoglobinaGlicadaHba2cOnda2,
  hbac_onda3 = hemoglobinaGlicadaHba3cOnda3
)

dfFazUsoContinuoInsulina <- data.frame(
  insulina_onda1 = as.factor(fazUsoContinuoInsulinaONda1),
  insulina_onda2 = as.factor(fazUsoContinuoInsulinaONda2),
  insulina_onda3 = as.factor(fazUsoContinuoInsulinaONda3)
)

dfFazUsoAntidiabeticosOrais <- data.frame(
  antidiabeticos_onda1 = as.factor(tomaAntidiabeticosOraisOnda1),
  antidiabeticos_onda2 = as.factor(tomaAntidiabeticosOraisOnda2),
  antidiabeticos_onda3 = as.factor(tomaAntidiabeticosOraisOnda3)
)

dfRazaoAlbuminaCreatinina <- data.frame(
  albCreat_onda1 = razaoAlbuminaCreatininaRastreavelOnda1,
  albCreat_onda2 = razaoAlbuminaCreatininaRastreavelOnda2
)

dfTaxaFiltracaoGlomerular <- data.frame(
  filt_onda1 = as.factor(categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1),
  filt_onda2 = as.factor(categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2)
)

dfPAS <- data.frame(
  PAS_onda1 = pressaoArterialSistolicaMediaOnda1,
  PAS_onda2 = pressaoArterialSistolicaMediaOnda2,
  PAS_onda3 = pressaoArterialSistolicaMediaOnda3
)

dfPAD <- data.frame(
  PAD_onda1 = pressaoDiastolicamediaOnda1,
  PAD_onda2 = pressaoDiastolicamediaOnda2,
  PAD_onda3 = pressaoDiastolicamediaOnda3
)

# Criação dos data frames por onda
dadosOnda1 <- data.frame(
  idElsa = as.factor(idElsa),
  sexo = sexo,
  hip = dfPresencaHipertensaoSistem$hip_onda1,
  pot = dfPotassio$pot_onda1,
  sod = dfSodio$sod_onda1,
  hba1c = dfHemoglobinaGlicada$hbac_onda1,
  insulina = dfFazUsoContinuoInsulina$insulina_onda1,
  antidiabeticosOrais = dfFazUsoAntidiabeticosOrais$antidiabeticos_onda1,
  albCreat = dfRazaoAlbuminaCreatinina$albCreat_onda1,
  taxaFilt = dfTaxaFiltracaoGlomerular$filt_onda1,
  pas = dfPAS$PAS_onda1,
  pad = dfPAD$PAD_onda1,
  onda = 1
)

dadosOnda2 <- data.frame(
  idElsa = as.factor(idElsa),
  sexo = sexo,
  hip = dfPresencaHipertensaoSistem$hip_onda2,
  pot = dfPotassio$pot_onda2,
  sod = dfSodio$sod_onda2,
  hba1c = dfHemoglobinaGlicada$hbac_onda2,
  insulina = dfFazUsoContinuoInsulina$insulina_onda2,
  antidiabeticosOrais = dfFazUsoAntidiabeticosOrais$antidiabeticos_onda2,
  albCreat = dfRazaoAlbuminaCreatinina$albCreat_onda2,
  taxaFilt = dfTaxaFiltracaoGlomerular$filt_onda2,
  pas = dfPAS$PAS_onda2,
  pad = dfPAD$PAD_onda2,
  onda = 2
)

# Onda 3 sem taxaFilt
dadosOnda3 <- data.frame(
  idElsa = as.factor(idElsa),
  sexo = sexo,
  hip = dfPresencaHipertensaoSistem$hip_onda3,
  pot = dfPotassio$pot_onda3,
  sod = dfSodio$sod_onda3,
  hba1c = dfHemoglobinaGlicada$hbac_onda3,
  insulina = dfFazUsoContinuoInsulina$insulina_onda3,
  antidiabeticosOrais = dfFazUsoAntidiabeticosOrais$antidiabeticos_onda3,
  albCreat = NA,
  taxaFilt = NA,
  pas = dfPAS$PAS_onda3,
  pad = dfPAD$PAD_onda3,
  onda = 3
)

# Adiciona variável de diabetes (não usada no modelo, mas disponível)
dadosOnda1$diabetes <- ifelse(dadosOnda1$hba1c >= 6.5, 1, 0)
dadosOnda2$diabetes <- ifelse(dadosOnda2$hba1c >= 6.5, 1, 0)
dadosOnda3$diabetes <- ifelse(dadosOnda3$hba1c >= 6.5, 1, 0)

# Junta dados e prepara para o modelo
dadosLong <- bind_rows(dadosOnda1, dadosOnda2, dadosOnda3)

# Filtra apenas linhas com taxaFilt disponível (ondas 1 e 2)
dadosLong <- dadosLong %>% filter(!is.na(taxaFilt))

# Padroniza variáveis contínuas
dadosLong <- dadosLong %>%
  mutate(
    pot = scale(pot),
    sod = scale(sod),
    pas = scale(pas),
    pad = scale(pad),
    hba1c = scale(hba1c),
    albCreat = scale(albCreat),
    onda = as.factor(onda),
    taxaFilt = factor(taxaFilt, ordered = TRUE)  # se for ordinal
  )

# Modelo com efeito aleatório
modelo_misto <- clmm(
  taxaFilt ~ sexo + hip + pot + sod + hba1c + insulina + antidiabeticosOrais +
    albCreat + pas + pad + onda + (1 | idElsa),
  data = dadosLong
)
summary(modelo_misto)

# Modelo sem efeito aleatório para uso com dredge
modelo_fixed <- clm(
  taxaFilt ~ sexo + hip + pot + sod + hba1c + insulina + antidiabeticosOrais +
    albCreat + pas + pad + onda,
  data = dadosLong,
  na.action = na.fail
)

# Model selection com dredge (AIC)
modelo_dredge <- dredge(modelo_fixed, trace = TRUE)
best_model <- get.models(modelo_dredge, 1)[[1]]
summary(best_model)

# Modelo final com estrutura do best_model + efeito aleatório
modelo_final <- clmm(
  formula(best_model),
  random = ~1 | idElsa,
  data = dadosLong
)
summary(modelo_final)

# Visualização dos efeitos marginais
plot(allEffects(modelo_final))
