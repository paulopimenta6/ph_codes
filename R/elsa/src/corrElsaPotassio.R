source("./src/script_analise_dados_elsa_Var_Lib.R")
library(VIM)

dfPotassio <- data.frame(onda1 = potassioOnda1,
                         onda2 = potassioOnda2,
                         onda3 = potassioOnda3
                         )

dfRazaoAlbuminaCreatinina <- data.frame(onda1 = razaoAlbuminaCreatininaRastreavelOnda1,
                                        onda2 = razaoAlbuminaCreatininaRastreavelOnda2)

razaoAlbuCreat_interp <- kNN(dfRazaoAlbuminaCreatinina, k = 5) 
razaoAlbuCreat_interp <- razaoAlbuCreat_interp[, -c(3:ncol(razaoAlbuCreat_interp))]

pot_interp <- kNN(dfPotassio, k=5)
pot_interp <- pot_interp[,-c(4:ncol(pot_interp))]

#VD: y -> razaoAlbuCreat_interp
#VI: x -> pot_interp

plot(pot_interp$onda1, razaoAlbuCreat_interp$onda1, main = "Onda 1", xlab = "concetracao de potassio", ylab = "razao albumina-creatinina")
plot(pot_interp$onda2, razaoAlbuCreat_interp$onda2, main = "Onda 2", xlab = "concetracao de potassio", ylab = "razao albumina-creatinina")

mod1 <- lm(razaoAlbuCreat_interp$onda1 ~ pot_interp$onda1) 
mod2 <- lm(razaoAlbuCreat_interp$onda2 ~ pot_interp$onda2)

par(mfrow = c(2,2))
plot(mod1, main = "Onda 1")

par(mfrow = c(2,2))
plot(mod2, main = "Onda 2")