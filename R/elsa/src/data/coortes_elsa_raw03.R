if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, lme4, lmerTest, bbmle, sjPlot, ggeffects)

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
  filt_onda1 = taxaFiltracaoGlomerularComCalibracaoOnda1,
  filt_onda2 = taxaFiltracaoGlomerularComCalibracaoOnda2
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
  idElsa = idElsa,
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
  idElsa = idElsa,
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
  idElsa = idElsa,
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

# Padroniza variáveis contínuas
dadosLong <- dadosLong %>%
  mutate(
    pot = (scale(pot)),
    sod = (scale(sod)),
    pas = (scale(pas)),
    pad = (scale(pad)),
    hba1c = (scale(hba1c)),
    albCreat = (scale(albCreat)),
    taxaFilt = (scale(taxaFilt))
)

dadosLong$diabetes <- as.factor(dadosLong$diabetes)
dadosLong$antidiabeticosOrais <- as.factor(dadosLong$antidiabeticosOrais)

### Verificando variaveis
str(dadosLong)

### Verificando colinearidade
vif(lm(taxaFilt ~ albCreat + sod + pot + pas + pad + diabetes, data = dadosLong))

### Criando modelos 
m0 <- lm(taxaFilt ~ albCreat + sod + pot + pas + pad + diabetes, data = dadosLong)
m1 <- lmer(taxaFilt ~ albCreat + sod + pot + pas + pad + diabetes + (1 | idElsa), data = dadosLong)
m2 <- lmer(taxaFilt ~ albCreat * diabetes + sod + pot + pas + pad + (1 | idElsa), data = dadosLong)
m3 <- lmer(taxaFilt ~ sod * pot + albCreat + pas + pad + diabetes + (1 | idElsa), data = dadosLong)
m4 <- lmer(taxaFilt ~ pas * pad + albCreat + sod + pot + diabetes + (1 | idElsa), data = dadosLong)
m5 <- lmer(taxaFilt ~ albCreat * diabetes + sod * pot + pas * pad + (1 | idElsa), data = dadosLong)
m6 <- lmer(taxaFilt ~ onda * diabetes + onda * albCreat + sod + pot + pas + pad + (1 | idElsa), data = dadosLong)

### Anova
anova(m1, m2, m3, m4, m5, m6)
### AIC
AIC(m0, m1, m2, m3, m4, m5, m6)
### BIC
BIC(m0, m1, m2, m3, m4, m5, m6)

### Reduzindo o modelo
m6_reduzido <- lmer(taxaFilt ~ onda + albCreat + onda:albCreat + sod + pot + pas + pad + diabetes + (1 | idElsa), data = dadosLong)
anova(m6, m6_reduzido)
AIC(m6, m6_reduzido)

### Visualizando o modelo
sjPlot::tab_model(m6_reduzido, show.re.var = TRUE, show.icc = TRUE)
plot(ggpredict(m6_reduzido, terms = c("onda", "albCreat [meansd]")))
r2(m6_reduzido)
################################################################################