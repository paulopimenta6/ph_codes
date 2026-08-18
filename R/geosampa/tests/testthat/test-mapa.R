test_that("gs_mapa_servicos valida resultado sem atributo ponto", {
  df <- data.frame(nome = "x", distancia_m = 5,
                   latitude = -23.55, longitude = -46.58, camada = "a")
  expect_error(gs_mapa_servicos(df, interativo = FALSE), "atributo 'ponto'")
})

test_that("gs_analise_servicos valida resultado sem atributo ponto", {
  df <- data.frame(nome = "x", distancia_m = 5,
                   latitude = -23.55, longitude = -46.58, camada = "a")
  expect_error(gs_analise_servicos(df, tipo = "descritivas"), "atributo 'ponto'")
})

test_that("gs_tipos_distancia lista os cinco tipos", {
  t <- gs_tipos_distancia()
  expect_true(all(c("geodesica", "euclidiana", "haversine", "manhattan",
                    "rede_viaria") %in% t$tipo))
})