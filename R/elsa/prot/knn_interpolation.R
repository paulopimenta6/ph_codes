if(!require(VIM)) install.packages("VIM")
library(VIM)

# Exemplo de um data frame com valores ausentes
your_data <- data.frame(
  group = factor(c("A", "A", "B", "B", "C", "C")),
  value1 = c(10, NA, 8, 9, NA, 7),
  value2 = c(3, 4, NA, 5, 6, NA)
)

# Imputar valores ausentes usando kNN
your_data_imputed <- kNN(your_data, k = 3)

# Remover a coluna adicional gerada pelo kNN que indica quais valores foram imputados
your_data_imputed <- your_data_imputed[, !grepl("_imp", names(your_data_imputed))]

print(your_data_imputed)