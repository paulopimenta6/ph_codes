### Passo 0: Carregar dados
source("./src/data/script_analise_dados_elsa_Var_Lib.R")
source("./src/data/data_kNN_v3.R")  # Verifique se 'data' está corretamente carregado


### Passo 1: Carregar os pacotes
if (!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(dplyr, lme4, lmerTest)

# Junta dados e prepara para o modelo
dadosLong <- bind_rows(dadosOnda1kNN_inp, dadosOnda2kNN_inp, dadosOnda3kNN_inp)

dadosLong <- dadosLong %>%
  mutate(
    pot = (scale(pot)),
    sod = (scale(sod)),
    pas = (scale(pas)),
    pad = (scale(pad)),
    hba1c = (scale(hba1c)),
    albCreat = (scale(albCreat)),
    taxaFilt = (scale(taxaFiltCal))
  )

modelo_misto <- lmer(taxaFiltCal ~ albCreat + sod + pot + pas + pad + diabetes + antidiabeticosOrais + (1 | idElsa), data = dadosLong)
lmerTest::step(modelo_misto)
summary(modelo_misto)