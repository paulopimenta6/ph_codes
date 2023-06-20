library(caret)
data(faithful)

################################################################################
somaNum <- function(x, y, mediaY){
  
  somanum <- 0
  
  for(i in 1:length(x)){
    somanum <- somanum + x[i]*(y[i] - mediaY) 
  }
  return(somanum)
}

somaDen <- function(x, mediaX){
  
  somaden <- 0
  
  for(i in 1:length(x)){
    somaden <- somaden + x[i]*(x[i] - mediaX)
  }
  return(somaden)
}
################################################################################

faithful_train <- faithful[1:15,]
x <- faithful_train$eruptions
y <- faithful_train$waiting

mediaX <- mean(x)
mediaY <- mean(y)

b <- (somaNum(x, y, mediaY))/(somaDen(x, mediaX))
a <- mediaY - b*mediaX

################################################################################
###criando um modelo linear
linearModel <- lm(y ~ x, data = faithful_train)
plot(x, y, col = "black", xlab = "Duração", ylab = "Intervalo", pch=19)
text(2.5, 80, paste("y = ", round(linearModel$coefficients[1],2), "+ x* ", round(linearModel$coefficients[2],2) ))
lines(x, linearModel$fitted.values, lwd = 2)

