#!/usr/bin/env Rscript
#'
#' Regressão Logística Binária — Implementação em R (foco analítico)
#'
#' Análise completa: estimação, interpretação de coeficientes/OR,
#' efeitos marginais (AME e MEM), pseudo-R², AIC/BIC, testes TRV e Wald,
#' Hosmer-Lemeshow, diagnóstico de resíduos e predição.
#'
#' Ajuste as variáveis de configuração e execute:
#'     Rscript 07_implementacao_r.R
#'
#' (Parte do tutorial "Regressão Logística Binária — Análise",
#'  capítulos 1 a 9 na documentação. Rode junto com o script Python
#'  equivalente na mesma pasta para comparar os resultados — ambos
#'  compartilham o mesmo dados.csv.)

# ════════════════════════════════════════════════════════════
#  CONFIGURAÇÃO — ajuste apenas estas variáveis
# ════════════════════════════════════════════════════════════
CAMINHO_CSV       <- "dados.csv"
VARIAVEL_RESPOSTA <- "y"
VARIAVEIS_PRED    <- c("x1", "x2")
LIMIAR_DECISAO    <- 0.5
PROPORCAO_TESTE   <- 0.30
SEMENTE           <- 42
# ════════════════════════════════════════════════════════════

# Pacotes necessários
pacotes_necessarios <- c("tidyverse", "caret", "pROC", "broom", "gridExtra")

for (pkg in pacotes_necessarios) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Instalando", pkg, "...\n")
    install.packages(pkg, repos = "https://cloud.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

options(warn = -1)
set.seed(SEMENTE)

# ════════════════════════════════════════════════════════════
#  1. CRIAR DADOS SIMULADOS
# ════════════════════════════════════════════════════════════

criar_dados_simulados <- function() {
  if (file.exists(CAMINHO_CSV)) return()

  cat("Arquivo não encontrado — gerando dados simulados.\n")
  n <- 350
  x1 <- round(runif(n, 18, 65), 1)
  x2 <- round(rnorm(n, 50, 10), 1)
  z  <- 0.07 * x1 + 0.06 * x2 - 7.0
  p  <- 1 / (1 + exp(-z))
  y  <- rbinom(n, 1, p)

  df <- tibble(y = y, x1 = x1, x2 = x2)
  write_csv(df, CAMINHO_CSV)
  cat("✓", paste0("'", CAMINHO_CSV, "'"), "criado com", n, "observações.\n\n")
}

# ════════════════════════════════════════════════════════════
#  2. CARREGAR E VALIDAR DADOS
# ════════════════════════════════════════════════════════════

carregar_dados <- function() {
  dados_raw <- read_csv(CAMINHO_CSV, show_col_types = FALSE)

  cat("Dataset:", nrow(dados_raw), "linhas x", ncol(dados_raw), "colunas\n")
  cat("Colunas:", paste(names(dados_raw), collapse = ", "), "\n\n")

  cols_necessarias <- c(VARIAVEL_RESPOSTA, VARIAVEIS_PRED)
  cols_faltando <- setdiff(cols_necessarias, names(dados_raw))
  if (length(cols_faltando) > 0) {
    stop("Colunas ausentes: ", paste(cols_faltando, collapse = ", "),
         "\nAjuste VARIAVEL_RESPOSTA e VARIAVEIS_PRED.")
  }

  dados <- dados_raw %>%
    select(all_of(cols_necessarias)) %>%
    rename(y = VARIAVEL_RESPOSTA) %>%
    mutate(y = as.integer(y)) %>%
    drop_na()

  n_antes <- nrow(dados_raw)
  n_depois <- nrow(dados)
  if (n_antes > n_depois) {
    cat("Removidas", n_antes - n_depois, "linha(s) com NA.\n\n")
  }

  N1 <- sum(dados$y == 1)
  N0 <- sum(dados$y == 0)
  N  <- nrow(dados)

  cat("Classe 1:", N1, paste0("(", round(100 * N1 / N, 1), "%)"),
      "| Classe 0:", N0, paste0("(", round(100 * N0 / N, 1), "%)\n\n"))

  return(list(dados = dados, N1 = N1, N0 = N0, N = N))
}

# ════════════════════════════════════════════════════════════
#  2b. REGRA EPV — EVENTOS POR PARÂMETRO (Capítulo 1)
# ════════════════════════════════════════════════════════════

verificar_epv <- function(N1, N0) {
  n_param <- length(VARIAVEIS_PRED) + 1
  minimo  <- 10 * n_param
  # eventos = categoria minoritária (cenário mais conservador)
  eventos_dados <- min(N1, N0)

  if (eventos_dados < minimo) {
    cat(sprintf(
      "⚠️  CUIDADO (EPV): %d eventos disponíveis para %d parâmetros.\n",
      eventos_dados, n_param))
    cat(sprintf(
      "    Regra do Capítulo 1 pede ~10 eventos por parâmetro (recomendado: >= %d).\n",
      minimo))
    cat("    Wald e valor-p perdem confiabilidade — volte ao Capítulo 5.\n\n")
  } else {
    cat(sprintf(
      "✓ EPV ok: %d eventos para %d parâmetros — respeita a regra dos ~10.\n\n",
      eventos_dados, n_param))
  }
}

# ════════════════════════════════════════════════════════════
#  3. ANÁLISE EXPLORATÓRIA
# ════════════════════════════════════════════════════════════

analise_exploratoria <- function(dados) {
  cores <- c("0" = "#C0392B", "1" = "#27AE60")

  p_disp <- dados %>%
    mutate(classe = factor(y, labels = c("Fracasso (0)", "Sucesso (1)"))) %>%
    ggplot(aes(x = !!sym(VARIAVEIS_PRED[1]),
               y = !!sym(VARIAVEIS_PRED[2]),
               color = classe)) +
    geom_point(alpha = 0.65, size = 2.5) +
    scale_color_manual(values = c("Fracasso (0)" = "#C0392B",
                                  "Sucesso (1)" = "#27AE60")) +
    labs(title = "Dispersão por Classe", color = NULL) +
    theme_minimal() +
    theme(legend.position = "bottom")

  plots_box <- lapply(VARIAVEIS_PRED, function(var) {
    dados %>%
      mutate(classe = factor(y, labels = c("Fracasso (0)", "Sucesso (1)"))) %>%
      ggplot(aes(x = classe, y = !!sym(var), fill = classe)) +
      geom_boxplot(alpha = 0.75, outlier.alpha = 0.5) +
      scale_fill_manual(values = c("Fracasso (0)" = "#C0392B",
                                   "Sucesso (1)" = "#27AE60")) +
      labs(title = paste("Distribuição de", var), x = NULL, y = var) +
      theme_minimal() +
      theme(legend.position = "none")
  })

  # Monta a figura num device png explícito (o texto é medido ali, evitando
# que o R abra Rplots.pdf), depois salva via ggsave.
  png(tempfile(fileext = ".png"), width = 1300, height = 450, res = 150)
  fig <- do.call(gridExtra::arrangeGrob,
                 c(list(p_disp), plots_box, list(nrow = 1)))
  dev.off()
  ggsave("r_eda.png", fig, width = 13, height = 4.5, dpi = 150)
  cat("Gráfico: r_eda.png\n\n")

  invisible(fig)
}

# ════════════════════════════════════════════════════════════
#  4. DIVIDIR EM TREINO E TESTE
# ════════════════════════════════════════════════════════════

dividir_dados <- function(dados) {
  set.seed(SEMENTE)
  indice_treino <- caret::createDataPartition(
    dados$y, times = 1, p = 1 - PROPORCAO_TESTE, list = FALSE
  )
  dados_tr <- dados[indice_treino, ]
  dados_te <- dados[-indice_treino, ]

  cat("Treino:", nrow(dados_tr), "obs. | Teste:", nrow(dados_te), "obs.\n\n")
  list(tr = dados_tr, te = dados_te)
}

# ════════════════════════════════════════════════════════════
#  5. AJUSTAR MODELO
# ════════════════════════════════════════════════════════════

ajustar_modelo <- function(dados_tr) {
  formula_str <- paste("y ~", paste(VARIAVEIS_PRED, collapse = " + "))
  modelo <- glm(as.formula(formula_str), data = dados_tr,
                family = binomial(link = "logit"))

  cat("Modelo ajustado por MV (IRLS).\n")
  cat("Fórmula:", formula_str, "\n\n")

  print(summary(modelo))
  cat("\n")

  invisible(modelo)
}

# ════════════════════════════════════════════════════════════
#  6. TABELA DE COEFICIENTES E ODDS RATIOS
# ════════════════════════════════════════════════════════════

tabela_coeficientes <- function(modelo) {
  coef_tidy <- tidy(modelo, conf.int = TRUE, exponentiate = FALSE)

  tab <- coef_tidy %>%
    mutate(
      OR    = exp(estimate),
      IC_OR_2.5  = exp(conf.low),
      IC_OR_97.5 = exp(conf.high)
    ) %>%
    select(term, estimate, std.error, OR, IC_OR_2.5, IC_OR_97.5, p.value) %>%
    rename(
      "Variável" = term,
      "Coeficiente" = estimate,
      "Erro_Padrão" = std.error,
      "OR" = OR,
      "IC_2.5_OR" = IC_OR_2.5,
      "IC_97.5_OR" = IC_OR_97.5,
      "Valor_p" = p.value
    ) %>%
    mutate(across(where(is.numeric), ~ round(., 4)))

  cat("Tabela 1. Coeficientes e Odds Ratios com IC 95%\n")
  cat("Interpretação: OR > 1 aumenta os odds; OR < 1 reduz os odds.\n")
  cat("Se o IC 95% do OR excluir 1, efeito significativo (p < 0,05).\n\n")
  print(tab)
  cat("\n")

  invisible(tab)
}

# ════════════════════════════════════════════════════════════
#  7. EFEITOS MARGINAIS — AME E MEM (Capítulo 2)
# ════════════════════════════════════════════════════════════

efeitos_marginais <- function(modelo) {
  pi_hat <- predict(modelo, type = "response")
  betas <- coef(modelo)
  matriz_x <- model.matrix(modelo)
  x_bar <- colMeans(matriz_x)
  pi_bar <- 1 / (1 + exp(-sum(x_bar * betas)))

  cat("Efeitos Marginais\n")
  cat("  AME = média dos efeitos nas observações | MEM = efeito na média das preditoras\n")
  for (j in seq_along(VARIAVEIS_PRED)) {
    nome_var <- VARIAVEIS_PRED[j]
    beta_j <- betas[nome_var]
    if (is.na(beta_j)) next
    ame <- mean(pi_hat * (1 - pi_hat) * beta_j)
    mem <- pi_bar * (1 - pi_bar) * beta_j
    cat(sprintf("  AME(%s) = %.4f | MEM(%s) = %.4f\n",
                nome_var, ame, nome_var, mem))
  }
  cat(sprintf("  Probabilidade prevista na média das preditoras: pi_bar = %.4f\n", pi_bar))
  cat("  Interpretação: variação média na probabilidade do evento\n")
  cat("  para aumento de 1 unidade na preditora (em pontos percentuais).\n\n")

  invisible(list(pi_bar = pi_bar))
}

# ════════════════════════════════════════════════════════════
#  8. PSEUDO-R² DE McFADDEN, AIC, BIC, DEVIANCE
# ════════════════════════════════════════════════════════════

medidas_ajuste <- function(modelo) {
  L_star <- logLik(modelo)[1]
  dados_ajuste <- model.frame(modelo)
  N <- nrow(dados_ajuste)
  N1 <- sum(dados_ajuste$y == 1)
  N0 <- N - N1
  L0 <- N1 * log(N1) + N0 * log(N0) - N * log(N)

  r2_mcf <- 1 - L_star / L0
  aic <- AIC(modelo)
  bic <- BIC(modelo)

  cat("Medidas de Ajuste do Modelo\n")
  cat(sprintf("L* (modelo)          = %.4f\n", L_star))
  cat(sprintf("L0 (nulo)            = %.4f\n", L0))
  cat(sprintf("Pseudo-R² McFadden   = %.4f\n", r2_mcf))
  cat(sprintf("AIC                  = %.2f\n", aic))
  cat(sprintf("BIC                  = %.2f\n", bic))

  avaliacao <- if (r2_mcf < 0.20) "Fraco" else if (r2_mcf < 0.40) "Bom" else "Muito bom"
  cat(sprintf("Avaliação (McFadden): %s\n", avaliacao))

  # Deviance (graus de liberdade corretos: nulo = N-1, residual = N-k)
  cat(sprintf("Deviance nula        = %.2f (gl = %d)\n",
              modelo$null.deviance, modelo$df.null))
  cat(sprintf("Deviance residual    = %.2f (gl = %d)\n",
              modelo$deviance, modelo$df.residual))
  cat("\n")

  invisible(r2_mcf)
}

# ════════════════════════════════════════════════════════════
#  9. TESTE DA RAZÃO DE VEROSSIMILHANÇAS (TRV)
# ════════════════════════════════════════════════════════════

teste_trv <- function(modelo) {
  dados_trv <- model.frame(modelo)
  modelo_nulo <- glm(y ~ 1, data = dados_trv, family = binomial(link = "logit"))
  G <- 2 * (logLik(modelo)[1] - logLik(modelo_nulo)[1])
  gl <- length(VARIAVEIS_PRED)
  pval <- 1 - pchisq(G, df = gl)

  cat("Teste da Razão de Verossimilhanças (TRV)\n")
  cat("  H0: beta_1 = ... = beta_p = 0\n")
  cat("  H1: existe j com beta_j != 0\n")
  cat(sprintf("  G (2 * delta L)    = %.4f\n", G))
  cat(sprintf("  Graus de liberdade = %d\n", gl))
  cat(sprintf("  Valor-p            = %.4e\n", pval))
  cat(sprintf("  Decisão (alpha = 0,05): %s\n\n",
              if (pval < 0.05) "Rejeitar H0" else "Não rejeitar H0"))

  invisible(list(G = G, pval = pval))
}

# ════════════════════════════════════════════════════════════
# 10. TESTE DE WALD
# ════════════════════════════════════════════════════════════

teste_wald <- function(modelo) {
  coef_tidy <- tidy(modelo)

  W <- (coef_tidy$estimate / coef_tidy$std.error)^2
  pw <- 1 - pchisq(W, df = 1)

  tab <- coef_tidy %>%
    mutate(
      W_stat = W,
      p_value = pw,
      Signif = case_when(
        p_value < 0.001 ~ "***",
        p_value < 0.01  ~ "**",
        p_value < 0.05  ~ "*",
        TRUE             ~ ""
      )
    ) %>%
    select(term, estimate, std.error, W_stat, p_value, Signif) %>%
    rename(
      "Variável" = term,
      "Coeficiente" = estimate,
      "Erro_Padrão" = std.error,
      "W_statistic" = W_stat,
      "Valor_p" = p_value
    ) %>%
    mutate(across(where(is.numeric), ~ round(., 4)))

  cat("Teste de Wald — H0: beta_j = 0 | H1: beta_j != 0\n")
  print(tab)
  cat("\n")
  cat("Significância: *** p < 0,001 | ** p < 0,01 | * p < 0,05\n\n")

  invisible(tab)
}

# ════════════════════════════════════════════════════════════
# 11. TESTE DE HOSMER-LEMESHOW
# ════════════════════════════════════════════════════════════

teste_hosmer_lemeshow <- function(modelo, g = 10) {
  pi_hat <- fitted(modelo)
  y <- modelo$y
  grupos <- cut(pi_hat,
                breaks = quantile(pi_hat, probs = seq(0, 1, 1/g)),
                include.lowest = TRUE, labels = FALSE)

  C_hat <- 0
  for (k in 1:g) {
    idx <- which(grupos == k)
    O1 <- sum(y[idx])
    E1 <- sum(pi_hat[idx])
    O0 <- length(idx) - O1
    E0 <- sum(1 - pi_hat[idx])
    if (E1 > 0) C_hat <- C_hat + (O1 - E1)^2 / E1
    if (E0 > 0) C_hat <- C_hat + (O0 - E0)^2 / E0
  }

  pval <- 1 - pchisq(C_hat, df = g - 2)

  cat("Teste de Hosmer-Lemeshow\n")
  cat(sprintf("  C_hat              = %.4f\n", C_hat))
  cat(sprintf("  Graus de liberdade = %d\n", g - 2))
  cat(sprintf("  Valor-p            = %.4f\n", pval))
  cat("  H0: o modelo se ajusta adequadamente\n")
  cat(sprintf("  Decisão (alpha = 0,05): %s\n\n",
              if (pval < 0.05) "Rejeitar H0 (falta de ajuste)" else "Não rejeitar H0"))

  invisible(list(C_hat = C_hat, pval = pval))
}

# ════════════════════════════════════════════════════════════
# 12. AVALIAÇÃO NO CONJUNTO TESTE (apoio preditivo)
# ════════════════════════════════════════════════════════════

avaliar_modelo <- function(modelo, dados_te, prob_te = NULL) {
  if (is.null(prob_te)) {
    prob_te <- predict(modelo, newdata = dados_te, type = "response")
  }

  y_pred <- as.integer(prob_te >= LIMIAR_DECISAO)
  acuracia <- mean(y_pred == dados_te$y)

  cat("Desempenho no conjunto de teste (uso auxiliar):\n")
  cat(sprintf("  Limiar de decisão: %.2f\n", LIMIAR_DECISAO))
  cat(sprintf("  Acurácia:   %.4f (%.1f%%)\n", acuracia, 100 * acuracia))
  cat(sprintf("  Taxa de erro:  %.4f (%.1f%%)\n\n", 1 - acuracia, 100 * (1 - acuracia)))

  invisible(list(prob = prob_te, pred = y_pred))
}

# ════════════════════════════════════════════════════════════
# 13. CURVA ROC E AUC (apoio preditivo)
# ════════════════════════════════════════════════════════════

plotar_roc <- function(dados_te, prob_te) {
  roc_obj <- roc(dados_te$y, prob_te, quiet = TRUE)
  auc_val <- auc(roc_obj)

  png("r_roc.png", width = 600, height = 500, res = 130)
  plot(roc_obj, col = "#2980B9", lwd = 2.5,
       main = "Curva ROC", xlab = "1 - Especificidade",
       ylab = "Sensibilidade")
  abline(a = 0, b = 1, lty = 2, col = "gray50", lwd = 1.5)
  legend("bottomright", legend = paste("AUC =", round(auc_val, 3)),
         bty = "n", cex = 1.2, text.col = "#2980B9")
  dev.off()

  cat("Gráfico: r_roc.png\n")
  cat(sprintf("AUC = %.4f — ", auc_val))
  if (auc_val >= 0.90)       cat("Excelente\n\n")
  else if (auc_val >= 0.80)  cat("Bom\n\n")
  else if (auc_val >= 0.70)  cat("Aceitável\n\n")
  else                        cat("Fraco\n\n")

  invisible(auc_val)
}

# ════════════════════════════════════════════════════════════
# 14. PREDIÇÃO PARA NOVA OBSERVAÇÃO (apoio preditivo)
# ════════════════════════════════════════════════════════════

predicao_nova_obs <- function(modelo) {
  valores <- c(45, 55)
  nova_obs <- setNames(as.list(valores), VARIAVEIS_PRED)
  prob_nova <- predict(modelo, newdata = as.data.frame(nova_obs),
                       type = "response")
  classe <- ifelse(prob_nova >= LIMIAR_DECISAO, "Sucesso (1)", "Fracasso (0)")

  cat("Predição para nova observação (uso auxiliar):\n")
  for (j in seq_along(VARIAVEIS_PRED)) {
    cat(sprintf("  %s = %s\n", VARIAVEIS_PRED[j], valores[j]))
  }
  cat(sprintf("  Probabilidade: %.4f\n", prob_nova))
  cat(sprintf("  Classificação: %s\n\n", classe))

  invisible(list(prob = prob_nova, classe = classe))
}

# ════════════════════════════════════════════════════════════
# 15. DIAGNÓSTICO DE RESÍDUOS
# ════════════════════════════════════════════════════════════

diagnostico_residuos <- function(modelo) {
  res_pearson <- residuals(modelo, type = "pearson")
  res_deviance <- residuals(modelo, type = "deviance")
  hat_values <- hatvalues(modelo)
  res_student <- res_pearson / sqrt(1 - hat_values)

  cat("Diagnóstico de Resíduos\n")
  cat("Resíduos de Pearson:\n")
  cat(sprintf("  Min = %.3f, Max = %.3f\n", min(res_pearson), max(res_pearson)))
  cat(sprintf("  Proporção |r| > 2: %.1f%%\n",
              100 * mean(abs(res_pearson) > 2)))

  cat("Resíduos Deviance:\n")
  cat(sprintf("  Min = %.3f, Max = %.3f\n", min(res_deviance), max(res_deviance)))
  cat(sprintf("  Proporção |d| > 2: %.1f%%\n",
              100 * mean(abs(res_deviance) > 2)))

  cat("Resíduos Studentizados (Pearson / sqrt(1 - leverage)):\n")
  cat(sprintf("  Min = %.3f, Max = %.3f\n", min(res_student), max(res_student)))
  cat(sprintf("  Proporção |rs| > 2: %.1f%% (investigar esses pontos)\n",
              100 * mean(abs(res_student) > 2)))

  cat("Leverage (hat values):\n")
  cat(sprintf("  Média = %.4f (esperado = %.4f)\n",
              mean(hat_values), ncol(model.matrix(modelo)) / length(modelo$y)))
  cat("\n")
}

# ════════════════════════════════════════════════════════════
# EXECUÇÃO PRINCIPAL
# ════════════════════════════════════════════════════════════

main <- function() {
  cat("\n")
  cat(paste(rep("=", 70), collapse = ""), "\n")
  cat("  REGRESSÃO LOGÍSTICA BINÁRIA — ANÁLISE (R)\n")
  cat(paste(rep("=", 70), collapse = ""), "\n\n")

  # 1. Dados
  criar_dados_simulados()
  di <- carregar_dados()
  dados <- di$dados

  # 2. EDA
  analise_exploratoria(dados)

  # 3. Divisão treino/teste
  ds <- dividir_dados(dados)
  dados_tr <- ds$tr
  dados_te <- ds$te

  # 3b. Checagem EPV na amostra de treino (Capítulo 1)
  verificar_epv(sum(dados_tr$y == 1), sum(dados_tr$y == 0))

  # 4. Ajuste
  modelo <- ajustar_modelo(dados_tr)

  # 5. Coeficientes e OR (ANÁLISE)
  tabela_coeficientes(modelo)

  # 6. Efeitos Marginais (ANÁLISE)
  efeitos_marginais(modelo)

  # 7. Medidas de Ajuste (ANÁLISE)
  medidas_ajuste(modelo)

  # 8. Teste TRV (ANÁLISE)
  teste_trv(modelo)

  # 9. Teste de Wald (ANÁLISE)
  teste_wald(modelo)

  # 10. Hosmer-Lemeshow (ANÁLISE - diagnóstico)
  teste_hosmer_lemeshow(modelo)

  # 11. Diagnóstico de Resíduos (ANÁLISE)
  diagnostico_residuos(modelo)

  # 12. Avaliação no teste (auxiliar)
  avaliacao <- avaliar_modelo(modelo, dados_te)

  # 13. ROC/AUC (auxiliar)
  plotar_roc(dados_te, avaliacao$prob)

  # 14. Predição para nova observação (auxiliar)
  predicao_nova_obs(modelo)

  cat(paste(rep("=", 70), collapse = ""), "\n")
  cat("  ANÁLISE COMPLETA\n")
  cat(paste(rep("=", 70), collapse = ""), "\n\n")
}

if (!interactive()) {
  main()
}