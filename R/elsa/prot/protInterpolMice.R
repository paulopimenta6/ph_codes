library(mice)

# Crie um conjunto de dados de exemplo com valores faltantes
set.seed(123)
data <- data.frame(
  x = rnorm(100),
  y = rnorm(100),
  z = rnorm(100),
  w = rnorm(100)
)
data[sample(1:100, 20), "x"] <- NA
data[sample(1:100, 20), "y"] <- NA

# Impute os valores faltantes usando o método pmm
#imputed_data <- mice(data, method = 'pmm', m = 1)

# Obtenha os dados imputados
complete_data <- complete(imputed_data)

# Verifique se os valores faltantes foram imputados
summary(complete_data)
