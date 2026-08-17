# ============================================================
# GeoSampa — CEP: leitura, geocodificação e verificação
# ------------------------------------------------------------
# Funcionalidades:
#   1. Normalizar e validar um CEP (viaCEP, sem chave de acesso).
#   2. Obter a coordenada geográfica do CEP (índice local offline
#      ou Nominatim/OpenStreetMap como fallback).
#   3. Verificar se uma coordenada informada confere com um CEP.
# ============================================================

# --- Normaliza um CEP para 8 dígitos ---------------------------------------
gs_normalizar_cep <- function(cep) {
  cep <- gsub("[^0-9]", "", as.character(cep))
  if (nchar(cep) != 8) {
    stop("CEP inválido: '", cep, "'. Informe 8 dígitos (ex.: 03175001 ou 03175-001).")
  }
  cep
}

# --- Máscara 00000-000 -------------------------------------------------------
gs_cep_mascarado <- function(cep) {
  paste0(substr(cep, 1, 5), "-", substr(cep, 6, 8))
}

# --- Lê e valida um CEP no serviço público viaCEP ---------------------------
# Devolve endereço, bairro, cidade, UF e código IBGE.
gs_ler_cep <- function(cep) {
  cep <- gs_normalizar_cep(cep)
  url <- sub("{cep}", cep, gs_urls$viacep, fixed = TRUE)
  resp <- httr::GET(url, httr::timeout(30))
  httr::stop_for_status(resp)
  dados <- jsonlite::fromJSON(
    httr::content(resp, as = "text", encoding = "UTF-8"),
    simplifyVector = FALSE
  )
  if (!is.null(dados$erro) &&
      (isTRUE(dados$erro) || identical(as.character(dados$erro), "true"))) {
    stop("CEP ", gs_cep_mascarado(cep), " não encontrado na base do viaCEP.")
  }
  campo <- function(nm) {
    if (is.null(dados[[nm]])) NA_character_ else as.character(dados[[nm]])
  }
  data.frame(
    cep       = gs_cep_mascarado(cep),
    logradouro = campo("logradouro"),
    bairro     = campo("bairro"),
    cidade     = campo("localidade"),
    uf         = campo("uf"),
    ibge       = campo("ibge"),
    stringsAsFactors = FALSE
  )
}

# --- Coordenadas (lat/long) de um CEP ----------------------------------------
# Cascata de fontes:
#   1. "local"       -> índice local construído dos data/*.csv (offline);
#   2. "nominatim"   -> busca por código postal no OpenStreetMap (fallback).
# Retorna data.frame com cep, latitude, longitude, fonte e precisão.
gs_cep_para_coordenadas <- function(cep, fonte = c("local", "nominatim")) {
  fonte <- match.arg(fonte)
  cep <- gs_normalizar_cep(cep)
  cep_masc <- gs_cep_mascarado(cep)

  if (fonte == "local") {
    ref <- gs_cep_referencia()
    achou <- ref[ref$cep == cep, , drop = FALSE]
    if (nrow(achou) > 0) {
      return(data.frame(
        cep       = cep_masc,
        latitude  = as.numeric(achou$latitude[1]),
        longitude = as.numeric(achou$longitude[1]),
        fonte     = "local",
        precisao  = "coordenada mediana do índice local (equipamentos públicos)",
        stringsAsFactors = FALSE
      ))
    }
    message("CEP ", cep_masc, " não está no índice local. Consultando o Nominatim/OSM...")
  }

  # Fallback / fonte direta: Nominatim (política: User-Agent identificado e
  # ~1 requisição por segundo entre chamadas).
  resp <- httr::GET(
    gs_urls$nominatim,
    query = list(postalcode = cep_masc, country = "Brazil",
                 format = "json", limit = "1"),
    httr::user_agent("geosampaR/1.0 (contato: paulopimenta6@gmail.com)"),
    httr::timeout(30)
  )
  httr::stop_for_status(resp)
  dados <- jsonlite::fromJSON(
    httr::content(resp, as = "text", encoding = "UTF-8"),
    simplifyVector = FALSE
  )
  if (length(dados) == 0) {
    stop("Não consegui obter coordenadas para o CEP ", cep_masc, ".")
  }
  Sys.sleep(gs_pausa_nominatim_s)
  data.frame(
    cep       = cep_masc,
    latitude  = as.numeric(dados[[1]]$lat),
    longitude = as.numeric(dados[[1]]$lon),
    fonte     = "nominatim",
    precisao  = "coordenada aproximada do código postal (OpenStreetMap)",
    stringsAsFactors = FALSE
  )
}

# --- Resolve um ponto de interesse a partir de CEP ou coordenadas -----------
# Uso interno do módulo: devolve lista com latitude, longitude, origem (rótulo)
# e o ponto como objeto sf (EPSG:4326).
gs_resolver_ponto <- function(cep = NULL, coordenadas = NULL) {
  if (!is.null(cep)) {
    coord <- gs_cep_para_coordenadas(cep)
    lat <- coord$latitude
    lon <- coord$longitude
    origem <- paste0("CEP ", coord$cep, " (fonte: ", coord$fonte, ")")
  } else if (!is.null(coordenadas)) {
    if (length(coordenadas) != 2 || any(is.na(coordenadas))) {
      stop("`coordenadas` deve ser um vetor c(latitude, longitude).")
    }
    lat <- as.numeric(coordenadas[1])
    lon <- as.numeric(coordenadas[2])
    origem <- "coordenadas informadas"
  } else {
    stop("Informe `cep` ou `coordenadas = c(latitude, longitude)`.")
  }
  list(
    latitude  = lat,
    longitude = lon,
    origem    = origem,
    sf        = sf::st_sfc(sf::st_point(c(lon, lat)), crs = gs_epsg$wgs84)
  )
}

# --- Verifica se uma coordenada confere com um CEP ---------------------------
# Compara a coordenada informada com a(s) coordenada(s) de referência do CEP
# (índice local; se ausente, usa o Nominatim). Devolve uma lista com a
# distância mínima e o veredito dentro da tolerância.
gs_verificar_cep <- function(cep, latitude, longitude,
                             tolerancia_m = gs_tolerancia_cep_m) {
  cep <- gs_normalizar_cep(cep)
  if (is.na(latitude) || is.na(longitude)) {
    stop("Informe latitude e longitude válidas.")
  }
  ponto <- sf::st_sfc(sf::st_point(c(longitude, latitude)), crs = gs_epsg$wgs84)

  indice <- gs_indice_cep()
  ocorrencias <- indice[indice$cep == cep, , drop = FALSE]

  if (nrow(ocorrencias) > 0) {
    pts <- sf::st_as_sf(ocorrencias, coords = c("longitude", "latitude"),
                        crs = gs_epsg$wgs84)
    dists <- as.numeric(sf::st_distance(ponto, pts))
    i <- which.min(dists)
    dmin <- dists[i]
    return(list(
      cep                    = gs_cep_mascarado(cep),
      latitude_cep           = ocorrencias$latitude[i],
      longitude_cep          = ocorrencias$longitude[i],
      distancia_m            = round(dmin, 1),
      confere                = dmin <= tolerancia_m,
      veredito               = if (dmin <= tolerancia_m) "CONFERE" else "NAO CONFERE",
      tolerancia_m           = tolerancia_m,
      n_ocorrencias          = nrow(ocorrencias),
      equipamento_referencia = ocorrencias$nm_equipamento[i],
      camada_referencia      = ocorrencias$camada[i]
    ))
  }

  ref <- gs_cep_para_coordenadas(cep, fonte = "nominatim")
  ref_pt <- sf::st_sfc(sf::st_point(c(ref$longitude, ref$latitude)),
                       crs = gs_epsg$wgs84)
  d <- as.numeric(sf::st_distance(ponto, ref_pt))
  list(
    cep                    = gs_cep_mascarado(cep),
    latitude_cep           = ref$latitude,
    longitude_cep          = ref$longitude,
    distancia_m            = round(d, 1),
    confere                = d <= tolerancia_m,
    veredito               = if (d <= tolerancia_m) "CONFERE" else "NAO CONFERE",
    tolerancia_m           = tolerancia_m,
    n_ocorrencias          = 0L,
    equipamento_referencia = NA_character_,
    camada_referencia      = NA_character_
  )
}