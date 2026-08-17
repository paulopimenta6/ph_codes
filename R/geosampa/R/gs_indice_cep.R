# ============================================================
# GeoSampa — Índice local de CEP -> coordenadas
# ------------------------------------------------------------
# Constrói, a partir dos CSVs já baixados em data/, uma tabela
# que liga cada CEP às coordenadas (latitude/longitude) dos
# equipamentos públicos que o utilizam. Serve como fonte
# OFFLINE, rápida e gratuita para geocodificar CEPs.
# ============================================================

# --- Lista as camadas disponíveis localmente (nomes base dos CSVs) ---------
gs_camadas_local <- function(dir = gs_pasta_dados()) {
  gsub("\\.csv$", "", basename(list.files(dir, pattern = "\\.csv$")))
}

# --- Monta o índice local CEP -> coordenadas --------------------------------
# Varre todos os data/*.csv, mantendo UMA LINHA por ocorrência (um mesmo CEP
# pode aparecer em vários endereços/equipamentos). O resultado é cacheado na
# sessão (options); use force = TRUE para reconstruir.
# Colunas: cep, camada, latitude, longitude, nm_equipamento,
#          nm_bairro_equipamento, tx_endereco_equipamento.
gs_indice_cep <- function(dir = gs_pasta_dados(), force = FALSE) {
  cache <- getOption("gs.indice_cep")
  if (!force && !is.null(cache)) return(cache)

  arquivos <- list.files(dir, pattern = "\\.csv$", full.names = TRUE)
  if (length(arquivos) == 0) {
    stop("Nenhum arquivo CSV em ", dir,
         ". Baixe as camadas antes com gs_baixar_todos_equipamentos().")
  }

  linhas <- lapply(arquivos, function(arq) {
    camada <- gsub("\\.csv$", "", basename(arq))
    tab <- tryCatch(readr::read_csv(arq, show_col_types = FALSE),
                    error = function(e) NULL)
    if (is.null(tab)) return(NULL)
    if (!all(c("cd_cep_equipamento", "latitude", "longitude") %in% names(tab))) {
      return(NULL)  # camadas sem ponto/CEP (ex.: polígonos) são ignoradas
    }
    out <- data.frame(
      camada    = camada,
      cep       = as.character(tab$cd_cep_equipamento),
      latitude  = as.numeric(tab$latitude),
      longitude = as.numeric(tab$longitude),
      stringsAsFactors = FALSE
    )
    for (col in c("nm_equipamento", "nm_bairro_equipamento", "tx_endereco_equipamento")) {
      out[[col]] <- if (col %in% names(tab)) as.character(tab[[col]]) else NA_character_
    }
    out
  })

  idx <- do.call(rbind, Filter(Negate(is.null), linhas))
  if (is.null(idx) || nrow(idx) == 0) {
    stop("Nenhum registro com CEP e coordenadas encontrado nos CSVs de ", dir, ".")
  }

  idx$cep <- gsub("\\D", "", idx$cep)
  idx <- idx[!is.na(idx$cep) & nchar(idx$cep) == 8 &
             !is.na(idx$latitude) & !is.na(idx$longitude), , drop = FALSE]
  idx$latitude  <- as.numeric(idx$latitude)
  idx$longitude <- as.numeric(idx$longitude)
  rownames(idx) <- NULL
  idx <- idx[order(idx$cep), , drop = FALSE]

  options(gs.indice_cep = idx)
  idx
}

# --- Coordenada "representante" de cada CEP (mediana das ocorrências) -------
gs_cep_referencia <- function(indice = gs_indice_cep()) {
  if (is.null(indice) || nrow(indice) == 0) return(data.frame())
  stats::aggregate(
    cbind(latitude, longitude) ~ cep,
    data = indice,
    FUN = stats::median
  )
}