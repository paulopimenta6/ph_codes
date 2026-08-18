test_that("gs_analise_servicos devolve todos os tipos pedidos", {
  skip_if_not(tem_dados())
  tipos <- c("descritivas", "vizinho_mais_proximo", "raios_progressivos",
             "acessibilidade_media", "raio_otimo", "nni")
  a <- gs_analise_servicos(cep = "03175-001", raio_m = 2000, tipo = tipos)
  expect_true(all(tipos %in% names(a)))
  expect_true(is.data.frame(a$raios_progressivos))
  expect_true(is.data.frame(a$raio_otimo))
  expect_true(is.data.frame(a$acessibilidade_media$por_camada))
})

test_that("gs_analise_nni devolve estrutura completa", {
  skip_if_not(tem_dados())
  prox <- gs_servicos_proximos(cep = "03175-001", raio_m = 3000)
  n <- gs_analise_nni(prox)
  expect_true(n$executado)
  expect_true(all(c("indice_nni", "interpretacao", "valor_p") %in% names(n)))
  expect_true(is.numeric(n$indice_nni))
})

test_that("gs_analise_cobertura devolve area e percentual", {
  skip_if_not(tem_dados())
  prox <- gs_servicos_proximos(cep = "03175-001", raio_m = 3000)
  c <- gs_analise_cobertura(prox, attr(prox, "ponto"))
  expect_true(c$executado)
  expect_true(all(c("area_coberta_km2", "pct_cobertura", "por_camada") %in% names(c)))
})

test_that("moran sem spdep nao quebra", {
  skip_if_not(tem_dados())
  skip_if(requireNamespace("spdep", quietly = TRUE), "spdep instalado; teste de robustez ignorado")
  prox <- gs_servicos_proximos(cep = "03175-001", raio_m = 3000)
  m <- gs_analise_moran(prox)
  expect_false(m$executado)
})