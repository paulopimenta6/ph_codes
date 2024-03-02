library(readODS)
#library(zoo)
library(ggplot2)
library(tidyverse)
#############################################################################################
taiwan_data <- read_ods("InquireAdvance2022_2023.ods")
#############################################################################################
countriesId <- seq(3, ncol((taiwan_data)), 12)[-length(seq(3, ncol((taiwan_data)), 12))]
typeId <- seq(3, ncol((taiwan_data)), 11)
#############################################################################################
countries <- c()
types <- c()
ano <- data.frame(Ano = taiwan_data[[1]][3:15])
mes <- data.frame(Month = taiwan_data[[2]][3:15])

DF_USA <- data.frame(matrix(nrow = 13, ncol = 1))
DF_Japan <- data.frame(matrix(nrow = 13, ncol = 1))
DF_HKCN <- data.frame(matrix(nrow = 13, ncol = 1))
DF_ASEAN <- data.frame(matrix(nrow = 13, ncol = 1))
DF_EU <- data.frame(matrix(nrow = 13, ncol = 1))
DF_OTHERS <- data.frame(matrix(nrow = 13, ncol = 1))
#############################################################################################
for (y in 1:length(ano$Ano)){
  if(!is.na(ano$Ano[y])){
    lastYear =  ano$Ano[y] 
  } else{
    ano$Ano[y] = lastYear
  }
}
period <- data.frame(Period = paste(mes$Month, ano$Ano, sep="-"))
for (ct in countriesId){
  countries <- append(countries, taiwan_data[[ct]][1])
}
for (tp in countriesId[1]:(countriesId[2]-1)) {
  types <- append(types, taiwan_data[[tp]][2])
}
#Salvado em data frames e seccionando informações em setores e paises
#taiwan_data[[3]] --> Primeira coluna com informação de dado dos paises
#as.numeric(taiwan_data[[3]][3:15]) --> Coluna de produtos quimicos exportados
#indices do paises: 3         15        27                      39      51        63
#Paises:            "U.S.A.", "Japan", "Hong Kong & Mainland", "ASEAN", "Europe", "Others"
groupedDF <- data.frame(CountryId = countriesId, Country = countries)
#############################################################################################
#############################################################################################
###Categorizando os dados por pais
#USA
for (i in countriesId[1]:(countriesId[2]-1)){
  DF_USA <- cbind(DF_USA, data.frame(taiwan_data[[i]][3:15]))
}
#Japan
for (i in countriesId[2]:(countriesId[3]-1)){
  DF_Japan <- cbind(DF_Japan, data.frame(taiwan_data[[i]][3:15]))
}
#Hong Kong & Mainland 
for (i in countriesId[3]:(countriesId[4]-1)){
  DF_HKCN <- cbind(DF_HKCN, data.frame(taiwan_data[[i]][3:15]))
}
#ASEAN 
for (i in countriesId[4]:(countriesId[5]-1)){
  DF_ASEAN <- cbind(DF_ASEAN, data.frame(taiwan_data[[i]][3:15]))
}
#Europe 
for (i in countriesId[5]:(countriesId[6]-1)){
  DF_EU <- cbind(DF_EU, data.frame(taiwan_data[[i]][3:15]))
}
#Others
for (i in countriesId[6]:(countriesId[6]+11)){
  DF_OTHERS <- cbind(DF_OTHERS, data.frame(taiwan_data[[i]][3:15]))
}
###Organizando os dados
#USA
DF_USA <- data.frame(DF_USA)
DF_USA <- DF_USA[-1]
DF_USA <- lapply(DF_USA, as.numeric)
names(DF_USA) <- types
DF_USA <- cbind(period, DF_USA)
DF_USA$Period <- factor(DF_USA$Period, levels = DF_USA$Period)
#Japan
DF_Japan <- data.frame(DF_Japan)
DF_Japan <- DF_Japan[-1]
DF_Japan <- lapply(DF_Japan, as.numeric)
names(DF_Japan) <- types
DF_Japan <- cbind(period, DF_Japan)
DF_Japan$Period <- factor(DF_Japan$Period, levels = DF_Japan$Period)
#HKCN
DF_HKCN  <- data.frame(DF_HKCN)
DF_HKCN  <- DF_HKCN[-1]
DF_HKCN  <- lapply(DF_HKCN, as.numeric)
names(DF_HKCN) <- types
DF_HKCN <- cbind(period, DF_HKCN)
DF_HKCN$Period <- factor(DF_HKCN$Period, levels = DF_HKCN$Period)
#ASEAN
DF_ASEAN  <- data.frame(DF_ASEAN)
DF_ASEAN  <- DF_ASEAN[-1]
DF_ASEAN  <- lapply(DF_ASEAN, as.numeric)
names(DF_ASEAN) <- types
DF_ASEAN <- cbind(period, DF_ASEAN)
DF_ASEAN$Period <- factor(DF_ASEAN$Period, levels = DF_ASEAN$Period)
#Europe
DF_EU  <- data.frame(DF_EU)
DF_EU  <- DF_EU[-1]
DF_EU  <- lapply(DF_EU, as.numeric)
names(DF_EU) <- types
DF_EU <- cbind(period, DF_EU)
DF_EU$Period <- factor(DF_EU$Period, levels = DF_EU$Period)
#Others
DF_OTHERS  <- data.frame(DF_OTHERS)
DF_OTHERS  <- DF_OTHERS[-1]
DF_OTHERS  <- lapply(DF_OTHERS, as.numeric)
names(DF_OTHERS) <- types
DF_OTHERS <- cbind(period, DF_OTHERS)
DF_OTHERS$Period <- factor(DF_OTHERS$Period, levels = DF_OTHERS$Period)


#############################################################################################
#############################################################################################
#Electronics
#USA
ggplot(data = DF_USA) + 
  geom_bar(mapping = aes(x = Period, y = `Electronic Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electronics exports to USA 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronicsTwUSA.png", width = 70, height = 20, units = "cm")
#Japan
ggplot(data = DF_Japan) + 
  geom_bar(mapping = aes(x = Period, y = `Electronic Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electronics exports to Japan 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronicsTwJapan.png", width = 70, height = 20, units = "cm")
#HKCN
ggplot(data = DF_HKCN) + 
  geom_bar(mapping = aes(x = Period, y = `Electronic Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electronics exports to HK and CN 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronicsTwHKCN.png", width = 70, height = 20, units = "cm")
#Europe
ggplot(data = DF_EU) + 
  geom_bar(mapping = aes(x = Period, y = `Electronic Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electronics exports to Europe 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronicsTwEU.png", width = 70, height = 20, units = "cm")
#ASEAN
ggplot(data = DF_ASEAN) + 
  geom_bar(mapping = aes(x = Period, y = `Electronic Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese Electronics exports to ASEAN 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronicsTwASEAN.png", width = 70, height = 20, units = "cm")
#OTHERS
ggplot(data = DF_OTHERS) +
  geom_bar(mapping = aes(x = Period, y = `Electronic Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese Electronics exports to OTHERS 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") 
ggsave("electronicsTwOTHERS.png", width = 70, height = 20, units = "cm")
#############################################################################################
#############################################################################################
#Electrical Machinery Products
#USA
ggplot(data = DF_USA) + 
  geom_bar(mapping = aes(x = Period, y = `Electrical Machinery Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electrical machinery products exports to USA 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronialMachTwUSA.png", width = 70, height = 20, units = "cm")
#Japan
ggplot(data = DF_Japan) + 
  geom_bar(mapping = aes(x = Period, y = `Electrical Machinery Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electrical machinery products exports to Japan 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronialMachTwJapan.png", width = 70, height = 20, units = "cm")
#HKCN
ggplot(data = DF_HKCN) + 
  geom_bar(mapping = aes(x = Period, y = `Electrical Machinery Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electrical machinery products exports to HK and CN 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronialMachTwHKCN.png", width = 70, height = 20, units = "cm")
#Europe
ggplot(data = DF_EU) + 
  geom_bar(mapping = aes(x = Period, y = `Electrical Machinery Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electrical machinery products exports to Europe 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronialMachTwEU.png", width = 70, height = 20, units = "cm")
#ASEAN
ggplot(data = DF_ASEAN) + 
  geom_bar(mapping = aes(x = Period, y = `Electrical Machinery Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electrical machinery products exports to ASEAN 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("electronialMachTwASEAN.png", width = 70, height = 20, units = "cm")
#OTHERS
ggplot(data = DF_OTHERS) +
  geom_bar(mapping = aes(x = Period, y = `Electrical Machinery Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese electrical machinery products exports to OTHERS 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") 
ggsave("electronialMachTwOTHERS.png", width = 70, height = 20, units = "cm")
#############################################################################################
#############################################################################################
#Information & Communication Products
#USA
ggplot(data = DF_USA) + 
  geom_bar(mapping = aes(x = Period, y = `Information & Communication Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese information & communication products exports to USA 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("ITDevTwUSA.png", width = 70, height = 20, units = "cm")
#Japan
ggplot(data = DF_Japan) + 
  geom_bar(mapping = aes(x = Period, y = `Information & Communication Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese information & communication products exports to Japan 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("ITDevTwJapan.png", width = 70, height = 20, units = "cm")
#HKCN
ggplot(data = DF_HKCN) + 
  geom_bar(mapping = aes(x = Period, y = `Information & Communication Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese information & communication products exports to HK and CN 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("ITDevTwHKCN.png", width = 70, height = 20, units = "cm")
#Europe
ggplot(data = DF_EU) + 
  geom_bar(mapping = aes(x = Period, y = `Information & Communication Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese information & communication products exports to Europe 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("ITDevTwEU.png", width = 70, height = 20, units = "cm")
#ASEAN
ggplot(data = DF_ASEAN) + 
  geom_bar(mapping = aes(x = Period, y = `Information & Communication Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese information & communication products to ASEAN 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") +
  guides(fill = guide_legend(title = "Value"))
ggsave("ITDevTwASEAN.png", width = 70, height = 20, units = "cm")
#OTHERS
ggplot(data = DF_OTHERS) +
  geom_bar(mapping = aes(x = Period, y = `Information & Communication Products`, fill = `Electronic Products`), stat = "identity") +
  labs(title = "Taiwanese information & communication products exports to OTHERS 2022 - 2023", 
       y ="Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA") 
ggsave("ITDevTwOTHERS.png", width = 70, height = 20, units = "cm")

#######################################################################################################

ggplot(data = DF_USA, aes(x = Period, y = `Electrical Machinery Products`, group = 1)) + 
  geom_line() +
  geom_point() +
  labs(title = "Taiwanese electrical machinery products exports to USA 2022 - 2023", 
       y = "Value in Millions of US Dollars", 
       x = "Month",
       caption = "Source = MOEA")


create_export_plot <- function(data, title, output_file) {
  ggplot(data = data, aes(x = Period, y = `Electrical Machinery Products`, group = 1)) + 
    geom_point() +
    geom_line(color = "blue") +
    labs(title = title, 
         y = "Value in Millions of US Dollars", 
         x = "Month",
         caption = "Source = MOEA") 
  ggsave(output_file, width = 70, height = 20, units = "cm")
}

create_export_plot(DF_USA, "Taiwanese electrical machinery products exports to USA 2022 - 2023", "electronialMachTwUSA.png")
create_export_plot(DF_Japan, "Taiwanese electrical machinery products exports to Japan 2022 - 2023", "electronialMachTwJapan.png")
create_export_plot(DF_HKCN, "Taiwanese electrical machinery products exports to HK and CN 2022 - 2023", "electronialMachTwHKCN.png")
create_export_plot(DF_EU, "Taiwanese electrical machinery products exports to Europe 2022 - 2023", "electronialMachTwEU.png")
create_export_plot(DF_ASEAN, "Taiwanese electrical machinery products exports to ASEAN 2022 - 2023", "electronialMachTwASEAN.png")
create_export_plot(DF_OTHERS, "Taiwanese electrical machinery products exports to OTHERS 2022 - 2023", "electronialMachTwOTHERS.png")