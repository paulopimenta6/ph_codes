if(!require(pacman)) install.packages("pacman")
pacman::p_load(readr, RSQLite)

# Criar ou conectar ao banco de dados
con <- dbConnect(RSQLite::SQLite(), dbname = "./dados_elsa/elsa.sqlite")

result <- dbGetQuery(con, "SELECT IDELSA FROM elsa")
print(result)

# disconecntar do banco de dados e liberar memória
dbDisconnect(con)