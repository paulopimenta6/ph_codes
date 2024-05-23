if(!require(zoo)) install.packages("zoo")
library(zoo)

# Exemplo de um data frame com valores ausentes
your_data <- data.frame(
  group = factor(c("A", "A", "B", "B", "C", "C")),
  value1 = c(10, NA, 8, 9, NA, 7),
  value2 = c(3, 4, NA, 5, 6, NA)
)

# Função para aplicar na.approx e na.locf apenas nas colunas numéricas
interpolate_na <- function(df) {
  df[] <- lapply(df, function(col) {
    if (is.numeric(col)) {
      # Primeiro preenche os valores ausentes usando na.approx
      col <- na.approx(col, na.rm = FALSE)
      # Depois preenche os valores restantes com na.locf
      col <- na.locf(col, na.rm = FALSE)
      col <- na.locf(col, na.rm = FALSE, fromLast = TRUE)
    }
    return(col)
  })
  return(df)
}

# Aplicar a função de interpolação ao data frame
your_data_imputed <- interpolate_na(your_data)

print(your_data_imputed)