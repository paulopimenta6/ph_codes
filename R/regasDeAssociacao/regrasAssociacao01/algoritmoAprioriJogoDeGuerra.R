library(arules)
library(arulesViz)
###Avioes usados em jogo de guerra
f16 <- c(1, 1, 0, 1, 0, 1, 0, 1, 0, 0)
f15 <- c(1, 1, 0, 1, 1, 1, 1, 1, 1, 1)
f18 <- c(1, 0, 1, 0, 1, 0, 0, 1, 0, 1)
ef2 <- c(0, 1, 0, 1, 0, 0, 1, 0, 0, 0)
rfl <- c(0, 0, 1, 1, 1, 1, 0, 0, 1, 1)
mir <- c(1, 0, 0, 0, 1, 1, 1, 1, 0, 0)
tor <- c(1, 1, 1, 0, 1, 0, 1, 1, 1, 0)
grp <- c(0, 0, 1, 1, 0, 1, 1, 0, 1, 1) #where 1 is presence and 0 absent 

#campaign results of all exercises involving all NATO forces
res <- c(0, 1, 1, 1, 0, 0, 1, 0, 1, 1) #where 1 e victory e 0 e fail

resAndfighters <- cbind(f18, f16, f15, ef2, rfl, mir, tor, grp, res)



