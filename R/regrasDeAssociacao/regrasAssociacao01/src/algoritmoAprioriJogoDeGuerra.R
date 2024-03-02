library(arules)
library(arulesViz)

library(ggplot2)
library(plotly)

###Avioes usados em jogo de guerra
F35 <- c(1, 1, 1, 1, 1, 1, 0, 1, 0, 1)
F22 <- c(1, 1, 1, 1, 1, 1, 0, 1, 1, 1)
F18 <- c(1, 0, 1, 0, 1, 0, 0, 1, 0, 1)
F16 <- c(1, 1, 0, 1, 0, 1, 0, 1, 0, 0)
F15 <- c(1, 1, 0, 1, 1, 1, 1, 1, 1, 1)
EF2000 <- c(0, 1, 0, 1, 0, 0, 1, 0, 0, 0)
Gripen <- c(1, 0, 1, 1, 0, 1, 1, 0, 1, 1)
Mirage2000_5 <- c(1, 0, 0, 0, 1, 1, 1, 1, 0, 0)
Panavia_Tornado <- c(1, 0, 0, 0, 1, 0, 1, 0, 1, 0)
Rafale <- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1)  #where 1 is presence and 0 absent

#campaign results of all exercises involving all NATO forces
result <- c(0, 1, 1, 1, 0, 0, 1, 0, 1, 1) #where 1 e victory e 0 e fail

resAndfighters <- cbind(F35, F22, F18, F16, F15, EF2000, Gripen, Mirage2000_5, Panavia_Tornado, Rafale, result)
print(resAndfighters)
###############################################################################################
rules <- apriori(resAndfighters, parameter = list(support = 0.3, confidence = 0.5, target = "rules"))
rulesV1 <- rules[10:length(rules)]
###############################################################################################
inspect(rulesV1, ruleSep = "-->", itemSep = " && ", setStart = "", setEnd = "", linebreak = FALSE)
###############################################################################################
plot(rulesV1, main = NULL) 
###############################################################################################
rules_subset <- subset(rulesV1, (rhs %in% "result"))
inspect(rules_subset[1:6])
###############################################################################################
plot(rules_subset, method="graph", main = NULL)
###############################################################################################
rules_subset <- subset(rulesV1, (lhs %in% "result"))
inspect(rules_subset[1:6])
