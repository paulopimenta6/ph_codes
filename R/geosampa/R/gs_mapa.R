# ============================================================
# GeoSampa — Mapas do ponto de interesse e serviços próximos
# ------------------------------------------------------------
# Gera mapas estáticos (ggplot2 -> PNG/PDF) ou interativos
# (leaflet -> HTML) com o ponto do CEP, o raio de busca e os
# serviços próximos encontrados por gs_servicos_proximos().
# ============================================================

# --- Popups HTML dos serviços (mapa interativo) ------------------------------
gs_popup_servicos <- function(resultado) {
  vapply(seq_len(nrow(resultado)), function(i) {
    r <- resultado[i, ]
    sprintf("<b>%s</b><br>Tipo: %s<br>Endereço: %s<br>Bairro: %s<br>Distância: %.0f m<br>Camada: %s",
            r$nome, r$tipo_servico, r$endereco, r$bairro,
            r$distancia_m, r$camada)
  }, character(1))
}

# --- Mapa estático com ggplot2 ----------------------------------------------
gs_mapa_ggplot <- function(resultado, ponto, raio_m) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Pacote 'ggplot2' não instalado. Instale com install.packages('ggplot2').")
  }
  pts <- sf::st_as_sf(resultado, coords = c("longitude", "latitude"),
                      crs = gs_epsg$wgs84)
  origem <- sf::st_sfc(sf::st_point(c(ponto$longitude, ponto$latitude)),
                       crs = gs_epsg$wgs84)
  buffer <- sf::st_transform(
    sf::st_buffer(sf::st_transform(origem, gs_epsg$oficial), raio_m),
    gs_epsg$wgs84
  )

  cores <- if ("tipo_servico" %in% names(resultado) &&
               !all(is.na(resultado$tipo_servico))) "tipo_servico" else "camada"

  ggplot2::ggplot() +
    ggplot2::geom_sf(data = buffer, fill = "#2c7fb8", alpha = 0.08,
                     color = "#2c7fb8", linetype = "dashed") +
    ggplot2::geom_sf(data = pts, ggplot2::aes(color = .data[[cores]]),
                     size = 2, alpha = 0.9) +
    ggplot2::geom_sf(data = origem, color = "#d7301f", size = 3.5) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = "Serviços próximos",
      subtitle = sprintf("Ponto: %s | Raio: %s m | %d serviço(s)",
                         ponto$origem, raio_m, nrow(resultado)),
      color = "Tipo de serviço",
      caption = "Fonte: Prefeitura de São Paulo / GeoSampa"
    )
}

# --- Mapa interativo com leaflet ---------------------------------------------
gs_mapa_leaflet <- function(resultado, ponto, raio_m) {
  if (!requireNamespace("leaflet", quietly = TRUE)) {
    stop("Pacote 'leaflet' não instalado. Instale com install.packages('leaflet').")
  }
  cores <- if ("tipo_servico" %in% names(resultado) &&
               !all(is.na(resultado$tipo_servico))) resultado$tipo_servico else resultado$camada
  # "Paired" (RColorBrewer) só vai até 12 níveis; com mais tipos de serviço,
  # usa uma paleta qualitativa do grDevices (base R) sem limite prático.
  n_niveis <- length(unique(cores[!is.na(cores)]))
  pal <- if (n_niveis <= 12) {
    leaflet::colorFactor("Paired", domain = factor(cores))
  } else {
    leaflet::colorFactor(
      grDevices::hcl.colors(max(n_niveis, 3), palette = "Set 2"),
      domain = factor(cores)
    )
  }

  leaflet::leaflet() |>
    leaflet::addTiles() |>
    leaflet::addCircles(lng = ponto$longitude, lat = ponto$latitude,
                        radius = raio_m, color = "#2c7fb8", weight = 1,
                        opacity = 0.6, fillOpacity = 0.08, dashArray = "4 4") |>
    leaflet::addCircleMarkers(lng = ponto$longitude, lat = ponto$latitude,
                              color = "#d7301f", radius = 8, fillOpacity = 0.9,
                              popup = sprintf("<b>Ponto de interesse</b><br>%s",
                                              ponto$origem)) |>
    leaflet::addCircleMarkers(lng = resultado$longitude, lat = resultado$latitude,
                              color = pal(cores), radius = 5, fillOpacity = 0.8,
                              popup = gs_popup_servicos(resultado)) |>
    leaflet::addLegend("bottomright", pal = pal, values = cores,
                       title = "Tipo de serviço", opacity = 1)
}

# --- Função principal: gera o mapa (estático ou interativo) ------------------
# Se `resultado` (vindo de gs_servicos_proximos) não for informado, os demais
# argumentos (cep/coordenadas/camadas/raio...) são usados para calculá-lo.
# `salvar`: caminho do arquivo de saída — .html para interativo, .png/.pdf
# para estático. Se NULL, apenas devolve o objeto de plot invisivelmente.
gs_mapa_servicos <- function(resultado = NULL, cep = NULL, coordenadas = NULL,
                             camadas = NULL, raio_m = gs_raio_padrao_m,
                             tipo_distancia = c("geodesica", "euclidiana",
                                                "haversine", "manhattan"),
                             n_por_camada = NULL, interativo = TRUE,
                             salvar = NULL) {
  if (is.null(resultado)) {
    resultado <- gs_servicos_proximos(
      cep = cep, coordenadas = coordenadas, camadas = camadas,
      raio_m = raio_m, n_por_camada = n_por_camada,
      tipo_distancia = tipo_distancia
    )
  }
  ponto <- attr(resultado, "ponto")
  raio <- attr(resultado, "raio_m")
  if (is.null(raio)) raio <- raio_m

  mapa <- if (interativo) {
    gs_mapa_leaflet(resultado, ponto, raio)
  } else {
    gs_mapa_ggplot(resultado, ponto, raio)
  }

  if (!is.null(salvar)) {
    dir.create(dirname(salvar), showWarnings = FALSE, recursive = TRUE)
    if (interativo) {
      if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
        stop("Pacote 'htmlwidgets' não instalado para salvar o mapa interativo.")
      }
      htmlwidgets::saveWidget(mapa, file = salvar)
    } else {
      ggplot2::ggsave(salvar, plot = mapa, width = 8, height = 8, dpi = 150)
    }
    message("Mapa salvo em: ", salvar)
  }
  invisible(mapa)
}