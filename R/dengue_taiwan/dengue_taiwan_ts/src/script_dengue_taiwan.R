library("readr")
data_dengue_taiwan = read_csv("./data/Dengue_Daily_EN.csv")

#data_dengue_taiwan <- as.Date(data_dengue_taiwan$Date_Notification)
data_dengue_taiwan$Month <- months(data_dengue_taiwan$Date_Notification)
data_dengue_taiwan$Year <- format(data_dengue_taiwan$Date_Notification,format="%y")

avg_dengue_taiwan_month_year <- data.frame(aggregate(data_dengue_taiwan$Number_of_confirmed_cases ~ Month + Year , data_dengue_taiwan , mean))
avg_dengue_taiwan_county <- data.frame(aggregate(data_dengue_taiwan$Number_of_confirmed_cases ~ data_dengue_taiwan$MOI_County_living + Month + Year , data_dengue_taiwan , mean))

acum_dengue_taiwan_county <- data.frame(aggregate(data_dengue_taiwan$Number_of_confirmed_cases ~ data_dengue_taiwan$MOI_County_living + Month + Year , data_dengue_taiwan , sum))
