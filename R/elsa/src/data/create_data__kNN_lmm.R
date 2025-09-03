if (!require(pacman)) install.packages("pacman")
library(pacman)

pacman::p_load(
  dplyr, tidyr, lme4, lmerTest, performance,
  ggeffects, sjPlot, car, bbmle
)

source("./src/data/data_kNN_v4.R")  # Verifique se 'data' está corretamente carregado)

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
  id_elsa = dadosOnda1kNN_inp$idElsa,
  hip_onda1 = dadosOnda1kNN_inp$hip,
  hip_onda2 = dadosOnda2kNN_inp$hip,
  hip_onda3 = dadosOnda3kNN_inp$hip
) |>
  to_long("hip", "hip") |>
  mutate(hip = as.factor(hip))

df_pot <- data.frame(
  id_elsa = dadosOnda1kNN_inp$idElsa,
  pot_onda1 = dadosOnda1kNN_inp$pot,
  pot_onda2 = dadosOnda2kNN_inp$pot,
  pot_onda3 = dadosOnda3kNN_inp$pot
) |> to_long("pot", "pot")

df_sod <- data.frame(
  id_elsa = dadosOnda1kNN_inp$idElsa,
  sod_onda1 = dadosOnda1kNN_inp$sod,
  sod_onda2 = dadosOnda2kNN_inp$sod,
  sod_onda3 = dadosOnda3kNN_inp$sod
) |> to_long("sod", "sod")

df_hba1c <- data.frame(
  id_elsa = dadosOnda1kNN_inp$idElsa,
  hba1c_onda1 = dadosOnda1kNN_inp$hba1c,
  hba1c_onda2 = dadosOnda2kNN_inp$hba1c,
  hba1c_onda3 = dadosOnda3kNN_inp$hba1c
) |> to_long("hba1c", "hba1c")

df_insulina <- data.frame(
  id_elsa = dadosOnda1kNN_inp$idElsa,
  insulina_onda1 = dadosOnda1kNN_inp$insulina,
  insulina_onda2 = dadosOnda2kNN_inp$insulina,
  insulina_onda3 = dadosOnda3kNN_inp$insulina
) |>
  to_long("insulina", "insulina") |>
  mutate(insulina = as.factor(insulina))

df_antidiabeticos <- data.frame(
  id_elsa = dadosOnda1kNN_inp$idElsa,
  antidiabeticos_onda1 = dadosOnda1kNN_inp$antidiabeticosOrais,
  antidiabeticos_onda2 = dadosOnda2kNN_inp$antidiabeticosOrais,
  antidiabeticos_onda3 = dadosOnda3kNN_inp$antidiabeticosOrais
) |>
  to_long("antidiabeticos", "antidiabeticos_orais") |>
  mutate(antidiabeticos_orais = as.factor(antidiabeticos_orais))

df_albcreat <- data.frame(
  id_elsa = dadosOnda1kNN_inp$idElsa,
  albcreat_onda1 = dadosOnda1kNN_inp$albCreat,
  albcreat_onda2 = dadosOnda2kNN_inp$albCreat,
  albcreat_onda3 = dadosOnda3kNN_inp$albCreat
) |> to_long("albcreat", "albcreat")

df_filtracao <- data.frame(
  id_elsa = dadosOnda1kNN_inp$idElsa,
  taxa_filt_onda1 = dadosOnda1kNN_inp$taxaFilt,
  taxa_filt_onda2 = dadosOnda2kNN_inp$taxaFilt,
  taxa_filt_onda3 = dadosOnda3kNN_inp$taxaFilt
) |> to_long("taxa_filt", "taxa_filt")

df_pas <- data.frame(
  id_elsa = dadosOnda1kNN_inp$idElsa,
  pas_onda1 = dadosOnda1kNN_inp$pas,
  pas_onda2 = dadosOnda2kNN_inp$pas,
  pas_onda3 = dadosOnda3kNN_inp$pas
) |> to_long("pas", "pas")

df_pad <- data.frame(
  id_elsa = dadosOnda1kNN_inp$idElsa,
  pad_onda1 = dadosOnda1kNN_inp$pad,
  pad_onda2 = dadosOnda2kNN_inp$pad,
  pad_onda3 = dadosOnda3kNN_inp$pad
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
    diabetes = ifelse(hba1c >= 6.5, 1, 0)
  )

write.csv(
  x = dados_long,
  file = "dados_long_kNN.csv",
  row.names = FALSE
)