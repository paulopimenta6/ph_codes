if (!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(
  dplyr, tidyr, lme4, lmerTest, performance,
  ggeffects, sjPlot, car, bbmle
)

# Carrega os dados brutos
source("./src/data/script_analise_dados_elsa_Var_Lib.R")

# Função auxiliar para transformar em formato longo
to_long <- function(df, prefix, value_name) {
  df |>
    pivot_longer(
      cols = starts_with(prefix),
      names_to = "onda",
      names_pattern = paste0(prefix, "_onda(\\d+)"),
      values_to = value_name
    ) |>
    mutate(onda = as.integer(onda))
}

# Criação dos data frames individuais -------------------------

df_hip <- data.frame(
  id_elsa = idElsa,
  hip_onda1 = presencaDeHipertensaoArterialSistemicaOnda1,
  hip_onda2 = presencaDeHipertensaoArterialSistemicaOnda2,
  hip_onda3 = presencaDeHipertensaoArterialSistemicaOnda3
) |>
  to_long("hip", "hip") |>
  mutate(hip = as.factor(hip))

df_pot <- data.frame(
  id_elsa = idElsa,
  pot_onda1 = potassioOnda1,
  pot_onda2 = potassioOnda2,
  pot_onda3 = potassioOnda3
) |> to_long("pot", "pot")

df_sod <- data.frame(
  id_elsa = idElsa,
  sod_onda1 = sodioUrinaOnda1,
  sod_onda2 = sodioUrinaOnda2,
  sod_onda3 = sodioUrinaOnda3
) |> to_long("sod", "sod")

df_hba1c <- data.frame(
  id_elsa = idElsa,
  hba1c_onda1 = hemoglobinaGlicadaHba1cOnda1,
  hba1c_onda2 = hemoglobinaGlicadaHba2cOnda2,
  hba1c_onda3 = hemoglobinaGlicadaHba3cOnda3
) |> to_long("hba1c", "hba1c")

df_insulina <- data.frame(
  id_elsa = idElsa,
  insulina_onda1 = fazUsoContinuoInsulinaONda1,
  insulina_onda2 = fazUsoContinuoInsulinaONda2,
  insulina_onda3 = fazUsoContinuoInsulinaONda3
) |>
  to_long("insulina", "insulina") |>
  mutate(insulina = as.factor(insulina))

df_antidiabeticos <- data.frame(
  id_elsa = idElsa,
  antidiabeticos_onda1 = tomaAntidiabeticosOraisOnda1,
  antidiabeticos_onda2 = tomaAntidiabeticosOraisOnda2,
  antidiabeticos_onda3 = tomaAntidiabeticosOraisOnda3
) |>
  to_long("antidiabeticos", "antidiabeticos_orais") |>
  mutate(antidiabeticos_orais = as.factor(antidiabeticos_orais))

df_albcreat <- data.frame(
  id_elsa = idElsa,
  albcreat_onda1 = razaoAlbuminaCreatininaRastreavelOnda1,
  albcreat_onda2 = razaoAlbuminaCreatininaRastreavelOnda2
) |> to_long("albcreat", "albcreat")

df_filtracao <- data.frame(
  id_elsa = idElsa,
  taxa_filt_onda1 = taxaFiltracaoGlomerularComCalibracaoOnda1,
  taxa_filt_onda2 = taxaFiltracaoGlomerularComCalibracaoOnda2
) |> to_long("taxa_filt", "taxa_filt")

df_pas <- data.frame(
  id_elsa = idElsa,
  pas_onda1 = pressaoArterialSistolicaMediaOnda1,
  pas_onda2 = pressaoArterialSistolicaMediaOnda2,
  pas_onda3 = pressaoArterialSistolicaMediaOnda3
) |> to_long("pas", "pas")

df_pad <- data.frame(
  id_elsa = idElsa,
  pad_onda1 = pressaoDiastolicamediaOnda1,
  pad_onda2 = pressaoDiastolicamediaOnda2,
  pad_onda3 = pressaoDiastolicamediaOnda3
) |> to_long("pad", "pad")

# Junta todos os data frames pelo par (id, onda) -----------------
dados_long <- df_hip |>
  left_join(df_pot, by = c("id_elsa", "onda")) |>
  left_join(df_sod, by = c("id_elsa", "onda")) |>
  left_join(df_hba1c, by = c("id_elsa", "onda")) |>
  left_join(df_insulina, by = c("id_elsa", "onda")) |>
  left_join(df_antidiabeticos, by = c("id_elsa", "onda")) |>
  left_join(df_albcreat, by = c("id_elsa", "onda")) |>
  left_join(df_filtracao, by = c("id_elsa", "onda")) |>
  left_join(df_pas, by = c("id_elsa", "onda")) |>
  left_join(df_pad, by = c("id_elsa", "onda")) |>
  mutate(
    diabetes = ifelse(!is.na(hba1c) & hba1c >= 6.5, 1, 0)
  )

write.csv(
  x = dados_long,
  file = "dados_long.csv",
  row.names = FALSE
)