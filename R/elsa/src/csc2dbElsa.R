if(!require(pacman)) install.packages("pacman")
pacman::p_load(readr, RSQLite)

data <- read_csv2("./dados_elsa/Lucia_Andrade_10_22_CSV.csv")
con <- dbConnect(RSQLite::SQLite(), dbname = "./dados_elsa/elsa.sqlite")
dbWriteTable(con, "elsa", data)

# disconecntar do banco de dados e liberar memória
dbDisconnect(con) 