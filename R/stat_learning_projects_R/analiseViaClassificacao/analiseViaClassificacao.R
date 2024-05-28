library(class)
data(iris)
set.seed(999)

################################################################################
head(iris,10)
################################################################################
normalizeNumbers <- function(){
    sepalLengthNormalized  <- c()
    sepalWidthNormalized   <- c()
    PetalLengthNormalized  <- c()
    PetalWidthNormalized   <- c()
    irisNormalized         <- c()
    FlowersTypeNormalized  <- c()
    
    sepalLengthMax <- max(iris$Sepal.Length)
    sepalLengthMin <- min(iris$Sepal.Length)
    
    sepalWidthMax <- max(iris$Sepal.Width)
    sepalWidthMin <- min(iris$Sepal.Width)
    
    PetalLengthMax <- max(iris$Petal.Length)
    PetalLengthMin <- min(iris$Petal.Length)
                      
    PetalWidthMax <- max(iris$Petal.Width)
    PetalWidthMin <- min(iris$Petal.Width)
    
    for (i in 1:nrow(iris)){
        sepalLengthNormalized <- c(sepalLengthNormalized, (iris$Sepal.Length[i] - sepalLengthMin)/(sepalLengthMax - sepalLengthMin))
        sepalWidthNormalized  <- c(sepalWidthNormalized, (iris$Sepal.Width[i]  - sepalWidthMin)/(sepalWidthMax - sepalWidthMin))
        PetalLengthNormalized <- c(PetalLengthNormalized, (iris$Petal.Length[i] - PetalLengthMin)/(PetalLengthMax - PetalLengthMin)) 
        PetalWidthNormalized  <- c(PetalWidthNormalized, (iris$Petal.Width[i] - PetalWidthMin)/(PetalWidthMax - PetalWidthMin)) 
        FlowersTypeNormalized <- c(FlowersTypeNormalized, iris$Species[i])
        }
    
    irisNormalized <- as.data.frame(cbind(sepalLength = sepalLengthNormalized, 
                                          sepalWidth = sepalWidthNormalized, 
                                          PetalLength = PetalLengthNormalized, 
                                          PetalWidth = PetalWidthNormalized,
                                          FlowersType = FlowersTypeNormalized))
    return (irisNormalized)
}

################################################################################
iris2 <- normalizeNumbers()
iris2$FlowersType <- factor(iris2$FlowersType, labels = c( "setosa", "versicolor", "virginica"))
#trainModel$FlowersType <- as.factor(trainModel$FlowersType)

part <- sample(2, nrow(iris2), replace = TRUE, prob = c(0.6, 0.4))
trainModel <- iris2[part==1,]
testModel <- iris2[part==2,]
prediction <- knn(trainModel[,-5], testModel[-5], trainModel$FlowersType, k = 3, prob = TRUE)

##############################################################
# Criar a matriz de confusão
confusion_matrix <- table(testModel$FlowersType, prediction)

# Adicionar nomes às linhas e colunas
rownames(confusion_matrix) <- levels(testModel$FlowersType)
colnames(confusion_matrix) <- levels(testModel$FlowersType)

# Mostrar a matriz de confusão
print(confusion_matrix)
##############################################################

# Vetores para armazenar as cores correspondentes às previsões
cores <- c("red", "green", "blue")

# Plotar os pontos de dados coloridos de acordo com a classe predita
plot(iris2$sepalLength, iris2$sepalWidth, col = cores[prediction], pch = 19,
     xlab = "Sepal Width", ylab = "Sepal Length", main = "Sepal Width vs Sepal Length")
legend("topright", legend = levels(iris2$FlowersType), fill = cores)
