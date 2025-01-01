library(factoextra)

#prcomp(USArrests, scale = TRUE)
meuPCA <- prcomp(USArrests)
screeplot(meuPCA)
screeplot(meuPCA, type = "lines", main = "Screeplot")

fviz_pca_var(meuPCA,
             col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E5B311", "#FF2211"),
             repel = TRUE
)