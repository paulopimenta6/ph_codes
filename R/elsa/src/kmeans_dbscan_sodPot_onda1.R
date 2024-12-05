if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr, psych, car, MASS, DescTools, QuantPsyc, ggplot2, survey, dbscan)
source("./src/dadosRegLogistica.R")

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1
)
################################################################################
################################################################################
########################## Analises de Grupo ###################################
################################################################################
### Numero de clusters a serem usados em K-means
df_sodPot <- dadosOnda1[,c(2,3)]
str(df_sodPot)
###
total_grupos <- sapply(1:7, function(k) {
  kmeans(df_sodPot, k)$tot.withinss
})
plot(1:7, total_grupos,
     type = "b", pch = 19, frame = FALSE,
     xlab = "Total de grupos",
     ylab = "SSE total de todos os grupos")

################################################################################
###K-Means
cores_clusters <- c("blue", "green")

### Realizando o agrupamento k-means
set.seed(1)
cluster <- kmeans(dadosOnda1[,c(2,3)],2)

### Criando um data frame com os centróides renomeados
centroides <- as.data.frame(cluster$centers)
### Renomeia as colunas para combinar com os dados
colnames(centroides) <- c("pot", "sod")

### Criando um data frame com os resultados do clustering
dadosOnda1$cluster <- cluster$cluster
table(dadosOnda1$cluster, dadosOnda1$hip)

### Visualizando os clusters com ggplot2
ggplot(dadosOnda1, aes(x = pot, y = sod, color = as.factor(cluster))) +
  geom_point(size = 2, alpha = 0.8) +  # Pontos dos clusters
  geom_point(data = centroides, 
             aes(x = pot, y = sod), 
             color = "red", size = 4, shape = 8) +  # Centróides
  scale_color_manual(values = c("blue", "green")) +  # Definindo cores dos clusters
  theme_minimal() +
  labs(title = "Clusters Identificados pelo K-means",
       x = "Potássio",
       y = "Sódio",
       color = "Cluster") +
  theme(plot.title = element_text(hjust = 0.5))  # Centralizando o título

################################################################################
### DBSCAN

#kNNdistplot(df_sodPot, k = 5)  # k = minPts - 1, no caso, 5-1 = 4
kNNdistplot(df_sodPot[, c("pot", "sod")], k = 4)
abline(h = 3, col = "red", lty = 2)  # Adicione uma linha para inspecionar
abline(h = 4, col = "blue", lty = 2)  # Adicione uma linha para inspecionar

### Aplicar DBSCAN com os valores ajustados
agrupamento <- dbscan(df_sodPot[, c("pot", "sod")], eps = 5, minPts = 5)
### Adicionar os clusters ao data frame
df_sodPot$cluster <- as.factor(agrupamento$cluster)

unique_clusters <- length(unique(df_sodPot$cluster)) - 1  # Exclui o ruído (0)
colors <- c("grey", rainbow(unique_clusters))


ggplot(df_sodPot, aes(x = pot, y = sod, color = cluster)) +
  geom_point(size = 2, alpha = 0.8) +
  scale_color_manual(values = colors) +
  theme_minimal() +
  labs(
    title = "Clusters identificados pelo DBSCAN",
    x = "Pot",
    y = "Sod",
    color = "Cluster"
  )

df_valid_clusters <- df_sodPot[df_sodPot$cluster != "0", ]  # Exclui o ruído
ggplot(df_valid_clusters, aes(x = pot, y = sod, color = cluster)) +
  geom_point(size = 2, alpha = 0.8) +
  scale_color_manual(values = rainbow(length(unique(df_valid_clusters$cluster)))) +
  theme_minimal() +
  labs(
    title = "Clusters identificados pelo DBSCAN (sem ruído)",
    x = "Pot",
    y = "Sod",
    color = "Cluster"
  )

ggplot(df_sodPot, aes(x = pot, y = sod, color = cluster)) +
  geom_point(data = subset(df_sodPot, cluster == "0"), color = "grey", alpha = 0.3, size = 1.5) +  # Ruído
  geom_point(data = subset(df_sodPot, cluster != "0"), aes(color = cluster), size = 2, alpha = 0.8) +  # Clusters
  scale_color_manual(values = rainbow(length(unique(df_sodPot$cluster)) - 1)) +
  theme_minimal() +
  labs(
    title = "Clusters identificados pelo DBSCAN (ruído destacado)",
    x = "Pot",
    y = "Sod",
    color = "Cluster"
  )
################################################################################