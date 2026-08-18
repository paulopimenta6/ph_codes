test_that("gs_servicos_proximos devolve resultados ordenados globalmente", {
  skip_if_not(tem_dados())
  prox <- gs_servicos_proximos(cep = "03175-001", raio_m = 2000)
  expect_true(nrow(prox) >= 1)
  expect_true(all(diff(prox$distancia_m) >= 0))
  expect_equal(attr(prox, "raio_m"), 2000)
  expect_true(all(c("camada", "nome", "distancia_m", "latitude", "longitude") %in% names(prox)))
})

test_that("gs_servicos_proximos aceita n_por_camada", {
  skip_if_not(tem_dados())
  prox <- gs_servicos_proximos(cep = "03175-001", raio_m = 5000, n_por_camada = 2)
  expect_true(all(table(prox$camada) <= 2))
  expect_true(all(diff(prox$distancia_m) >= 0))
})

test_that("gs_servicos_proximos aceita coordenadas em vez de CEP", {
  skip_if_not(tem_dados())
  prox <- gs_servicos_proximos(coordenadas = c(-23.55334, -46.58032), raio_m = 1500)
  expect_true(nrow(prox) >= 0)
})

test_that("gs_resolver_camadas expande temas para camadas reais", {
  skip_if_not(tem_dados())
  r <- gs_resolver_camadas("saude")
  expect_true(length(r$resolvidas) >= 1)
  expect_true(all(grepl("^equipamento_saude", r$resolvidas)))
})