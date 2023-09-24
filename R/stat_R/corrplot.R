library(readr)
library(tidyverse)
library(dplyr)

library(corrplot)

dir_dados="./dados_elsa/Lucia_Andrade_10_22_CSV.csv"
importaDadosLib=read_csv2(dir_dados)

pressaoArterialSistolicaMediaOnda1<-importaDadosLib$A_PSIS
pressaoArterialSistolicaMediaOnda2<-importaDadosLib$B_PSIS
pressaoArterialSistolicaMediaOnda3<-importaDadosLib$C_PSIS

#etfs <- sp500_px[row.names(sp500_px) > '2012-07-01', sp500_sym[sp500_sym$sector == 'etf', 'symbol']]
listHipert <- cbind(HipArt1 = presencaDeHipertensaoArterialSistemicaOnda1, HipArt2 = presencaDeHipertensaoArterialSistemicaOnda2, HipArt3 = presencaDeHipertensaoArterialSistemicaOnda3)
corr <- cor(listHipert, use = "pairwise.complete.obs")
corrplot(corr, method = 'number')