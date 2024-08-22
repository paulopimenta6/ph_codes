library(readxl)
library(caret)
library(forecast)
library(car)
library(fpp)
tecx <- read_excel("~/Documentos/materiais_de_estudo_dados_e_estatistica/qrcodes/9786555063967/p33.xlsx")
################################################################################
###Ajuste de dados
tecx$cancel=ifelse(tecx$cancel=="sim", 1.0, 0.0) #Transformando cancel em variavel dummy
#tecx$tr.fatura=BoxCox(tecx$fatura, 0.3) #Ajuste de fatura para que o mesmo seja proximo da normalizacao
lambda <- BoxCox.lambda (tecx$fatura, method=c("loglik"), lower=-3, upper= 3) ## Valor de Lambda
tecx$tr.fatura=BoxCox(tecx$fatura, lambda) 
attr(tecx$tr.fatura, "lambda") <- NULL
################################################################################
################################################################################
###Grafico para ver a distribuicao dos dados apos o ajuste da fatura via BoxCox
# Definir o intervalo de classe
#intervalo <- seq(from = floor(min(tecx$tr.fatura, na.rm = TRUE) / 5) * 5,
#                 to = ceiling(max(tecx$tr.fatura, na.rm = TRUE) / 5) * 5,
#                 by = 3)
# Criar o histograma
#hist(tecx$tr.fatura, breaks = intervalo, 
#     main = "Histograma de tr.fatura com Intervalos de 5",
#     xlab = "Valor de tr.fatura",
#     ylab = "Frequência",
#     col = "lightblue",
#     border = "black")
################################################################################
set.seed(18)
flag=createDataPartition(tecx$cancel, p=.5, list = F)
###Parte de treinamento
train=tecx[flag,]
dim(train)
###Parte de teste
test=tecx[-flag,]
dim(test)
################################################################################
###Inicialmente transformei os dados tecx$cancel em dummy
###Fazendo a transformacao de uma variavel dummy
#train$cancel=ifelse(train$cancel=="sim", 1.0, 0.0)
#test$cancel=ifelse(test$cancel=="sim", 1.0, 0.0)
################################################################################
###Fazendo uso de uma glm binomial
fit=glm(data=train, cancel~idade+linhas+renda+temp_cli+tr.fatura+local, family = binomial()) 
fit=step(fit)
summary(fit)
dadosA=data.frame(idade=40, temp_cli=25, local='B', tr.fatura=BoxCox(900,0.3)) 
################################################################################

