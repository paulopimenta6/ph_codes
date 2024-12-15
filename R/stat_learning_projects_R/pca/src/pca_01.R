################################################################################
############ Script para aprendizado de diminuicao de dimensao #################
################################################################################
################ Construcao de base de dados e graficos ########################
################################################################################

if (!requireNamespace("scatterplot3d")) install.packages("scatterplot3d")
library(scatterplot3d)

robot <- c("R1", "R2", "R3", "R4", "R5", "R6")
versao_1 <- c(12, 13, 10, 5, 4, 3)
versao_2 <- c(7, 5, 6, 3, 4, 1)
versao_3 <- c(7, 8, 5, 4, 6, 2)

DF_Robots <- as.data.frame(rbind(versao_1, versao_2, versao_3))
names(DF_Robots) <- robot

plot(versao_1,
     rep(0, length(versao_1)),
     type = "p", 
     main = "Gráfico de Pontos - versao 1 em uma dimensao", 
     xlab = "Índice", 
     ylab = "Valores",
     pch = 16
)

plot(versao_2 ~ versao_1,
     main = "Grafico bidimensional",
     xlab = "versao_1",
     ylab = "versao_2",
     pch = 16
)

scatterplot3d(versao_1, 
              versao_2, 
              versao_3,
              pch = 16
)

################################################################################
############################ Analise de PCA ####################################
################################################################################
DF_Robots_t <- t(DF_Robots)

# Gerando o gráfico
par(mgp = c(2, 0.5, 0))
plot(DF_Robots_t[,2] ~ DF_Robots_t[,1],
     xlab = "versao_1",
     ylab = "versao_2",
     pch = 11,
     main = "Preparacao para gráfico PCA"
)

media_V1 <- c(round(mean(DF_Robots_t[,1]),2))
media_V2 <- c(round(mean(DF_Robots_t[,2]),2))
points(media_V1, media_V2, pch = 12, col = "red")
DF_Robots_tc <- data.frame()
for (i in 1:length(DF_Robots_t[,1])){
    DF_Robots_tc[i,1] <- DF_Robots_t[i,1] - media_V1
    DF_Robots_tc[i,2] <- DF_Robots_t[i,2] - media_V2 
}

par(mgp = c(2, 0.5, 0))
plot(DF_Robots_tc[,2] ~ DF_Robots_tc[,1],
     xlab = "versao_1 - media da versao_1",
     ylab = "versao_2- media da versao_2",
     pch = 11,
     main = "Preparacao para gráfico PCA"
)
points(0, 0, pch = 12, col = "darkred")
abline(h = 0, col = "blue", lty = 5)
abline(v = 0, col = "red", lty = 5)

### A partir daqui usa um modelo linear lm. 
### Continuarei depois...


