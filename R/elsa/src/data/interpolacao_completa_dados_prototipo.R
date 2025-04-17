if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(mice, VIM)
library(dplyr)
library(readr)
################################################################################
dir_dados="./dados_elsa/Lucia_Andrade_10_22_CSV.csv"
importaDadosLib <- readr::read_csv2(
  dir_dados,
  locale = locale(decimal_mark = ","), # Define vírgula como separador decimal
  na = c("", "NA")                     # Define valores ausentes
)
################################################################################
dfCompletosElsa <- as.data.frame(importaDadosLib)
dadosOnda2Mice_tmp_inp <- mice(dfCompletosElsa, method = "pmm", m = 5, seed = 123)

