################################################################################
source("./src/data/data_kNN_v2.R")
dadosOnda1kNN_inp$hip_num <- as.numeric(as.character(dadosOnda1kNN_inp$hip))
dadosOnda1kNN_inp$taxaFilt_num <- as.numeric(as.character(dadosOnda1kNN_inp$taxaFilt))
set.seed(123)
n   <- nrow(dadosOnda1kNN_inp)
tam <- round((0.7 * n),0)
idx <- sample.int(n, tam)
treino <- dadosOnda1kNN_inp[idx, ]
teste  <- dadosOnda1kNN_inp[-idx, ]

library(neuralnet)
set.seed(321)
NN <- neuralnet(
  hip_num ~ pot + sod + albCreat + taxaFilt_num + pas + pad,
  data           = treino,
  hidden         = c(5,10,20),
  act.fct        = "logistic",
  linear.output  = FALSE,
  threshold      = 0.01,
  algorithm      = "backprop",
  learningrate   = 0.01,
  stepmax        = 1e6
)

plot(NN)

pred <- neuralnet::compute(NN, teste[, c("pot","sod","albCreat", "taxaFilt_num", "pas","pad")])
prob <- pred$net.result[,1]
classe_pred <- ifelse(prob > 0.5, 1, 0)
table(Real = teste$hip_num, Prob = classe_pred)

resultado <- data.frame(Real=teste$hip_num, Prob = classe_pred)
#resultado 