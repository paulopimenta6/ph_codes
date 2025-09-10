# Função para padronizar uma variável
padronizar <- function(x) {
  media <- mean(x, na.rm = TRUE)
  desvio_padrao <- sd(x, na.rm = TRUE)
  x_padronizado <- (x - media) / desvio_padrao
  return(x_padronizado)
}
# Exemplo de uso
# Criando um vetor de exemplo
#dados <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
# Padronizando o vetor de exemplo
#dados_padronizados <- padronizar(dados)
# Exibindo os dados padronizados
#print(dados_padronizados)
#print(summary(dados_padronizados))
#print(shapiro.test(dados_padronizados))
################################################################################
################################################################################
# Função para normalizar uma variável para o intervalo [0, 1]
normalizar <- function(x) {
  min_val <- min(x, na.rm = TRUE)
  max_val <- max(x, na.rm = TRUE)
  x_normalizado <- (x - min_val) / (max_val - min_val)
  return(x_normalizado)
}
# Exemplo de uso
# Criando um vetor de exemplo
#dados <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
# Normalizando o vetor de exemplo
#dados_normalizados <- normalizar(dados)
# Exibindo os dados normalizados
#print(dados_normalizados)
################################################################################
################################################################################
# Função para identificar outliers em um vetor numérico
identify_outliers_vector <- function(vector) {
  Q1 <- quantile(vector, 0.25, na.rm = TRUE)
  Q3 <- quantile(vector, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  return(ifelse(vector < lower_bound | vector > upper_bound, TRUE, FALSE))
}