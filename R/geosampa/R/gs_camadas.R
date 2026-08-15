# ============================================================
# GeoSampa — Catálogo de camadas (GetCapabilities)
# ------------------------------------------------------------
# Pergunta ao serviço WFS quais camadas existem e organiza
# um "cardápio" de dados. Também localiza as camadas de
# equipamentos públicos (as que têm prefixo equipamento_*).
# ============================================================

# --- Consulta o GetCapabilities e monta o catálogo -------------------------
# O resultado é um data.frame com: camada (nome técnico), titulo, resumo e crs.
gs_camadas_disponiveis <- function(force = FALSE) {
  cache <- file.path(tempdir(), "gs_cap_wfs.xml")

  if (!force && file.exists(cache) &&
      difftime(Sys.time(), file.info(cache)$mtime, units = "hours") < 1) {
    txt <- readLines(cache, warn = FALSE, encoding = "UTF-8")
  } else {
    resp <- httr::GET(gs_urls$wfs, query = list(
      service = "WFS", version = "2.0.0", request = "GetCapabilities"
    ))
    httr::stop_for_status(resp)
    txt <- httr::content(resp, as = "text", encoding = "UTF-8")
    writeLines(txt, cache)
  }

  xml <- xml2::read_xml(paste(txt, collapse = "\n"))
  ns  <- xml2::xml_ns(xml)
  fts <- xml2::xml_find_all(xml, ".//wfs:FeatureType", ns)

  extrair <- function(p) {
    x <- xml2::xml_find_first(fts, p, ns)
    xml2::xml_text(x)
  }

  data.frame(
    camada = extrair("./wfs:Name"),
    titulo = extrair("./wfs:Title"),
    resumo = extrair("./wfs:Abstract"),
    crs    = extrair("./wfs:DefaultCRS"),
    stringsAsFactors = FALSE
  )
}

# --- Filtra apenas as camadas de equipamentos públicos ----------------------
# As camadas de equipamentos seguem o padrão "equipamento_*" (UBS, CEU, CRAS,
# hospitais, bibliotecas, centros esportivos, feiras livres etc.).
gs_camadas_equipamentos <- function(force = FALSE) {
  catalogo <- gs_camadas_disponiveis(force = force)
  catalogo[grepl("equipamento_", catalogo$camada, ignore.case = TRUE), , drop = FALSE]
}

# --- Busca camadas por palavra-chave no título ou nome ----------------------
# Ex.: gs_buscar_camadas("saude") ou gs_buscar_camadas("educação")
gs_buscar_camadas <- function(termo, force = FALSE) {
  catalogo <- gs_camadas_disponiveis(force = force)
  sel <- grepl(termo, catalogo$camada, ignore.case = TRUE) |
         grepl(termo, catalogo$titulo, ignore.case = TRUE)
  catalogo[sel, , drop = FALSE]
}

# --- Devolve o "cardápio" amigável de equipamentos --------------------------
gs_catalogo_equipamentos <- function(force = FALSE) {
  eq <- gs_camadas_equipamentos(force = force)
  eq$tema <- gsub("^equipamento_([a-z_]+?)(_.*)?$", "\\1", eq$camada)
  eq[order(eq$tema, eq$titulo), c("camada", "tema", "titulo", "resumo")]
}