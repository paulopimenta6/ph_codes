#!/usr/bin/env Rscript
#' ========================================================================
#' Regressão Logística Binária — Implementação em R
#'
#' Análise completa com geração de dados, ajuste de modelo,
#' testes estatísticos e visualizações.
#'
#' Ajuste as 6 variáveis de configuração no início e execute:
#'     Rscript 07_implementacao_r.R
#' ========================================================================

# ════════════════════════════════════════════════════════════
#  CONFIGURAÇÃO — ajuste apenas estas variáveis
# ════════════════════════════════════════════════════════════
CAMINHO_CSV        <- "dados.csv"
VARIAVEL_RESPOSTA  <- "y"
VARIAVEIS_PRED     <- c("x1", "x2")
LIMIAR_DECISAO     <- 0.5
PROPORCAO_TESTE    <- 0.30
SEMENTE            <- 42
# ════════════════════════════════════════════════════════════

# Pacotes necessários
pacotes_necessarios <- c("tidyverse", "caret", "pROC", "broom", "gridExtra")

# Verificar e instalar pacotes
for (pkg in pacotes_necessarios) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Instalando", pkg, "...\n")
    install.packages(pkg, repos = "https://cloud.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

# Suprimir avisos desnecessários
options(warn = -1)
set.seed(SEMENTE)

# ════════════════════════════════════════════════════════════
#  1. CRIAR DADOS SIMULADOS (se não existirem)
# ════════════════════════════════════════════════════════════

criar_dados_simulados <- function() {
  if (file.exists(CAMINHO_CSV)) {
    return()
  }
  
  cat("Arquivo não encontrado — gerando dados simulados.\n")
  
  n <- 350
  x1 <- runif(n, 18, 65) %>% round(1)
  x2 <- rnorm(n, 50, 10) %>% round(1)
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
  
  cat("Dataset:", nrow(dados_raw), "linhas ×", ncol(dados_raw), "colunas\n")
  cat("Colunas:", paste(names(dados_raw), collapse = ", "), "\n\n")
  
  # Validação de colunas
  cols_necessarias <- c(VARIAVEL_RESPOSTA, VARIAVEIS_PRED)
  cols_faltando <- setdiff(cols_necessarias, names(dados_raw))
  
  if (length(cols_faltando) > 0) {
    stop("❌ Colunas ausentes: ", paste(cols_faltando, collapse = ", "), "\n",
         "Ajuste VARIAVEL_RESPOSTA e VARIAVEIS_PRED.")
  }
  
  # Preparação
  dados <- dados_raw %>%
    select(all_of(cols_necessarias)) %>%
    rename(y = VARIAVEL_RESPOSTA) %>%
    mutate(y = as.integer(y)) %>%
    drop_na()
  
  n_antes <- nrow(dados_raw)
  n_depois <- nrow(dados)
  if (n_antes > n_depois) {
    cat("✓ Removidas", n_antes - n_depois, "linha(s) com NA.\n\n")
  }
  
  N1 <- sum(dados$y == 1)
  N0 <- sum(dados$y == 0)
  N  <- nrow(dados)
  
  cat("Classe 1:", N1, paste0("(", round(100 * N1 / N, 1), "%)"),
      "| Classe 0:", N0, paste0("(", round(100 * N0 / N, 1), "%)\n\n"))
  
  return(list(dados = dados, N1 = N1, N0 = N0, N = N))
}

# ════════════════════════════════════════════════════════════
#  3. ANÁLISE EXPLORATÓRIA
# ════════════════════════════════════════════════════════════

analise_exploratoria <- function(dados) {
  # Preparar dados para plotagem
  cores <- c("0" = "#C0392B", "1" = "#27AE60")
  
  # Gráfico de dispersão
  p1 <- dados %>%
    mutate(classe = factor(y, labels = c("Fracasso (0)", "Sucesso (1)"))) %>%
    ggplot(aes(x = !!sym(VARIAVEIS_PRED[1]),
               y = !!sym(VARIAVEIS_PRED[2]),
               color = classe)) +
    geom_point(alpha = 0.65, size = 2.5) +
    scale_color_manual(values = c("Fracasso (0)" = "#C0392B", "Sucesso (1)" = "#27AE60")) +
    labs(title = "Dispersão por Classe",
         color = NULL) +
    theme_minimal() +
    theme(legend.position = "bottom")
  
  # Boxplots para cada preditor
  plots_box <- lapply(VARIAVEIS_PRED, function(var) {
    dados %>%
      mutate(classe = factor(y, labels = c("Fracasso (0)", "Sucesso (1)"))) %>%
      ggplot(aes(x = classe, y = !!sym(var), fill = classe)) +
      geom_boxplot(alpha = 0.75, outlier.alpha = 0.5) +
      scale_fill_manual(values = c("Fracasso (0)" = "#C0392B", "Sucesso (1)" = "#27AE60")) +
      labs(title = paste("Distribuição de", var),
           x = NULL,
           y = var) +
      theme_minimal() +
      theme(legend.position = "none")
  })
  
  # Combinar gráficos
  fig <- gridExtra::grid.arrange(p1, plots_box[[1]], plots_box[[2]], nrow = 1)
  
  ggsave("r_eda.png", fig, width = 13, height = 4.5, dpi = 150)
  cat("✓ Gráfico: r_eda.png\n\n")
  
  return(fig)
}

# ════════════════════════════════════════════════════════════
#  4. DIVIDIR EM TREINO E TESTE
# ════════════════════════════════════════════════════════════

dividir_dados <- function(dados) {
  set.seed(SEMENTE)
  
  indice_treino <- createDataPartition(
    dados$y,
    times = 1,
    p = 1 - PROPORCAO_TESTE,
    list = FALSE
  )
  
  dados_tr <- dados[indice_treino, ]
  dados_te <- dados[-indice_treino, ]
  
  cat("✓ Treino:", nrow(dados_tr), "obs. | Teste:", nrow(dados_te), "obs.\n\n")
  
  return(list(tr = dados_tr, te = dados_te))
}

# ════════════════════════════════════════════════════════════
#  5. AJUSTAR MODELO
# ════════════════════════════════════════════════════════════

ajustar_modelo <- function(dados_tr) {
  # Construir fórmula dinamicamente
  formula_str <- paste("y ~", paste(VARIAVEIS_PRED, collapse = " + "))
  formula <- as.formula(formula_str)
  
  # Ajustar modelo usando glm com família binomial
  modelo <- glm(formula, data = dados_tr, family = binomial(link = "logit"))
  
  cat("✓ Modelo ajustado com sucesso!\n\n")
  print(summary(modelo))
  cat("\n")
  
  return(modelo)
}

# ════════════════════════════════════════════════════════════
#  6. COEFICIENTES E ODDS RATIOS
# ════════════════════════════════════════════════════════════

coeficientes_odds_ratios <- function(modelo) {
  # Extrair informações usando tidy do broom
  coef_tidy <- tidy(modelo, conf.int = TRUE, exponentiate = FALSE)
  
  # Calcular Odds Ratios e ICs
  tabela <- coef_tidy %>%
    mutate(
      OR = exp(estimate),
      IC_25 = exp(conf.low),
      IC_975 = exp(conf.high)
    ) %>%
    select(term, estimate, std.error, OR, IC_25, IC_975, p.value) %>%
    rename(
      "Variável" = term,
      "Coeficiente" = estimate,
      "Erro Padrão" = std.error,
      "OR" = OR,
      "IC 2,5% (OR)" = IC_25,
      "IC 97,5% (OR)" = IC_975,
      "Valor-p" = p.value
    ) %>%
    mutate(across(where(is.numeric), ~ round(., 4)))
  
  cat("Tabela: Coeficientes e Odds Ratios\n")
  print(tabela)
  cat("\n")
  
  invisible(tabela)
}

# ════════════════════════════════════════════════════════════
#  7. PSEUDO-R² DE MCFADDEN
# ════════════════════════════════════════════════════════════

pseudo_r2_mcfadden <- function(modelo, dados_tr, N1_tr, N0_tr) {
  N_tr <- nrow(dados_tr)
  
  # Log-verossimilhança do modelo
  L_star <- logLik(modelo)[1]
  
  # Log-verossimilhança do modelo nulo
  L0 <- N1_tr * log(N1_tr) + N0_tr * log(N0_tr) - N_tr * log(N_tr)
  
  # Pseudo-R² de McFadden
  r2_mcf <- -L_star / L0
  
  cat("L* (modelo) =", round(L_star, 4), "\n")
  cat("L0 (nulo)   =", round(L0, 4), "\n")
  cat("Pseudo-R² de McFadden:", round(r2_mcf, 4), "\n")
  
  # Interpretação
  avaliacao <- if (r2_mcf < 0.20) {
    "Fraco"
  } else if (r2_mcf < 0.40) {
    "Bom"
  } else {
    "Muito bom"
  }
  
  cat("Avaliação:", avaliacao, "\n\n")
  
  invisible(r2_mcf)
}

# ════════════════════════════════════════════════════════════
#  8. TESTE DA RAZÃO DE VEROSSIMILHANÇAS (TRV)
# ════════════════════════════════════════════════════════════

teste_razao_verossimilhancas <- function(modelo, dados_tr) {
  # Modelo nulo (apenas intercepto)
  modelo_nulo <- glm(y ~ 1, data = dados_tr, family = binomial(link = "logit"))
  
  # Estatística G
  G <- 2 * (logLik(modelo)[1] - logLik(modelo_nulo)[1])
  gl <- length(VARIAVEIS_PRED)
  pval <- 1 - pchisq(G, df = gl)
  
  cat("Teste da Razão de Verossimilhanças (TRV)\n")
  cat("  H0: Todos os coeficientes = 0\n")
  cat("  H1: Pelo menos um coeficiente ≠ 0\n")
  cat("  G-statistic:", round(G, 4), "\n")
  cat("  Graus de liberdade:", gl, "\n")
  cat("  Valor-p:", format(pval, scientific = TRUE, digits = 2), "\n")
  cat("  Decisão:", if (pval < 0.05) "Rejeitar H0 ✓" else "Não rejeitar", "\n\n")
  
  invisible(list(G = G, pval = pval))
}

# ════════════════════════════════════════════════════════════
#  9. TESTE DE WALD
# ════════════════════════════════════════════════════════════

teste_wald <- function(modelo) {
  coef_tidy <- tidy(modelo)
  
  # Calcular W-statistic
  W <- (coef_tidy$estimate / coef_tidy$std.error)^2
  pw <- 1 - pchisq(W, df = 1)
  
  tabela_wald <- coef_tidy %>%
    mutate(
      W_statistic = W,
      p_value = pw,
      Significância = case_when(
        p_value < 0.001 ~ "***",
        p_value < 0.01  ~ "**",
        p_value < 0.05  ~ "*",
        TRUE             ~ ""
      )
    ) %>%
    select(term, estimate, std.error, W_statistic, p_value, Significância) %>%
    rename(
      "Variável" = term,
      "Coeficiente" = estimate,
      "Erro Padrão" = std.error,
      "W-statistic" = W_statistic,
      "Valor-p" = p_value
    ) %>%
    mutate(across(where(is.numeric), ~ round(., 4)))
  
  cat("Teste de Wald — H0: a_i = 0 | H1: a_i ≠ 0\n")
  print(tabela_wald)
  cat("\n")
  
  invisible(tabela_wald)
}

# ════════════════════════════════════════════════════════════
#  10. AVALIAÇÃO DO MODELO NO CONJUNTO TESTE
# ════════════════════════════════════════════════════════════

avaliar_modelo <- function(modelo, dados_te) {
  # Probabilidades preditas
  prob_te <- predict(modelo, newdata = dados_te, type = "response")
  
  # Classificações
  y_pred <- as.integer(prob_te >= LIMIAR_DECISAO)
  
  # Acurácia
  acuracia <- mean(y_pred == dados_te$y)
  taxa_erro <- 1 - acuracia
  
  cat("Limiar de decisão:", LIMIAR_DECISAO, "\n")
  cat("Acurácia:   ", round(acuracia, 4), "(", round(100 * acuracia, 1), "%)\n")
  cat("Taxa erro:  ", round(taxa_erro, 4), "(", round(100 * taxa_erro, 1), "%)\n\n")
  
  # Matriz de confusão
  y_fator <- factor(y_pred, levels = c(0, 1), labels = c("Fracasso (0)", "Sucesso (1)"))
  y_real <- factor(dados_te$y, levels = c(0, 1), labels = c("Fracasso (0)", "Sucesso (1)"))
  
  cm <- confusionMatrix(y_fator, y_real)
  
  cat("Matriz de Confusão e Métricas:\n")
  print(cm)
  cat("\n")
  
  return(list(prob = prob_te, pred = y_pred, cm = cm))
}

# ════════════════════════════════════════════════════════════
#  11. PLOTAR ROC E MATRIZ DE CONFUSÃO
# ════════════════════════════════════════════════════════════

plotar_roc_matriz <- function(dados_te, prob_te, y_pred) {
  # Calcular ROC
  roc_obj <- roc(dados_te$y, prob_te)
  auc_val <- auc(roc_obj)
  
  # Criar figura
  png("r_roc_cm.png", width = 1200, height = 450, res = 150)
  par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
  
  # Matriz de confusão
  cm <- table(y_pred, dados_te$y)
  cm_normalized <- cm / rowSums(cm)
  
  image(t(cm)[, nrow(cm):1],
        col = colorRamp(c("white", "#2980B9"))(seq(0, 1, length.out = 256)),
        xaxt = "n", yaxt = "n",
        main = "Matriz de Confusão")
  
  axis(1, at = c(0, 1), labels = c("Não", "Sim"))
  axis(2, at = c(0, 1), labels = c("Sim", "Não"))
  
  # Adicionar valores
  text(0, 1, labels = cm[1, 1], cex = 1.5, font = 2)
  text(1, 1, labels = cm[2, 1], cex = 1.5, font = 2)
  text(0, 0, labels = cm[1, 2], cex = 1.5, font = 2)
  text(1, 0, labels = cm[2, 2], cex = 1.5, font = 2)
  
  mtext("Predito", side = 1, line = 2.5)
  mtext("Real", side = 2, line = 2.5)
  
  # Curva ROC
  plot(roc_obj,
       col = "#2980B9",
       lwd = 2.5,
       main = "Curva ROC",
       xlab = "1 − Especificidade",
       ylab = "Sensibilidade")
  abline(a = 0, b = 1, lty = 2, col = "black", lwd = 1.5)
  
  legend("lower right",
         legend = paste("AUC =", round(auc_val, 3)),
         bty = "n",
         cex = 1.2)
  
  dev.off()
  cat("✓ Gráfico: r_roc_cm.png\n\n")
  
  # Interpretação da AUC
  cat("AUC:", round(auc_val, 4), "— ", sep = "")
  if (auc_val >= 0.90) {
    cat("Excelente ⭐⭐⭐\n\n")
  } else if (auc_val >= 0.80) {
    cat("Bom ⭐⭐\n\n")
  } else if (auc_val >= 0.70) {
    cat("Aceitável ⭐\n\n")
  } else {
    cat("Fraco — revisar modelo\n\n")
  }
  
  invisible(list(roc = roc_obj, auc = auc_val))
}

# ════════════════════════════════════════════════════════════
#  12. PREDIÇÃO PARA NOVA OBSERVAÇÃO
# ════════════════════════════════════════════════════════════

predicao_nova_obs <- function(modelo) {
  # Nova observação
  valores <- c(45, 55)
  
  # Criar data frame com nomes corretos
  nova_obs <- setNames(data.frame(t(valores)), VARIAVEIS_PRED)
  
  # Fazer predição
  prob_nova <- predict(modelo, newdata = nova_obs, type = "response")
  classe <- if (prob_nova >= LIMIAR_DECISAO) "Sucesso (1)" else "Fracasso (0)"
  
  cat("Predição para Nova Observação:\n")
  for (i in seq_along(VARIAVEIS_PRED)) {
    cat(" ", VARIAVEIS_PRED[i], "=", valores[i], "\n")
  }
  cat("\n  Probabilidade:", round(prob_nova, 4), "\n")
  cat("  Classificação:", classe, "\n\n")
  
  invisible(list(prob = prob_nova, classe = classe))
}

# ════════════════════════════════════════════════════════════
# EXECUÇÃO PRINCIPAL
# ════════════════════════════════════════════════════════════

main <- function() {
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat("  REGRESSÃO LOGÍSTICA BINÁRIA — R\n")
  cat(strrep("=", 70), "\n")
  cat("\n")
  
  # 1. Dados
  criar_dados_simulados()
  dados_info <- carregar_dados()
  dados <- dados_info$dados
  N1 <- dados_info$N1
  N0 <- dados_info$N0
  N <- dados_info$N
  
  # 2. EDA
  analise_exploratoria(dados)
  
  # 3. Dividir
  dados_split <- dividir_dados(dados)
  dados_tr <- dados_split$tr
  dados_te <- dados_split$te
  
  # 4. Ajuste
  modelo <- ajustar_modelo(dados_tr)
  
  # 5. Coeficientes
  coeficientes_odds_ratios(modelo)
  
  # 6. R² McFadden
  N1_tr <- sum(dados_tr$y == 1)
  N0_tr <- sum(dados_tr$y == 0)
  pseudo_r2_mcfadden(modelo, dados_tr, N1_tr, N0_tr)
  
  # 7. Testes
  teste_razao_verossimilhancas(modelo, dados_tr)
  teste_wald(modelo)
  
  # 8. Avaliação
  avaliacao <- avaliar_modelo(modelo, dados_te)
  
  # 9. Visualizações
  plotar_roc_matriz(dados_te, avaliacao$prob, avaliacao$pred)
  
  # 10. Predição nova
  predicao_nova_obs(modelo)
  
  cat(strrep("=", 70), "\n")
  cat("  ✓ ANÁLISE COMPLETA!\n")
  cat(strrep("=", 70), "\n")
  cat("\n")
}

# Executar
if (!interactive()) {
  main()
}
