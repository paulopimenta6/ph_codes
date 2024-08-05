if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, ggplot2, VIM, nortest, lmtest, car, rstatix, ggpmisc, corrplot, corrplot, knitr)
source("./src/script_analise_dados_elsa_Var_Lib.R")
################################################################################
statLinCorrAnalysis <- function(data){
    print("################################################################################")
    print("##Normalidade dos residuos:")
    print(ad.test(data$residuals))    
    print("##Outliers nos residuos:")
    print(summary(rstandard(data))) 
    print("##Independencia dos residuos (Durbin-Watson):")
    print(durbinWatsonTest(data))  
    print("##Homocedasticidade (Breusch-Pagan):")
    print(bptest(data))             
    print("###Analise do modelo")
    print(summary(data))
    print("################################################################################")
}
################################################################################
###Variaveis de referencia e tambem variaveis independentes (VI)
dfPotassio <- data.frame(onda1 = potassioOnda1,
                         onda2 = potassioOnda2,
                         onda3 = potassioOnda3
                         )

dfSodio <- data.frame(onda1 = sodioUrinaOnda1,
                      onda2 = sodioUrinaOnda2,
                      onda3 = sodioUrinaOnda3
                      )
################################################################################
##Variaveis a serem analisadas ou variaveis dependentes
dfRazaoAlbuminaCreatinina <- data.frame(onda1 = razaoAlbuminaCreatininaRastreavelOnda1,
                                        onda2 = razaoAlbuminaCreatininaRastreavelOnda2
                                        )
dfTaxaFiltracaoGlomerular <- data.frame(onda1 = categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda1,
                                        onda2 = categoriasTaxaFiltracaoGlomerulaComCalibracaoOnda2
                                        )
dfPAS <- data.frame(onda1 = pressaoArterialSistolicaMediaOnda1,
                    onda2 = pressaoArterialSistolicaMediaOnda2,
                    onda3 = pressaoArterialSistolicaMediaOnda3
                    )

dfPAD <- data.frame(onda1 = pressaoDiastolicamediaOnda1,
                    onda2 = pressaoDiastolicamediaOnda2,
                    onda3 = pressaoDiastolicamediaOnda3
                    )

dfPresencaHipertensaoSistem <- data.frame(onda1 = presencaDeHipertensaoArterialSistemicaOnda1,
                                          onda2 = presencaDeHipertensaoArterialSistemicaOnda2,
                                          onda3 = presencaDeHipertensaoArterialSistemicaOnda3
                                          )
################################################################################
###Interpolacao pelo metodo do KNN das variaveis que eventualmente estao faltantes
###Variaveis Independentes
pot_interp <- kNN(dfPotassio, k=5)
pot_interp <- pot_interp[,-c(4:ncol(pot_interp))]

sodio_interp <- kNN(dfSodio, k=5)
sodio_interp <- sodio_interp[,-c(4:ncol(sodio_interp))]
################################################################################
###Variaveis Dependentes
razaoAlbuCreat_interp <- kNN(dfRazaoAlbuminaCreatinina, k = 5) 
razaoAlbuCreat_interp <- razaoAlbuCreat_interp[, -c(3:ncol(razaoAlbuCreat_interp))]

PAS_interp <- kNN(dfPAS, k = 5)
PAS_interp <- PAS_interp[, -c(4,ncol(PAS_interp))]

PAD_interp <- kNN(dfPAD, k = 5)
PAD_interp <- PAD_interp[,-c(4:ncol(PAD_interp))]

#Variavel_ordinal
taxaFiltracaoGlomerular_interp <- kNN(dfTaxaFiltracaoGlomerular, k = 5) 
taxaFiltracaoGlomerular_interp <- taxaFiltracaoGlomerular_interp[, -c(3:ncol(taxaFiltracaoGlomerular_interp))]

#variavel_binaria
presencaHipertensaoSistem_interp <- kNN(dfPresencaHipertensaoSistem, k = 5)
presencaHipertensaoSistem_interp <- presencaHipertensaoSistem_interp[,-c(4,ncol(presencaHipertensaoSistem_interp))]

###Exemplo de rotulacao de fatores
###presencaHipertensaoSistem_interp$onda1 <- factor(presencaHipertensaoSistem_interp$onda1, levels = c(0,1), labels= c("Nao", "Sim"))

################################################################################
###VD: y -> razaoAlbuCreat_interp
###VI: x -> pot_interp
###Potassio
# plot(pot_interp$onda1, razaoAlbuCreat_interp$onda1, main = "Onda 1", xlab = "Concentracao de Potassio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")
# plot(pot_interp$onda2, razaoAlbuCreat_interp$onda2, main = "Onda 2", xlab = "Concentracao de Potassio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")
# 
# plot(pot_interp$onda1, PAS_interp$onda1, main = "Onda 1", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
# plot(pot_interp$onda2, PAS_interp$onda2, main = "Onda 2", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
# plot(pot_interp$onda3, PAS_interp$onda3, main = "Onda 3", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
# 
# plot(pot_interp$onda1, PAD_interp$onda1, main = "Onda 1", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
# plot(pot_interp$onda2, PAD_interp$onda2, main = "Onda 2", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
# plot(pot_interp$onda3, PAD_interp$onda3, main = "Onda 3", xlab = "Concentracao de Potassio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
# 
# ###Sodio
# plot(sodio_interp$onda1, razaoAlbuCreat_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")
# plot(sodio_interp$onda2, razaoAlbuCreat_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", ylab = "Razao albumina-creatinina (mg/g)")
# 
# plot(sodio_interp$onda1, PAS_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
# plot(sodio_interp$onda2, PAS_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
# plot(sodio_interp$onda3, PAS_interp$onda3, main = "Onda 3", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Sistolica (mmhg)")
# 
# plot(sodio_interp$onda1, PAD_interp$onda1, main = "Onda 1", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
# plot(sodio_interp$onda2, PAD_interp$onda2, main = "Onda 2", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")
# plot(sodio_interp$onda3, PAD_interp$onda3, main = "Onda 3", xlab = "Concentracao de Sodio (meq/l)", ylab = "Pressão Arterial Diastolica (mmhg)")

################################################################################
###Analises para verificar normalidade via modelo linear e analise grafica
###Potassio
# mod_PotRazaoAlbumCreat1 <- lm(razaoAlbuCreat_interp$onda1 ~ pot_interp$onda1) 
# mod_PotRazaoAlbumCreat2 <- lm(razaoAlbuCreat_interp$onda2 ~ pot_interp$onda2)
# 
# mod_PotPAS1 <- lm(PAS_interp$onda1 ~ pot_interp$onda1) 
# mod_PotPAS2 <- lm(PAS_interp$onda2 ~ pot_interp$onda2)
# mod_PotPAS3 <- lm(PAS_interp$onda3 ~ pot_interp$onda3)
# 
# mod_PotPAD1 <- lm(PAD_interp$onda1 ~ pot_interp$onda1) 
# mod_PotPAD2 <- lm(PAD_interp$onda2 ~ pot_interp$onda2)
# mod_PotPAD3 <- lm(PAD_interp$onda3 ~ pot_interp$onda3)
# 
# lmModPotassio <- list(mod_PotRazaoAlbumCreat1, mod_PotRazaoAlbumCreat2, 
#                 mod_PotPAS1, mod_PotPAS2, mod_PotPAS3,
#                 mod_PotPAD1, mod_PotPAD2, mod_PotPAD3)
# ################################################################################
# ###Sodio
# mod_SodRazaoAlbumCreat1 <- lm(razaoAlbuCreat_interp$onda1 ~ sodio_interp$onda1) 
# mod_SodRazaoAlbumCreat2 <- lm(razaoAlbuCreat_interp$onda2 ~ sodio_interp$onda2)
# 
# mod_SodPAS1 <- lm(PAS_interp$onda1 ~ sodio_interp$onda1) 
# mod_SodPAS2 <- lm(PAS_interp$onda2 ~ sodio_interp$onda2)
# mod_SodPAS3 <- lm(PAS_interp$onda3 ~ sodio_interp$onda3)
# 
# mod_SodPAD1 <- lm(PAD_interp$onda1 ~ sodio_interp$onda1) 
# mod_SodPAD2 <- lm(PAD_interp$onda2 ~ sodio_interp$onda2)
# mod_SodPAD3 <- lm(PAD_interp$onda3 ~ sodio_interp$onda3)
# 
# lmModSodio <- list(mod_SodRazaoAlbumCreat1, mod_SodRazaoAlbumCreat2, 
#                 mod_SodPAS1, mod_SodPAS2, mod_SodPAS3,
#                 mod_SodPAD1, mod_SodPAD2, mod_SodPAD3)
# ################################################################################
# ###Potassio
# par(mfrow = c(2,2))
# plot(mod_PotRazaoAlbumCreat1, main = "Onda 1 - Potassio x Razao albumina-creatinina")
# plot(mod_PotRazaoAlbumCreat2, main = "Onda 2 - Potassio x Razao albumina-creatinina")
# 
# plot(mod_PotPAS1, main = "Onda 1 - Potassio X PAS")
# plot(mod_PotPAS2, main = "Onda 2 - Potassio X PAS")
# plot(mod_PotPAS3, main = "Onda 3 - Potassio X PAS")
# 
# plot(mod_PotPAD1, main = "Onda 1 - Potassio X PAD")
# plot(mod_PotPAD2, main = "Onda 2 - Potassio X PAD")
# plot(mod_PotPAD3, main = "Onda 3 - Potassio X PAD")
# ###Sodio
# plot(mod_SodRazaoAlbumCreat1, main = "Onda 1 - Sodio x Razao albumina-creatinina")
# plot(mod_SodRazaoAlbumCreat2, main = "Onda 2 - Sodio x Razao albumina-creatinina")
# 
# plot(mod_SodPAS1, main = "Onda 1 - Sodio X PAS")
# plot(mod_SodPAS2, main = "Onda 2 - Sodio X PAS")
# plot(mod_SodPAS3, main = "Onda 3 - Sodio X PAS")
# 
# plot(mod_SodPAD1, main = "Onda 1 - Sodio X PAD")
# plot(mod_SodPAD2, main = "Onda 2 - Sodio X PAD")
# plot(mod_SodPAD3, main = "Onda 3 - Sodio X PAD")
# ################################################################################
# ###Realizando os testes teoricos
# par(mfrow=c(1,1))
# ###Potassio
# for(i in lmModPotassio){
#   statLinCorrAnalysis(i)
# }
# ###Sodio
# for(i in lmModSodio){
#   statLinCorrAnalysis(i)
# }

################################################################################
### Potassio
###Correlacoes de Spearman e Kendall
##Correlacao de Postos de Spearman (coeficiente = ro)
corSpePotRazaoAlbuCreatOnda1 <- cor.test(pot_interp$onda1, razaoAlbuCreat_interp$onda1, method = "spearman")
corSpePotRazaoAlbuCreatOnda2 <- cor.test(pot_interp$onda2, razaoAlbuCreat_interp$onda2, method = "spearman")

corSpePotPASOnda1 <- cor.test(pot_interp$onda1, PAS_interp$onda1, method = "spearman")
corSpePotPASOnda2 <- cor.test(pot_interp$onda2, PAS_interp$onda2, method = "spearman")
corSpePotPASOnda3 <- cor.test(pot_interp$onda3, PAS_interp$onda3, method = "spearman")

corSpePotPADOnda1 <- cor.test(pot_interp$onda1, PAD_interp$onda3, method = "spearman")
corSpePotPADOnda2 <- cor.test(pot_interp$onda2, PAD_interp$onda3, method = "spearman")
corSpePotPADOnda3 <- cor.test(pot_interp$onda3, PAD_interp$onda3, method = "spearman")

##Correlacao Tau de Kendall (coeficiente = tau):
corKenPotRazaoAlbuCreatOnda1 <- cor.test(pot_interp$onda1, razaoAlbuCreat_interp$onda1, method = "kendall")
corKenPotRazaoAlbuCreatOnda2 <- cor.test(pot_interp$onda2, razaoAlbuCreat_interp$onda2, method = "kendall")

corKenPotPASOnda1 <- cor.test(pot_interp$onda1, PAS_interp$onda1, method = "kendall")
corKenPotPASOnda2 <- cor.test(pot_interp$onda2, PAS_interp$onda2, method = "kendall")
corKenPotPASOnda3 <- cor.test(pot_interp$onda3, PAS_interp$onda3, method = "kendall")

corKenPotPADOnda1 <- cor.test(pot_interp$onda1, PAD_interp$onda3, method = "kendall")
corKenPotPADOnda2 <- cor.test(pot_interp$onda2, PAD_interp$onda3, method = "kendall")
corKenPotPADOnda3 <- cor.test(pot_interp$onda3, PAD_interp$onda3, method = "kendall")
################################################################################

################################################################################
### Sodio
###Correlacoes de Spearman e Kendall
##Correlacao de Postos de Spearman (coeficiente = ro)
corSpeSodRazaoAlbuCreatOnda1 <- cor.test(sodio_interp$onda1, razaoAlbuCreat_interp$onda1, method = "spearman")
corSpeSodRazaoAlbuCreatOnda2 <- cor.test(sodio_interp$onda2, razaoAlbuCreat_interp$onda2, method = "spearman")

corSpeSodPASOnda1 <- cor.test(sodio_interp$onda1, PAS_interp$onda1, method = "spearman")
corSpeSodPASOnda2 <- cor.test(sodio_interp$onda2, PAS_interp$onda2, method = "spearman")
corSpeSodPASOnda3 <- cor.test(sodio_interp$onda3, PAS_interp$onda3, method = "spearman")

corSpeSodPADOnda1 <- cor.test(sodio_interp$onda1, PAD_interp$onda3, method = "spearman")
corSpeSodPADOnda2 <- cor.test(sodio_interp$onda2, PAD_interp$onda3, method = "spearman")
corSpeSodPADOnda3 <- cor.test(sodio_interp$onda3, PAD_interp$onda3, method = "spearman")

dfCorSodAlbuCreat <- data.frame(
  "Sodium wave 1" = sodio_interp$onda1,
  "Sodium wave 2" = sodio_interp$onda2,
  "AlbCreat wave 1" = razaoAlbuCreat_interp$onda1,
  "AlbCreat wave 2" = razaoAlbuCreat_interp$onda2
)
corSpeDFSodAlbuCreat <- cor(dfCorSodAlbuCreat, method = "spearman")
corrplot(corSpeDFSodAlbuCreat, 
         title = "\nMatrix of Spearman correlation - Sodium x Albumina-Creatinine Ratio", 
         method = 'square',
         type = 'lower',  # Definir o tipo de plotagem para apenas a parte inferior da matriz
         order = 'hclust',  # Definir a ordem de agrupamento das variáveis
         tl.col = 'black',  # Definir a cor do texto das células
         addCoef.col = 'black',  # Definir a cor dos coeficientes exibidos
         cl.ratio = 0.2,  # Ajustar a razão da barra de cores
         tl.srt = 45,  # Ajustar o ângulo de rotação do texto do rótulo
         col = COL1('YlGn'))  # Escolher a paleta de cores

corKenDFSodAlbuCreat <- cor(dfCorSodAlbuCreat, method = "kendall")
corrplot(corKenDFSodAlbuCreat, 
         title = "\nMatrix of Kendall correlation - Sodium x Albumina-Creatinine Ratio", 
         method = 'square',
         type = 'lower',  # Definir o tipo de plotagem para apenas a parte inferior da matriz
         order = 'hclust',  # Definir a ordem de agrupamento das variáveis
         tl.col = 'black',  # Definir a cor do texto das células
         addCoef.col = 'black',  # Definir a cor dos coeficientes exibidos
         cl.ratio = 0.2,  # Ajustar a razão da barra de cores
         tl.srt = 45,  # Ajustar o ângulo de rotação do texto do rótulo
         col = COL1('YlGn'))  # Escolher a paleta de cores


dfCorSodPAS <- data.frame(
  "Sodio - wave 1" = sodio_interp$onda1,
  "Sodio - wave 2" = sodio_interp$onda2,
  "Sodio - wave 3" = sodio_interp$onda3,
  "PAS - wave 1" = PAS_interp$onda1,
  "PAS - wave 2" = PAS_interp$onda2,
  "PAS - wave 3" = PAS_interp$onda3
)

dfCorSodPAD <- data.frame(
  "Sodio - wave 1" = sodio_interp$onda1,
  "Sodio - wave 2" = sodio_interp$onda2,
  "Sodio - wave 3" = sodio_interp$onda3,
  "PAD - wave 1" = PAD_interp$onda1,
  "PAD - wave 1" = PAD_interp$onda2,
  "PAD - wave 1" = PAD_interp$onda3
)

##Correlacao Tau de Kendall (coeficiente = tau):
corKenSodRazaoAlbuCreatOnda1 <- cor.test(sodio_interp$onda1, razaoAlbuCreat_interp$onda1, method = "kendall")
corKenSodRazaoAlbuCreatOnda2 <- cor.test(sodio_interp$onda2, razaoAlbuCreat_interp$onda2, method = "kendall")

corKenSodPASOnda1 <- cor.test(sodio_interp$onda1, PAS_interp$onda1, method = "kendall")
corKenSodPASOnda2 <- cor.test(sodio_interp$onda2, PAS_interp$onda2, method = "kendall")
corKenSodPASOnda3 <- cor.test(sodio_interp$onda3, PAS_interp$onda3, method = "kendall")

corKenSodPADOnda1 <- cor.test(sodio_interp$onda1, PAD_interp$onda3, method = "kendall")
corKenSodPADOnda2 <- cor.test(sodio_interp$onda2, PAD_interp$onda3, method = "kendall")
corKenSodPADOnda3 <- cor.test(sodio_interp$onda3, PAD_interp$onda3, method = "kendall")
################################################################################
####################################GLM#########################################
###Criando data frame
dfGLM_PresencaHipertensaoSistem <- data.frame(PresencaHipertensaoSistem = presencaHipertensaoSistem_interp$onda1,
                                              idade = idadeNaOnda1
                                              )
###gerando um GLM
GLM_PresencaHipertensaoSistemOnda1 <- glm(PresencaHipertensaoSistem ~ idade, data = dfGLM_PresencaHipertensaoSistem, family = binomial)
###Resumo do GML
summary(GLM_PresencaHipertensaoSistemOnda1)
###Adicionando as probabilidades previstas ao data frame original
dfGLM_PresencaHipertensaoSistem$predicted_prob <- predict(GLM_PresencaHipertensaoSistemOnda1, type = "response")
###Plotagem
### Plotagem
ggplot(data = dfGLM_PresencaHipertensaoSistem, aes(x = idade, y = predicted_prob)) +
  geom_point(aes(color = factor(PresencaHipertensaoSistem))) +  # Corrigir a variável de cor
  geom_smooth(method = "glm", method.args = list(family = binomial(link = "logit")), se = FALSE) +
  labs(title = "Previsões da Regressão Logística", x = "Idade", y = "Probabilidade Predita") +
  theme_minimal()
################################################################################
### Plotagem
ggplot(data = dfGLM_PresencaHipertensaoSistem, aes(x = idade, y = predicted_prob)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(title = "Previsões da Regressão Logística", x = "Idade", y = "Probabilidade Predita") +
  theme_classic()
###Plotagem
################################################################################
ggplot(data = dfGLM_PresencaHipertensaoSistem, aes(x = idade, y = predicted_prob)) +
geom_point(aes(color = factor(PresencaHipertensaoSistem))) +  # Usa a variável para colorir os pontos
#geom_smooth(method = "glm", method.args = list(family = binomial(link = "logit")), se = FALSE) +  # Adiciona a curva de ajuste
labs(title = "Previsões da Regressão Logística", x = "Idade", y = "Probabilidade Predita") +
scale_color_manual(name = "Presença de Hipertensão", values = c("0" = "blue", "1" = "red")) +  # Corrige o título da legenda e define as cores
theme_minimal()