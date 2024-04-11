# Lista de pacotes a serem verificados e instalados
pacotes <- c(
  "tidyverse", "readr", "devtools", "ropensci/qualR",
  "vioplot", "corrplot", "gmodels", "matrixStats", "lmPerm",
  "pwr", "FNN", "DMwR", "xgboost", "ellipse", "mclust", "ca",
  "ggrepel", "klaR", "hexbin", "RVAideMemoire", "car"
)

# Verifica se os pacotes estão instalados e instala-os se não estiverem
pacotes_instalados <- installed.packages()[, "Package"]
pacotes_faltantes <- pacotes[!(pacotes %in% pacotes_instalados)]

if (length(pacotes_faltantes) > 0) {
  install.packages(pacotes_faltantes)
} else {
  print("Todos os pacotes estão instalados.")
}
