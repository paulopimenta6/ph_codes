if(!require(pacman)) install.packages("pacman")
pacman::p_load(readr, RSQLite)

# Criar ou conectar ao banco de dados
con <- dbConnect(RSQLite::SQLite(), dbname = "./dados_elsa/elsa.sqlite")

result <- dbGetQuery(con, "SELECT * FROM elsa") #Aqui a variavel de saida possui uma estrutura de data frame
print(result)

# disconecntar do banco de dados e liberar memória
dbDisconnect(con)