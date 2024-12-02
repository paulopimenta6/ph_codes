library(tidyverse)
library(lubridate)
library(ggplot2)

data <- read.csv("./data/Dengue_Daily_EN.csv", sep = ",", dec = ".")

################################################################################
### Synthoms
data$Date_Onset <- ymd(data$Date_Onset)
if(length(which(data$Date_Onset == "")) > 0){
  data$Date_Onset[which(data$Date_Onset == "")] <- NA
}
data$year_suspect <- format(data$Date_Onset, format = "%Y")
data$month_suspect <- format(data$Date_Onset, format = "%m")
data$day_suspect <- format(data$Date_Onset, format = "%d")
################################################################################
### confirmation
data$Date_Confirmation <- ymd(data$Date_Confirmation)
if(length(which(data$Date_Confirmation == "")) > 0){
  data$Date_Confirmation[which(data$Date_Confirmation == "")] <- NA
}
data$year_confirmation <- format(data$Date_Confirmation, format = "%Y")
data$month_confirmation <- format(data$Date_Confirmation, format = "%m")
data$day_confirmation <- format(data$Date_Confirmation, format = "%d")
################################################################################
### Confirmation
data$Date_Notification <- ymd(data$Date_Notification)
if(length(which(data$Date_Notification == "")) > 0){
  data$Date_Notification[which(data$Date_Notification == "")] <- NA
}
data$year_notification <- format(data$Date_Notification, format = "%Y")
data$month_notification <- format(data$Date_Notification, format = "%m")
data$day_notification <- format(data$Date_Notification, format = "%d")
################################################################################
### Tables
cases_county_living <- data %>%
  group_by(year_confirmation, County_living) %>%
  summarise(total_cases = n(), .groups = "drop")

# New Taipei City  
cases_new_taipei <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "New Taipei City")

# Taipei City
cases_taipei <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "Taipei City")

# Kaohsiung City
cases_kaohsiung <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "Kaohsiung City")

# Taichung City
cases_taichung_city <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "Taichung City")

# Tainan City
cases_tainan_city <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "Tainan City")

# Pingtung County
cases_pingtung_county <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "Pingtung County")

# Penghu County
cases_penghu_county <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "Penghu County")

# Hualien County 
cases_hualien_county <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "Hualien County")

# Keelung City
cases_keelung_city <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "Keelung City")

# Taoyuan City
cases_taoyuan_city <- cases_county_living %>% 
  group_by(year_confirmation, County_living, total_cases) %>%
  filter(County_living == "Taoyuan City")
################################################################################
# Criar o gráfico de série temporal
# new_taipei_city
ggplot(cases_new_taipei, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in New Taipei City",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )
################################################################################
# cases_taipei
ggplot(cases_taipei, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in Taipei City",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )
################################################################################
# Kaohsiung City
ggplot(cases_kaohsiung, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in Kaohsiung",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )
################################################################################
# Taichung City
ggplot(cases_taichung_city, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in Taichung",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )
################################################################################
# Tainan City
ggplot(cases_tainan_city, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in Tainan",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )
################################################################################
# Pingtung County
ggplot(cases_pingtung_county, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in Pingtung",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )
################################################################################
# Penghu County
ggplot(cases_penghu_county, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in Penghu",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )
################################################################################
# Hualien County
ggplot(cases_hualien_county, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in Hualien",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )
################################################################################
# Keelung City
ggplot(cases_keelung_city, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in Keelung",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )
################################################################################
# Taoyuan City
ggplot(cases_taoyuan_city, aes(x = as.numeric(year_confirmation), y = total_cases)) +
  geom_line(color = "blue", size = 1) +      # Linha azul conectando os pontos
  geom_point(color = "red", size = 2) +      # Pontos vermelhos indicando os valores
  labs(
    title = "Temporal Evolution of Dengue Cases in Taoyuan",
    x = "Year",
    y = "Number of cases",
    caption = "Fonte: Ministry of Health and Welfare"
  ) +
  theme_minimal(base_size = 14) +            # Tema limpo e elegante
  theme(
    plot.title = element_text(hjust = 0.5), # Centralizar título
    axis.text.x = element_text(angle = 45, vjust = 0.5) # Ajustar os rótulos do eixo X
  )