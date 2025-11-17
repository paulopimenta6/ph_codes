# Oi! Esse script foi adicionado para responder a uma pergunta: como contabilizar
# os valores ausentes quando a base é muito grande e o pacote naniar não funciona?

# Carregamento dos pacotes
if(!require("pacman")) {install.packages("pacman")}
pacman::p_load(dplyr, tidyr, tibble)


# Leitura do banco de dados
dados <- read.csv2("FEV.csv", fileEncoding = "latin1",
                   stringsAsFactors = T)

glimpse(dados)


## Contagem dos dados ausentes - Geral

dados |>
  summarise(across(everything(), ~sum(is.na(.x)))) |> 
  t() |> 
  as.data.frame() |> 
  tibble::rownames_to_column("Variável") |> 
  rename("n_ausentes" = "V1") |> 
  mutate(porc_ausentes = 100*n_ausentes/nrow(dados))


## Contagem dos dados ausentes por grupo

n_ausentes <- dados |>
  group_by(fumante) |> 
  summarise(across(everything(), ~sum(is.na(.x)))) |> 
  tidyr::pivot_longer(cols = -1, names_to = "Variável", values_to = "n_ausentes")

n_por_grupo <- dados |>
  group_by(fumante) |> 
  count()

tabela_ausentes_grupo <- dplyr::left_join(n_ausentes, n_por_grupo) |> 
  mutate(porc_ausentes = 100*n_ausentes/nrow(dados)) |> 
  select(-"n")

tabela_ausentes_grupo



