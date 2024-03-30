library("readxl")

if(!require(dplyr)) install.packages("dplyr")
library(dplyr)

if(!require(rstatix)) install.packages("rstatix")
library(rstatix)

if(!require(car)) install.packages("car")
library(car) 

if(!require(ggplot2)) install.packages("ggplot2")
library(ggplot2)

################################################################################

my_data3 <- read_excel("Dados_Talita_MOD.xlsx")
my_data3$Tipo1 <- as.factor(my_data3$Tipo1)
my_data3 %>% group_by(my_data3$Tipo1) %>% shapiro_test(my_data3$Grupo_A, my_data3$Grupo_B)