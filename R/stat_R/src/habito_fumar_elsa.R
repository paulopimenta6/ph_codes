source("script_analise_dados_elsa_Var_Lib.R")
library(readr)
library(tidyverse)
library(dplyr)

ggplot(importaDadosLib, aes(x=(habitoDeFumarOnda1))) + geom_bar() + xlab("Pacientes com habito de fumar na Onda 1 - 0: nunca fumou, 1: ex-fumante e 2: fumante") + ylab("Quantidade da amostra na Onda 1")
ggplot(importaDadosLib, aes(x=(habitoDeFumarOnda2))) + geom_bar() + xlab("Pacientes com habito de fumar na Onda 2 - 0: nunca fumou, 1: ex-fumante e 2: fumante") + ylab("Quantidade da amostra na Onda 2")
ggplot(importaDadosLib, aes(x=(habitoDeFumarOnda3))) + geom_bar() + xlab("Pacientes com habito de fumar na Onda 3 - 0: nunca fumou, 3: ex-fumante e 2: fumante") + ylab("Quantidade da amostra na Onda 3")
