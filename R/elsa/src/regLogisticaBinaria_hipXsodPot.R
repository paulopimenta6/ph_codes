if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey, dbscan)
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1
)
################################################################################
View(dadosOnda1)
glimpse(dadosOnda1)
################################################################################
table(dadosOnda1$hip)
summary(dadosOnda1$hip)
################################################################################
mod <- glm(hip ~ pot + sod, 
           data = dadosOnda1, 
           family = binomial(link = 'logit')
)
################################################################################
###summary(mod)
################################################################################
plot(mod, which = 5)
summary(stdres(mod))
################################################################################
###Ausencia de multicolinearidade
pairs.panels(dadosOnda1)
### Multicolinearidade: r > 0.9 (ou 0.8)
vif(mod)
### Multicolinearidade: VIF > 10
################################################################################
###Teste de Box-Tidwell
intolog_pot <- dadosOnda1$pot*log(dadosOnda1$pot)
intolog_sod <- dadosOnda1$sod*log(dadosOnda1$sod)

dadosOnda1$intolog_pot <- intolog_pot
dadosOnda1$intolog_sod <- intolog_sod
################################################################################
modint <- glm(hip ~ pot + sod + dadosOnda1$intolog_pot + dadosOnda1$intolog_sod, 
              data = dadosOnda1, 
              family = binomial(link = 'logit')
)
################################################################################
summary(modint)
################################################################################
logito <- modint$linear.predictors
################################################################################
#### Analise da relaca linear

ggplot(dadosOnda1, aes(logito, sod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()

ggplot(dadosOnda1, aes(logito, pot)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  theme_classic()
################################################################################
### Considerando o modelo original inicial e a probabilidade calculada para sodio e potassio
dadosOnda1$prob_predita_mod <- predict(mod, type = "response")

# Visualizando as probabilidades em relação a 'pot'
ggplot(dadosOnda1, aes(x = pot, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Potássio (pot)", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()

# Visualizando as probabilidades em relação a 'sod'
ggplot(dadosOnda1, aes(x = sod, y = prob_predita_mod)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "loess") +
  labs(x = "Sódio (sod)", y = "Probabilidade prevista de Hipertensao") +
  theme_classic()
################################################################################
################################################################################
cores_clusters <- c("blue", "green")

###Agrupamento
set.seed(1)
cluster <- kmeans(dadosOnda1[,c(2,3)],2)

plot(dadosOnda1[,c(2,3)],
     col = cores_clusters[cluster$cluster],
     pch = 20, cex = 1,
     ylab = "sodio", xlab = "potassio")

###Adiciona os centróides dos clusters com outra cor para destaque
points(cluster$centers[,1], cluster$centers[,2], 
       pch = 8, col = "red", cex = 1.5)  # Centrôides em vermelho

###Adiciona a coluna de clusters aos dados originais
dadosOnda1$cluster <- cluster$cluster
table(dadosOnda1$cluster, dadosOnda1$hip)
################################################################################
df_sodPot <- dadosOnda1[,c(2,3)]
str(df_sodPot)
###
#kNNdistplot(df_sodPot, k = 5)  # k = minPts - 1, no caso, 5-1 = 4
#abline(h = 3, col = "red", lty = 2)  # Adicione uma linha para inspecionar

total_grupos <- sapply(1:7, function(k) {
  kmeans(df_sodPot, k)$tot.withinss
})
plot(1:7, total_grupos,
     type = "b", pch = 19, frame = FALSE,
     xlab = "Total de grupos",
     ylab = "SSE total de todos os grupos")

###
plot(df_sodPot, ylim = c(0,400), xlim = c(0,150))
agrupamento <- dbscan(df_sodPot, eps = 4, minPts = 5)
# Adicionar os clusters ao data frame
df_sodPot$cluster <- as.factor(agrupamento$cluster)

# Plotar os clusters
ggplot(df_sodPot, aes(x = pot, y = sod, color = cluster)) +
  geom_point(size = 2, alpha = 0.8) +
  scale_color_manual(values = c("grey", rainbow(length(unique(df_sodPot$cluster)) - 1))) +
  theme_minimal() +
  labs(title = "Clusters identificados pelo DBSCAN",
       x = "Pot",
       y = "Sod",
       color = "Cluster")
################################################################################
### Analise do modelo
### Overall effects
Anova(mod, type = 'II', test = "Wald")
### Efeitos especificos
summary(mod)
## Obtencao das razoes de chance com IC 95% (usando erro padrao = SPSS)
exp(cbind(OR = coef(mod), confint.default(mod)))
################################################################################
mod2 <- glm(hip ~ sod,
            family = binomial(link = 'logit'), data = dadosOnda1)

mod3 <- glm(hip ~ pot,
            family = binomial(link = 'logit'), data = dadosOnda1)

summary(mod2)
summary(mod3)
