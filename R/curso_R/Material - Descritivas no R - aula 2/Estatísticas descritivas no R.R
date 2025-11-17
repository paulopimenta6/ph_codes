# Carregamento dos pacotes
if(!require("pacman")) {install.packages("pacman")}
pacman::p_load(dplyr, rstatix, naniar, DescTools, table1, flextable)


# Leitura do banco de dados
dados <- read.csv2("FEV.csv", fileEncoding = "latin1",
                   stringsAsFactors = T)

glimpse(dados)


## Resumo das variáveis

summary(dados)


## Dados ausentes

summary(dados)

### Visualização dos dados ausentes (missing values)
# https://cran.r-project.org/web/packages/naniar/vignettes/naniar-visualisation.html
# https://rpubs.com/odenipinedo/dealing-with-missing-data-in-R

naniar::miss_var_summary(dados)

naniar::vis_miss(dados)


### Dados ausentes por grupo

dados |> 
  group_by(genero) |> 
  naniar::miss_var_summary()



# Frequências

## Uma variável categórica

table(dados$fumante)

100*prop.table(table(dados$fumante))


dados |> 
  group_by(fumante) |> 
  filter(!is.na(fumante)) |> 
  count() |> 
  ungroup() |> 
  mutate(prop = 100*n/sum(n))


## Tabela de referência cruzada (cross-tabs)

table(dados$fumante, dados$genero)

100*prop.table(table(dados$fumante, dados$genero), margin = 2)
# margin = 1: por linha
# margin = 2: por coluna


dados |> 
  filter(!is.na(fumante)) |> 
  group_by(fumante, genero) |> 
  count() |> 
  ungroup() |> 
  group_by(genero) |> 
  mutate(prop = 100*n/sum(n))




dados |> 
  filter(!is.na(fumante)) |> 
  group_by(fumante, genero, faixa_etaria) |> 
  count() |> 
  ungroup() |> 
  group_by(genero) |> 
  mutate(prop = 100*n/sum(n))



# Medidas de posição e dispersão

## Média
mean(dados$fev, na.rm = T)


## Mediana
median(dados$fev, na.rm = T)


## Moda
DescTools::Mode(dados$fev, na.rm = T)


## Quantis
quantile(dados$fev, na.rm = T, probs = c(0.01, 0.25, 0.5, 0.75, 0.99))


## Variância
var(dados$fev, na.rm = T)


## Desvio-padrão
sd(dados$fev, na.rm = T)



## Mínimo e Máximo
min(dados$fev, na.rm = T)
max(dados$fev, na.rm = T)


## Medidas resumo - Descrição completa
### mad = median absolute deviation (https://en.wikipedia.org/wiki/Average_absolute_deviation)

rstatix::get_summary_stats(dados, fev)

rstatix::get_summary_stats(dados) |> as.data.frame()

rstatix::get_summary_stats(dados, type = "mean_sd")

rstatix::get_summary_stats(dados, type = "median_iqr")



## Medidas resumo por grupo

dados |> 
  group_by(fumante) |> 
  filter(!is.na(fumante)) |> 
  rstatix::get_summary_stats(type = "mean_sd") |> 
  as.data.frame()




# Tabelas completas

table1::table1(~ ., data = dados)


# Modificações estéticas e salvar em Word

table1::table1(~ ., data = dados, overall = "Total",
               decimal.mark = ",") |> 
  table1::t1flex() |> 
  flextable::save_as_docx(path = "Descritiva geral.docx")



table1::table1(~ . | fumante,
               data = dados |> filter(!is.na(fumante)),
               overall = "Total",
               decimal.mark = ",") |> 
  table1::t1flex() |> 
  flextable::save_as_docx(path = "Descritiva por grupo.docx")

