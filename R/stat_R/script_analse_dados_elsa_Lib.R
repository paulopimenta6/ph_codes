library(readr)
library(tidyverse)
library(dplyr)

dir_dados="./dados_elsa/Lucia_Andrade_10_22_CSV.csv"

#importaDadosLib=read_csv2(dir_dados, na = c("", "NA"))
importaDadosLib=read_csv2(dir_dados)

###idade
idadeNaOnda1<-importaDadosLib$IDADEA
idadeNaOnda2<-importaDadosLib$IDADEB
idadeNaOnda3<-importaDadosLib$IDADEC

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

###uso de alcool
usoDeAldoolOnda1<-importaDadosLib$A_USODEALCOOL
usoDeAldoolOnda2<-importaDadosLib$B_USODEALCOOL
usoDeAldoolOnda3<-importaDadosLib$DIEC139

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


#############################################################################################################################
###fazendo alguns graficos
###metodos quantitativos
ggplot(importaDadosLib, aes(x=((idadeNaOnda1)))) + geom_bar() + xlab("idades na onda 1") + ylab("Quantidade de pacientes")
ggplot(importaDadosLib, aes(x=((idadeNaOnda2)))) + geom_bar() + xlab("idades na onda 2") + ylab("Quantidade de pacientes")
ggplot(importaDadosLib, aes(x=((idadeNaOnda3)))) + geom_bar() + xlab("idades na onda 3") + ylab("Quantidade de pacientes")

ggplot(importaDadosLib, aes(x=(habitoDeFumarOnda1))) + geom_bar() + xlab("Pacientes com habito de fumar na Onda 1 - 0: nunca fumou, 1: ex-fumante e 2: fumante") + ylab("Quantidade da amostra na Onda 1")
ggplot(importaDadosLib, aes(x=(habitoDeFumarOnda2))) + geom_bar() + xlab("Pacientes com habito de fumar na Onda 2 - 0: nunca fumou, 1: ex-fumante e 2: fumante") + ylab("Quantidade da amostra na Onda 2")
ggplot(importaDadosLib, aes(x=(habitoDeFumarOnda3))) + geom_bar() + xlab("Pacientes com habito de fumar na Onda 3 - 0: nunca fumou, 3: ex-fumante e 2: fumante") + ylab("Quantidade da amostra na Onda 3")

barplot(table(microalbuminuriaOnda1), xlab = "Concentração em (mg/dl)", ylab = "Micro Albuminuria na onda 1") 
barplot(table(microalbuminuriaOnda2), xlab = "Concentração em (mg/dl)", ylab = "Micro Albuminuria na onda 2") 

ggplot(importaDadosLib, aes(y=microalbuminuriaOnda1, x=idadeNaOnda1)) + geom_point() + xlab("Idade na onda 1") + ylab("microalbuminuria  - mcg/min")

#############################################################################################################################
#criando data frame e removendo outlier:
#removendo os outliers da microalbuminuria:
df <- data.frame(microalbuminuria = microalbuminuriaMInOnda2[-973], idadeNaOnda = idadeNaOnda2[-973])
df <- data.frame(microalbuminuria = df$microalbuminuria[-191], idadeNaOnda = df$idadeNaOnda[-191])
ggplot(df, aes(y=microalbuminuria, x=idadeNaOnda)) + geom_point() + xlab("Idade na onda 2") + ylab("microalbuminuria (mcg/min)")
#############################################################################################################################

barplot(table(categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1), xlab = "Categorias taxa filtração glomerular com calibração - onda 1 \n 1 - Maior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15", ylab = "Quantidade")
barplot(table(categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2), xlab = "Categorias taxa filtração glomerular com calibração - onda 2 \n 1 - Maior ou igual a 90, 2 - Entre 60 e 90, 3 - Entre 45 e 60, 4 - Entre 30 e 45, 5 - Entre 15 e 30, 6 - Menor do que 15", ylab = "Quantidade")

ggplot(importaDadosLib, aes(y=hemoglobinaGlicadaHba1cOnda1, x=idadeNaOnda1)) + geom_point() + xlab("Idade na onda 1") + ylab("hemoglobina glicada hba1c (%) - onda 1")
ggplot(importaDadosLib, aes(y=hemoglobinaGlicadaHba1cOnda2, x=idadeNaOnda2)) + geom_point() + xlab("Idade na onda 2") + ylab("hemoglobina glicada hba1c (%) - onda 2")
ggplot(importaDadosLib, aes(y=hemoglobinaGlicadaHba1cOnda3, x=idadeNaOnda3)) + geom_point() + xlab("Idade na onda 3") + ylab("hemoglobina glicada hba1c (%) - onda 3")

ggplot(importaDadosLib, aes(y=colesterolHdlOnda1, x=idadeNaOnda1)) + geom_point() + xlab("Idade na onda 1") + ylab("colesterol hdl (mg/dl) - onda 1")
ggplot(importaDadosLib, aes(y=colesterolHdlOnda2, x=idadeNaOnda2)) + geom_point() + xlab("Idade na onda 2") + ylab("colesterol hdl (mg/dl) - onda 2")
ggplot(importaDadosLib, aes(y=colesterolHdlOnda3, x=idadeNaOnda3)) + geom_point() + xlab("Idade na onda 3") + ylab("colesterol hdl (mg/dl) - onda 3")

ggplot(importaDadosLib, aes(pressaoDiastolicameiaOnda1)) + geom_bar(aes(fill=as.factor(idadeNaOnda1))) + labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "pressão arterial diastólica média (mmhg) - onda 1")
ggplot(importaDadosLib, aes(pressaoDiastolicameiaOnda2)) + geom_bar(aes(fill=as.factor(idadeNaOnda2))) + labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "pressão arterial diastólica média (mmhg) - onda 2")
ggplot(importaDadosLib, aes(pressaoDiastolicameiaOnda3)) + geom_bar(aes(fill=as.factor(idadeNaOnda3))) + labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "pressão arterial diastólica média (mmhg) - onda 3")

ggplot(importaDadosLib, aes(pressaoArterialSistolicaMediaOnda1)) + geom_bar(aes(fill=as.factor(idadeNaOnda1))) + labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "pressão arterial sistólica média (mmhg) - onda 1")
ggplot(importaDadosLib, aes(pressaoArterialSistolicaMediaOnda2)) + geom_bar(aes(fill=as.factor(idadeNaOnda2))) + labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "pressão arterial sistólica média (mmhg) - onda 2")
ggplot(importaDadosLib, aes(pressaoArterialSistolicaMediaOnda3)) + geom_bar(aes(fill=as.factor(idadeNaOnda3))) + labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "pressão arterial sistólica média (mmhg) - onda 3")

ggplot(importaDadosLib, aes(hemoglobinaGlicadaHba1cOnda1)) + geom_bar(aes(fill=as.factor(idadeNaOnda1))) + labs(fill = "Idade na onda 1", y = "Quantidade de pessoas na onda 1", x = "Hemoglobina Glicada Hba1 (%) - onda 1")
ggplot(importaDadosLib, aes(hemoglobinaGlicadaHba1cOnda2)) + geom_bar(aes(fill=as.factor(idadeNaOnda2))) + labs(fill = "Idade na onda 2", y = "Quantidade de pessoas na onda 2", x = "Hemoglobina Glicada Hba1 (%) - onda 2")
ggplot(importaDadosLib, aes(hemoglobinaGlicadaHba1cOnda3)) + geom_bar(aes(fill=as.factor(idadeNaOnda3))) + labs(fill = "Idade na onda 3", y = "Quantidade de pessoas na onda 3", x = "Hemoglobina Glicada Hba1 (%) - onda 3")

########
ggplot(importaDadosLib, aes(hemoglobinaGlicadaHba1cOnda1)) + geom_bar(aes(fill=as.factor(colesterolHdlOnda1))) + labs(fill = "Colesterol Hdl na onda 1", y = "Quantidade de pessoas na onda 1", x = "Hemoglobina Glicada Hba1 (%) - onda 1") + theme(legend.key.size = unit(0.2, 'cm'))
ggplot(importaDadosLib, aes(hemoglobinaGlicadaHba1cOnda2)) + geom_bar(aes(fill=as.factor(colesterolHdlOnda2))) + labs(fill = "Colesterol Hdl na onda 2", y = "Quantidade de pessoas na onda 2", x = "Hemoglobina Glicada Hba1 (%) - onda 2") + theme(legend.key.size = unit(0.2, 'cm'))
ggplot(importaDadosLib, aes(hemoglobinaGlicadaHba1cOnda3)) + geom_bar(aes(fill=as.factor(colesterolHdlOnda3))) + labs(fill = "Colesterol Hdl na onda 3", y = "Quantidade de pessoas na onda 3", x = "Hemoglobina Glicada Hba1 (%) - onda 3") + theme(legend.key.size = unit(0.2, 'cm'))
###consertar aqui...
ggplot(importaDadosLib, aes(colesterolHdlOnda1)) + geom_bar(aes(fill=as.factor(habitoDeFumarOnda1))) + labs(x = "Colesterol na onda 1", y = "Quantidade de pessoas na onda 1", fill = "Habito de fumar - onda 1")
ggplot(importaDadosLib, aes(colesterolHdlOnda2)) + geom_bar(aes(fill=as.factor(habitoDeFumarOnda2))) + labs(x = "Colesterol na onda 2", y = "Quantidade de pessoas na onda 2", fill = "Habito de fumar - onda 2")
ggplot(importaDadosLib, aes(colesterolHdlOnda3)) + geom_bar(aes(fill=as.factor(habitoDeFumarOnda3))) + labs(x = "Colesterol na onda 3", y = "Quantidade de pessoas na onda 3", fill = "Habito de fumar - onda 3")

ggplot(importaDadosLib, aes(hemoglobinaGlicadaHba1cOnda1)) + geom_bar(aes(fill=as.factor(habitoDeFumarOnda1))) + labs(x = "Hemoglobina Glicada Hba1c Onda 1", y = "Quantidade de pessoas na onda 1", fill = "Habito de fumar - onda 1")
ggplot(importaDadosLib, aes(hemoglobinaGlicadaHba1cOnda2)) + geom_bar(aes(fill=as.factor(habitoDeFumarOnda2))) + labs(x = "Hemoglobina Glicada Hba1c Onda 3", y = "Quantidade de pessoas na onda 2", fill = "Habito de fumar - onda 2")
ggplot(importaDadosLib, aes(hemoglobinaGlicadaHba1cOnda3)) + geom_bar(aes(fill=as.factor(habitoDeFumarOnda3))) + labs(x = "Hemoglobina Glicada Hba1c Onda 3", y = "Quantidade de pessoas na onda 3", fill = "Habito de fumar - onda 3")
########

###
pontos_corte <- c(0, 1, 5, 20, 50, 100, Inf)
intervalos <- cut(microalbuminuriaMInOnda1, breaks = pontos_corte)
# Crie o gráfico usando os intervalos definidos automaticamente
ggplot(importaDadosLib, aes(x = creatininaRastreavelNoSangueOnda1)) + 
  geom_bar(aes(fill=as.factor(intervalos))) +
  labs(x = "Creatinina Rastreavel no Sangue (mg/dl) - Onda 1",
       y = "Quantidade de pessoas - Onda 1",
       fill = "Microalbuminuria (mcg/Min) - Onda 1")
###
pontos_corte <- c(0, 5, 10, 20, 50, 100, Inf)
intervalos <- cut(microalbuminuriaMInOnda2, breaks = pontos_corte)
# Crie o gráfico usando os intervalos definidos automaticamente
ggplot(importaDadosLib, aes(x = creatininaRastreavelNoSangueOnda2)) + 
  geom_bar(aes(fill=as.factor(intervalos))) +
  labs(x = "Creatinina Rastreavel no Sangue (mg/dl) - Onda 2",
       y = "Quantidade de pessoas - Onda 2",
       fill = "Microalbuminuria (mcg/Min) - Onda 2")
###

#############################################################################################################################
plot(colesterolHdlOnda1, colesterolHdlOnda2, col="black", xlab = "Colesterol hdl - Onda 1", ylab = "Colesterol hdl - Onda 2", pch=20)



