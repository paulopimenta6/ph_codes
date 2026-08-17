# ============================================================
# GeoSampa — Análises estatísticas e espaciais
# ------------------------------------------------------------
# A partir dos serviços próximos (gs_servicos_proximos), oferece
# análises descritivas e espaciais, com o tipo escolhido pelo
# usuário: descritivas, vizinho mais próximo, Voronoi/Thiessen,
# densidade de kernel, raios progressivos, autocorrelação
# espacial (Moran's I, requer spdep) e rede viária (OSRM, requer
# pacote osrm). As duas últimas avisam quando o pacote não está
# instalado, em vez de falharem.
# ============================================================

# --- Descritivas: contagens e distribuição das distâncias --------------------
gs_analise_descritivas <- function(resultado) {
  n_por_camada <- as.data.frame(table(resultado$camada))
  names(n_por_camada) <- c("camada", "n")
  rownames(n_por_camada) <- NULL

  n_por_tipo <- NULL
  if ("tipo_servico" %in% names(resultado) && !all(is.na(resultado$tipo_servico))) {
    n_por_tipo <- as.data.frame(table(resultado$tipo_servico))
    names(n_por_tipo) <- c("tipo_servico", "n")
    rownames(n_por_tipo) <- NULL
  }

  list(
    n_total          = nrow(resultado),
    n_por_camada     = n_por_camada,
    n_por_tipo       = n_por_tipo,
    resumo_distancia = summary(resultado$distancia_m),
    histograma = ggplot2::ggplot(resultado, ggplot2::aes(x = distancia_m)) +
      ggplot2::geom_histogram(bins = 20, fill = "#2c7fb8", color = "white") +
      ggplot2::labs(x = "Distância (m)", y = "Nº de serviços",
                    title = "Distribuição das distâncias") +
      ggplot2::theme_minimal(),
    boxplot = ggplot2::ggplot(resultado, ggplot2::aes(x = camada, y = distancia_m)) +
      ggplot2::geom_boxplot(fill = "#41b6c4") +
      ggplot2::labs(x = NULL, y = "Distância (m)",
                    title = "Distâncias por camada") +
      ggplot2::theme_minimal() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
  )
}

# --- Vizinho mais próximo: menor distância (geral e por camada) ---------------
gs_analise_vizinho <- function(resultado) {
  por_camada <- do.call(rbind, lapply(split(resultado, resultado$camada), function(d) {
    i <- which.min(d$distancia_m)
    data.frame(camada = d$camada[i], nome = d$nome[i],
               distancia_m = d$distancia_m[i], stringsAsFactors = FALSE)
  }))
  rownames(por_camada) <- NULL
  i <- which.min(resultado$distancia_m)
  list(
    vizinho_mais_proximo = resultado[i, , drop = FALSE],
    por_camada           = por_camada
  )
}

# --- Voronoi/Thiessen: áreas de influência dos serviços -----------------------
# Devolve um sf de polígonos (em EPSG:4326) recortado pela bbox ao redor do
# ponto. O cálculo é feito na projeção oficial (metros) — st_voronoi não
# funciona sobre coordenadas geográficas.
gs_analise_voronoi <- function(resultado, ponto) {
  pts <- sf::st_as_sf(resultado, coords = c("longitude", "latitude"),
                      crs = gs_epsg$wgs84)
  pts_utm <- sf::st_transform(pts, gs_epsg$oficial)
  ponto_utm <- sf::st_transform(ponto$sf, gs_epsg$oficial)
  bbox <- sf::st_bbox(sf::st_buffer(ponto_utm, 5000))
  envelope <- sf::st_as_sfc(bbox)
  vor <- sf::st_voronoi(sf::st_geometry(pts_utm), envelope = envelope)
  pol <- sf::st_collection_extract(vor, "POLYGON")
  pol <- sf::st_sf(geometry = pol)
  pol <- sf::st_intersection(pol, envelope)
  pol <- sf::st_transform(pol, gs_epsg$wgs84)
  pol$camada       <- pts$camada
  pol$nome         <- pts$nome
  pol$distancia_m  <- pts$distancia_m
  pol
}

# --- Densidade de kernel dos serviços -----------------------------------------
gs_analise_kde <- function(resultado, ponto) {
  ggplot2::ggplot(resultado, ggplot2::aes(x = longitude, y = latitude)) +
    ggplot2::stat_density_2d(ggplot2::aes(fill = ggplot2::after_stat(density)),
                             geom = "raster", contour = FALSE, alpha = 0.8) +
    ggplot2::scale_fill_viridis_c() +
    ggplot2::geom_point(color = "#d7301f", size = 1) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = "Densidade de kernel dos serviços",
      subtitle = sprintf("Ponto: %s", ponto$origem)
    )
}

# --- Raios progressivos: oportunidades acumuladas ------------------------------
gs_analise_raios <- function(resultado, ponto, raios = c(500, 1000, 2000)) {
  contagem <- vapply(raios, function(r) sum(resultado$distancia_m <= r), integer(1))
  data.frame(raio_m = raios, n_servicos = contagem)
}

# --- Autocorrelação espacial (Moran's I) — requer spdep ------------------------
# Nota de interpretação: aplicado à distância de cada serviço até o ponto de
# origem (radial), costuma indicar agrupamento esperado; para diagnósticos
# finos, agregue por unidade espacial (ex.: distritos) antes de usar.
gs_analise_moran <- function(resultado) {
  if (!requireNamespace("spdep", quietly = TRUE)) {
    return(list(
      executado = FALSE,
      mensagem = "Pacote 'spdep' não instalado. Instale com: install.packages('spdep')"
    ))
  }
  if (nrow(resultado) < 4) {
    return(list(executado = FALSE,
                mensagem = "Menos de 4 pontos — número insuficiente para Moran's I."))
  }
  coords <- as.matrix(resultado[, c("longitude", "latitude")])
  nb <- spdep::knn2nb(spdep::knearneigh(coords, k = min(5, nrow(resultado) - 1)))
  lw <- spdep::nb2listw(nb, style = "W")
  teste <- spdep::moran.test(resultado$distancia_m, lw, zero.policy = TRUE)
  list(
    executado = TRUE,
    moran_i   = unname(teste$estimate["Moran I statistic"]),
    valor_p   = teste$p.value,
    objeto    = teste
  )
}

# --- Distâncias por rede viária (OSRM) — requer pacote osrm --------------------
# Usa o servidor público de demonstração do OSRM; cobertura e limites se
# aplicam. Compara a distância rodoviária com a distância em linha reta.
gs_analise_rede <- function(resultado, ponto) {
  if (!requireNamespace("osrm", quietly = TRUE)) {
    return(list(
      executado = FALSE,
      mensagem = "Pacote 'osrm' não instalado. Instale com: install.packages('osrm')"
    ))
  }
  origem <- data.frame(id = "origem", lon = ponto$longitude, lat = ponto$latitude)
  destinos <- data.frame(id = as.character(seq_len(nrow(resultado))),
                         lon = resultado$longitude, lat = resultado$latitude)
  tab <- tryCatch(
    osrm::osrmTable(src = origem, dst = destinos, measure = "distance"),
    error = function(e) NULL
  )
  if (is.null(tab)) {
    return(list(
      executado = FALSE,
      mensagem = "Falha ao consultar o servidor OSRM (servidor demo pode estar fora do ar ou sem cobertura para a região)."
    ))
  }
  dist_rede_m <- round(as.numeric(tab$distances[1, ]) * 1000, 1)
  out <- data.frame(
    camada            = resultado$camada,
    nome              = resultado$nome,
    distancia_reta_m  = resultado$distancia_m,
    distancia_rede_m  = dist_rede_m,
    razao_rede_reta   = round(dist_rede_m / pmax(resultado$distancia_m, 1), 2),
    stringsAsFactors  = FALSE
  )
  list(executado = TRUE, resultado = out)
}

# --- Função principal: executa as análises escolhidas -------------------------
# Aceita vários tipos de uma vez (ex.: c("descritivas", "voronoi")) e devolve
# uma lista nomeada. Se `resultado` não for informado, calcula-o a partir dos
# demais argumentos (mesmos de gs_servicos_proximos).
gs_analise_servicos <- function(resultado = NULL, cep = NULL, coordenadas = NULL,
                                camadas = NULL, raio_m = gs_raio_padrao_m,
                                n_por_camada = NULL,
                                tipo_distancia = c("geodesica", "euclidiana",
                                                   "haversine", "manhattan"),
                                tipo = c("descritivas", "vizinho_mais_proximo",
                                         "voronoi", "kde", "raios_progressivos",
                                         "moran", "rede_viaria")) {
  tipo <- match.arg(tipo, several.ok = TRUE)
  if (is.null(resultado)) {
    resultado <- gs_servicos_proximos(
      cep = cep, coordenadas = coordenadas, camadas = camadas,
      raio_m = raio_m, n_por_camada = n_por_camada,
      tipo_distancia = tipo_distancia
    )
  }
  ponto <- attr(resultado, "ponto")
  if (is.null(ponto)) {
    stop("`resultado` não tem o atributo 'ponto'. Use a saída de gs_servicos_proximos().")
  }

  saida <- list()
  if ("descritivas" %in% tipo)        saida$descritivas        <- gs_analise_descritivas(resultado)
  if ("vizinho_mais_proximo" %in% tipo) saida$vizinho_mais_proximo <- gs_analise_vizinho(resultado)
  if ("voronoi" %in% tipo)            saida$voronoi            <- gs_analise_voronoi(resultado, ponto)
  if ("kde" %in% tipo)                saida$kde                <- gs_analise_kde(resultado, ponto)
  if ("raios_progressivos" %in% tipo) saida$raios_progressivos <- gs_analise_raios(resultado, ponto)
  if ("moran" %in% tipo)              saida$moran              <- gs_analise_moran(resultado)
  if ("rede_viaria" %in% tipo)        saida$rede_viaria        <- gs_analise_rede(resultado, ponto)
  saida
}