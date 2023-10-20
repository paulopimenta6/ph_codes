library(readr)
library(tidyverse)
library(dplyr)

library(corrplot)

dir_dados="./dados_elsa/Lucia_Andrade_10_22_CSV.csv"
importaDadosLib=read_csv2(dir_dados)


################################################################
###################Variaveis Medicas############################
###Pressao sistolica 
pressaoArterialSistolicaMediaOnda1<-importaDadosLib$A_PSIS
pressaoArterialSistolicaMediaOnda2<-importaDadosLib$B_PSIS
pressaoArterialSistolicaMediaOnda3<-importaDadosLib$C_PSIS

###pressao diastolica
pressaoDiastolicameiaOnda1 <- importaDadosLib$A_PDIA
pressaoDiastolicameiaOnda2 <- importaDadosLib$B_PDIA
pressaoDiastolicameiaOnda3 <- importaDadosLib$C_PDIA

###hemoglobina glicada hba1c
hemoglobinaGlicadaHba1cOnda1<-importaDadosLib$LABA2_3
hemoglobinaGlicadaHba1cOnda2<-importaDadosLib$LABB2
hemoglobinaGlicadaHba1cOnda3<-importaDadosLib$LABC2

###habito de fumar
habitoDeFumarOnda1<-importaDadosLib$A_FUMANTE
habitoDeFumarOnda2<-importaDadosLib$B_FUMANTE
habitoDeFumarOnda3<-importaDadosLib$C_FUMANTE

###creatinina rastreavel no sangue
creatininaRastreavelNoSangueOnda1<-importaDadosLib$LABA3_R_3
creatininaRastreavelNoSangueOnda2<-importaDadosLib$LABB3_R_2
creatininaRastreavelNoSangueOnda3<-importaDadosLib$LABC3

###creatinina rastreavel na urina
creatininaRastreavelNaUrinaOnda1<-importaDadosLib$LABA16_R_2
creatininaRastreavelNaUrinaOnda2<-importaDadosLib$LABB16_R
creatininaRastreavelNaUrinaOnda3<-importaDadosLib$LABC16

###razao albumina-creatinina rastreavel
razaoAlbuminaCreatininaRastreavelOnda1<-importaDadosLib$A_RAC_R_2
razaoAlbuminaCreatininaRastreavelOnda2<-importaDadosLib$B_RAC_2

###microalbuminúria
microalbuminuriaOnda1<-importaDadosLib$A_LABA19MGDL
microalbuminuriaOnda2<-importaDadosLib$B_LABB19MGDL

###albuminuria isolada
albuminuriaIsoladaOnda3<-importaDadosLib$LABC19

###sodio - urina
sodioUrinaOnda1<-importaDadosLib$A_LABA17
sodioUrinaOnda2<-importaDadosLib$B_LABB17
sodioUrinaOnda3<-importaDadosLib$LABC17

###potassio
potassioOnda1<-importaDadosLib$A_LABA18
potassioOnda2<-importaDadosLib$B_LABB18
potassioOnda3<-importaDadosLib$LABC18

###categorias taxa filtração glomerular com calibração
categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1<-importaDadosLib$A_CKDEPI_R_CAT_2
categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2<-importaDadosLib$B_CKDEPI_R_CAT

###colesterol total
colesterolTotalOnda1<-importaDadosLib$LABA10_3
colesterolTotalOnda2<-importaDadosLib$LABB10
colesterolTotalOnda3<-importaDadosLib$LABC10

###colesterol hdl
colesterolHdlOnda1<-importaDadosLib$LABA12_3
colesterolHdlOnda2<-importaDadosLib$LABB12
colesterolHdlOnda3<-importaDadosLib$LABC12

##colesterol ldl
colesterolLdlOnda1<-importaDadosLib$LABA13_3
colesterolLdlOnda2<-importaDadosLib$LABB13
colesterolLdlOnda3<-importaDadosLib$LABC13
################################################################
################################################################

listHipertSist <- cbind(HipArt1 = presencaDeHipertensaoArterialSistemicaOnda1, HipArt2 = presencaDeHipertensaoArterialSistemicaOnda2, HipArt3 = presencaDeHipertensaoArterialSistemicaOnda3)
listColesterol <- cbind(colesterolHdlOnda1, colesterolHdlOnda2, colesterolHdlOnda3, colesterolLdlOnda1, colesterolLdlOnda2, colesterolLdlOnda3)



corrHipertSist <- cor(listHipertSist, use = "pairwise.complete.obs")
corrColesterol <- cor(listColesterol, use = "pairwise.complete.obs")

corrplot(corrHipertSist, method = 'number')
corrplot(corrColesterol,
         method = "number",
         col = colorRampPalette(c("blue", "green", "red"))(100), # Exemplo de paleta de cores personalizada
         main = "\n\nMapa de Calor de Correlação")