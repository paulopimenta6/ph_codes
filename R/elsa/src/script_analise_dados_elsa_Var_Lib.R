############################################################################################
##############################Especificando diretorio src###################################
if (getwd() != "C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src") {   ##
  setwd("C:/Users/Paulo_Pimenta/Documents/meus_codigos/ph_codes/R/elsa/src")            ##  
}                                                                                         ##
############################################################################################
library(readr)
library(tidyverse)
library(dplyr)
library(ggplot2)
dir_dados="../dados_elsa/Lucia_Andrade_10_22_CSV.csv"

importaDadosLib=read_csv2(dir_dados, na = c("", "NA"))
#importaDadosLib=read_csv2(dir_dados)

###idade
idadeNaOnda1<-importaDadosLib$IDADEA
idadeNaOnda2<-importaDadosLib$IDADEB
idadeNaOnda3<-importaDadosLib$IDADEC

###Pressao sistolica 
pressaoArterialSistolicaMediaOnda1<-importaDadosLib$A_PSIS
pressaoArterialSistolicaMediaOnda2<-importaDadosLib$B_PSIS
pressaoArterialSistolicaMediaOnda3<-importaDadosLib$C_PSIS

###pressao diastolica
pressaoDiastolicamediaOnda1 <- importaDadosLib$A_PDIA
pressaoDiastolicamediaOnda2 <- importaDadosLib$B_PDIA
pressaoDiastolicamediaOnda3 <- importaDadosLib$C_PDIA

###hemoglobina glicada hba1c
hemoglobinaGlicadaHba1cOnda1<-importaDadosLib$LABA2_3
hemoglobinaGlicadaHba2cOnda2<-importaDadosLib$LABB2
hemoglobinaGlicadaHba3cOnda3<-importaDadosLib$LABC2

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

###uso de alcool
usoDeAlcoolOnda1<-importaDadosLib$A_USODEALCOOL
usoDeAlcoolOnda2<-importaDadosLib$B_USODEALCOOL
usoDeAlcoolOnda3<-importaDadosLib$DIEC139

###presença de hipertensao arterial sistemica
presencaDeHipertensaoArterialSistemicaOnda1<-importaDadosLib$A_HAS2_2
presencaDeHipertensaoArterialSistemicaOnda2<-importaDadosLib$B_HAS2_2
presencaDeHipertensaoArterialSistemicaOnda3<-importaDadosLib$C_HAS2

###toma anti-hipertensivos
tomaAntiHipertensivosOnda1<-importaDadosLib$A_ANTI_HIPERTENSIVOS
tomaAntiHipertensivosOnda2<-importaDadosLib$B_ANTI_HIPERTENSIVOS
tomaAntiHipertensivosOnda3<-importaDadosLib$C_ANTI_HIPERTENSIVOS

###imc com 6 categorias
imc6categoriasOnda1<-importaDadosLib$A_IMC3
imc6categoriasOnda2<-importaDadosLib$B_IMC3
imc6categoriasOnda3<-importaDadosLib$C_IMC3

###doença cardiovascular prevalente
doencaCardiovascularPrevaOnda1<-importaDadosLib$A_ECGMC_DCV_2
doencaCardiovascularPrevaOnda2<-importaDadosLib$B_ECGMC_DCV
doencaCardiovascularPrevaOnda3<-importaDadosLib$C_ECGMC_DCV

###infarto do miocardio
infartoDoMiocardioOnda1<-importaDadosLib$A_ECGMC_IM_2
infartoDoMiocardioOnda2<-importaDadosLib$B_ECGMC_IM
infartoDoMiocardioOnda3<-importaDadosLib$C_ECGMC_IM

###toma antidiabéticos orais
tomaAntidiabeticosOraisOnda1<-importaDadosLib$A_ANTIDIABETICOS_ORAIS
tomaAntidiabeticosOraisOnda2<-importaDadosLib$B_ANTIDIABETICOS_ORAIS
tomaAntidiabeticosOraisOnda3<-importaDadosLib$C_ANTIDIABETICOS_ORAIS

###faz uso contínuo de atorvastatina
fazUsoContinuoAtorvastatinaOnda1<-importaDadosLib$A_ATORVASTATINA
fazUsoContinuoAtorvastatinaOnda2<-importaDadosLib$B_ATORVASTATINA
fazUsoContinuoAtorvastatinaOnda3<-importaDadosLib$C_ATORVASTATINA

###faz uso contínuo de benazepril
fazUsoContinuoBenazeprilOnda1<-importaDadosLib$A_BENAZEPRIL
fazUsoContinuoBenazeprilOnda2<-importaDadosLib$B_BENAZEPRIL
fazUsoContinuoBenazeprilOnda3<-importaDadosLib$C_BENAZEPRIL

###faz uso contínuo de captopril
fazUsoContinuoCaptoprilOnda1<-importaDadosLib$A_CAPTOPRIL
fazUsoContinuoCaptoprilOnda2<-importaDadosLib$B_CAPTOPRIL
fazUsoContinuoCaptoprilOnda3<-importaDadosLib$C_CAPTOPRIL

###faz uso contínuo de celecoxibe
fazUsoContinuoCelecoxibeOnda1<-importaDadosLib$A_CELECOXIBE
fazUsoContinuoCelecoxibeOnda2<-importaDadosLib$B_CELECOXIBE
fazUsoContinuoCelecoxibeOnda3<-importaDadosLib$C_CELECOXIBE

###faz uso contínuo de cetoprofeno
fazUsoContinuoCetoprofenoOnda1<-importaDadosLib$A_CETOPROFENO
fazUsoContinuoCetoprofenoOnda2<-importaDadosLib$B_CETOPROFENO
fazUsoContinuoCetoprofenoOnda3<-importaDadosLib$C_CETOPROFENO

###faz uso contínuo de diclofenaco
fazUsoContinuoDiclofenacoOnda1<-importaDadosLib$A_DICLOFENACO
fazUsoContinuoDiclofenacoOnda2<-importaDadosLib$B_DICLOFENACO
fazUsoContinuoDiclofenacoOnda3<-importaDadosLib$C_DICLOFENACO

###faz uso contínuo de enalapril
fazUsoContinuoEnalaprilOnda1<-importaDadosLib$A_ENALAPRIL
fazUsoContinuoEnalaprilOnda2<-importaDadosLib$B_ENALAPRIL
fazUsoContinuoEnalaprilOnda3<-importaDadosLib$C_ENALAPRIL

###faz uso contínuo de glibenclamida
fazUsoContinuoGlibenclamidaOnda1<-importaDadosLib$A_GLIBENCLAMIDA
fazUsoContinuoGlibenclamidaOnda2<-importaDadosLib$B_GLIBENCLAMIDA
fazUsoContinuoGlibenclamidaOnda3<-importaDadosLib$C_GLIBENCLAMIDA

###faz uso contínuo de gliclazida
fazUsoContinuoGliclazidaOnda1<-importaDadosLib$A_GLICLAZIDA
fazUsoContinuoGliclazidaOnda2<-importaDadosLib$B_GLICLAZIDA
fazUsoContinuoGliclazidaOnda3<-importaDadosLib$C_GLICLAZIDA

###faz uso contínuo de glimepirida
fazUsoContinuoGlimepiridaOnda1<-importaDadosLib$A_GLIMEPIRIDA
fazUsoContinuoGlimepiridaOnda2<-importaDadosLib$B_GLIMEPIRIDA 
fazUsoContinuoGlimepiridaOnda3<-importaDadosLib$C_GLIMEPIRIDA

###faz uso de hipolipemiantes
fazUsoHipolipemiantesOnda1<-importaDadosLib$A_HIPOLIPEMIANTES
fazUsoHipolipemiantesOnda2<-importaDadosLib$B_HIPOLIPEMIANTES
fazUsoHipolipemiantesOnda3<-importaDadosLib$C_HIPOLIPEMIANTES


###faz uso de anti-hipertensivo inibidores da eca
fazUsoInibidoresEcaOnda1<-importaDadosLib$A_I_ECA
fazUsoInibidoresEcaOnda2<-importaDadosLib$B_AH_INIBIDORES_DA_ECA
fazUsoInibidoresEcaOnda3<-importaDadosLib$C_AH_INIBIDORES_DA_ECA

###faz uso contínuo de ibuprofeno
fazUsoContinuoIbuprofenoOnda1<-importaDadosLib$A_IBUPROFENO
fazUsoContinuoIbuprofenoOnda2<-importaDadosLib$B_IBUPROFENO
fazUsoContinuoIbuprofenoOnda3<-importaDadosLib$C_IBUPROFENO

###faz uso contínuo de indometacina
fazUsoContinuoIndometacinaOnda1<-importaDadosLib$A_INDOMETACINA
fazUsoContinuoIndometacinaOnda2<-importaDadosLib$B_INDOMETACINA
fazUsoContinuoIndometacinaOnda3<-importaDadosLib$C_INDOMETACINA

###faz uso contínuo de insulina
fazUsoContinuoInsulinaONda1<-importaDadosLib$A_INSULINA
fazUsoContinuoInsulinaONda2<-importaDadosLib$B_INSULINA_REGULAR
fazUsoContinuoInsulinaONda3<-importaDadosLib$C_INSULINA

###faz uso contínuo de lisinopril
fazUsoContinuoLisinoprilOnda1<-importaDadosLib$A_LISINOPRIL
fazUsoContinuoLisinoprilOnda2<-importaDadosLib$B_LISINOPRIL
fazUsoContinuoLisinoprilOnda3<-importaDadosLib$C_LISINOPRIL

###faz uso contínuo de losartana
fazUsoContinuoLosartanaOnda1<-importaDadosLib$A_LOSARTANA
fazUsoContinuoLosartanaOnda2<-importaDadosLib$B_LOSARTANA
fazUsoContinuoLosartanaOnda3<-importaDadosLib$C_LOSARTANA

###faz uso contínuo de meloxicam
fazUsoContinuoMeloxicamOnda1<-importaDadosLib$A_MELOXICAM
fazUsoContinuoMeloxicamOnda2<-importaDadosLib$B_MELOXICAM
fazUsoContinuoMeloxicamOnda3<-importaDadosLib$C_MELOXICAM

###faz uso contínuo de naproxeno
fazUsoContinuoNaproxenoOnda1<-importaDadosLib$A_NAPROXENO
fazUsoContinuoNaproxenoOnda2<-importaDadosLib$B_NAPROXENO
fazUspContinuoNaproxenoOnda3<-importaDadosLib$C_NAPROXENO

###faz uso contínuo de nimesulida
fazUsoContinuoNimesulidaOnda1<-importaDadosLib$A_NIMESULIDA
fazUsoContinuoNimesulidaOnda2<-importaDadosLib$B_NIMESULIDA
fazUsoContinuoNimesulidaOnda3<-importaDadosLib$C_NIMESULIDA

###faz uso esporádico de cetorolaco
fazUsoEsporadicoCetorolacoOnda1<-importaDadosLib$FAZ_USO_ESPORADICO_DE_CETOROLACO
fazUsoEsporadicoCetorolacoOnda2<-importaDadosLib$B_CETOROLACO
fazUsoEsporadicoCetorolacoOnda3<-importaDadosLib$C_CETOROLACO

###faz uso de hipolipemiantes estatinas
fazUsoHipolipemiantesEstatinasOnda2<-importaDadosLib$B_HLP_ESTATINAS
fazUsoHipolipemiantesEstatinasOnda3<-importaDadosLib$C_HLP_ESTATINAS

###faz uso contínuo de metformina
fazUsoContinuoMetforminaOnda1<-importaDadosLib$A_METFORMINA
fazUsoContinuoMetforminaOnda2<-importaDadosLib$B_METFORMINA
fazUsoContinuoMetforminaOnda3<-importaDadosLib$C_METFORMINA

###faz uso contínuo de valsartana
fazUsoContinuoValsartanaOnda1<-importaDadosLib$A_VALSARTANA
fazUsoContinuoValsartanaOnda2<-importaDadosLib$B_VALSARTANA
fazUsoContinuoValsartanaOnda3<-importaDadosLib$C_VALSARTANA

###razao albumina-creatinina rastreável (mg/g)
razaoAlbuminaCreatininaRastreávelOnda1<-importaDadosLib$A_RAC_R_2
razaoAlbuminaCreatininaRastreávelOnda1<-importaDadosLib$B_RAC_2

###taxa filtração glomerular com creatinina ajustada
categoriasTaxaFiltracaoGlomerularComCalibracaoOnda1<-importaDadosLib$A_CKDEPI_R_CAT_2
categoriasTaxaFiltracaoGlomerularComCalibracaoOnda2<-importaDadosLib$B_CKDEPI_R_CAT

###categorias taxa filtração glomerular com calibração
categoriasTaxaFiltracaoGlomerularComCalibracaoOnda1<-importaDadosLib$A_CKDEPI_R_3
categoriasTaxaFiltracaoGlomerularComCalibracaoOnda2<-importaDadosLib$B_CKDEPI_R_2

###microalbuminúria (mcg/min)
microalbuminuriaMInOnda1<-importaDadosLib$A_LABA19MCGMIN
microalbuminuriaMInOnda2<-importaDadosLib$B_LABB19MCGMIN