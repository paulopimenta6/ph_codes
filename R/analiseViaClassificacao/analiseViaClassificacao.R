library(class)
data(iris)
set.seed(999)

################################################################################
head(iris,10)
################################################################################
normalizeNUmbers <- function(){
    sepalLengthNormalized <- c()
  
    sepalLengthMax <- max(iris$Sepal.Length)
    sepalLengthMin <- min(iris$Sepal.Length)
    
    sepalWidthMax <- max(iris$Sepal.Width)
    sepalWidthMin <- min(iris$Sepal.Width)
    
    PetalLengthMax <- max(iris$Petal.Length)
    PetalLengthMin <- min(iris$Petal.Length)
                      
    PetalWidthMax <- max(iris$Petal.Width)
    PetalWidthMin <- min(iris$Petal.Width)
    
    for (i in 1:nrow(iris)){
        newNormalizedValue <- (iris$Sepal.Length[i] - sepalLengthMin)/(sepalLengthMax - sepalLengthMin)
        sepalNormalized <- c(sepalNormalized, newNormalizedValue)
    }
    
    return (sepalNormalized)
}

################################################################################
print(normalizeNUmbers())
################################################################################
