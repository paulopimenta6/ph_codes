###############################################################################
# Código em R para Modelos Lineares Mistos em Grandes Bases de Dados
# Autor: Manus AI
# Data: 21/05/2025
###############################################################################

# Carregando os pacotes necessários
library(lme4)       # Principal pacote para modelos lineares mistos
library(data.table) # Manipulação eficiente de grandes bases de dados
library(parallel)   # Processamento paralelo
library(doParallel) # Interface para processamento paralelo
library(foreach)    # Loops paralelos
library(ggplot2)    # Visualização de dados e resultados

###############################################################################
# PARTE 1: PREPARAÇÃO DO AMBIENTE PARA GRANDES BASES DE DADOS
###############################################################################

# Configuração para processamento paralelo
# Detecta automaticamente o número de núcleos disponíveis e deixa um livre
num_cores <- detectCores() - 1
# Garante pelo menos um núcleo
num_cores <- max(1, num_cores)
# Registra o cluster para processamento paralelo
cl <- makeCluster(num_cores)
registerDoParallel(cl)

# Configuração de memória para o R
# Aumenta o limite de memória para vetores grandes (ajuste conforme necessário)
options(future.globals.maxSize = 4000 * 1024^2) # 4GB

# Função para monitorar uso de memória
monitorar_memoria <- function() {
  gc_result <- gc(full = TRUE)
  cat("Uso de memória atual:\n")
  print(gc_result)
}

###############################################################################
# PARTE 2: CARREGAMENTO E PREPARAÇÃO DE DADOS
###############################################################################

# Função para carregar grandes bases de dados de forma eficiente
carregar_dados_grandes <- function(caminho_arquivo, 
                                   chunk_size = 1e6, 
                                   colunas_selecionadas = NULL) {
  
  # Verifica se o arquivo existe
  if (!file.exists(caminho_arquivo)) {
    stop("Arquivo não encontrado: ", caminho_arquivo)
  }
  
  # Determina o tipo de arquivo
  extensao <- tools::file_ext(caminho_arquivo)
  
  # Carrega os dados de acordo com o tipo de arquivo
  if (extensao == "csv") {
    # Para arquivos CSV, usa fread do data.table que é muito mais rápido que read.csv
    if (!is.null(colunas_selecionadas)) {
      dados <- fread(caminho_arquivo, select = colunas_selecionadas)
    } else {
      dados <- fread(caminho_arquivo)
    }
  } else if (extensao %in% c("rds", "RDS")) {
    # Para arquivos RDS
    dados <- readRDS(caminho_arquivo)
    if (!is.null(colunas_selecionadas) && is.data.frame(dados)) {
      dados <- dados[, colunas_selecionadas, with = FALSE]
    }
  } else {
    stop("Formato de arquivo não suportado: ", extensao)
  }
  
  # Converte para data.table se ainda não for
  if (!is.data.table(dados)) {
    dados <- as.data.table(dados)
  }
  
  return(dados)
}

###############################################################################
# PARTE 3: EXEMPLO DE GERAÇÃO DE DADOS SIMULADOS PARA DEMONSTRAÇÃO
###############################################################################

# Função para gerar dados simulados para demonstração
# Isso é útil para testar o código antes de aplicar em dados reais
gerar_dados_simulados <- function(n_grupos = 100, 
                                  n_por_grupo = 1000, 
                                  efeito_fixo = 2.5,
                                  variancia_grupo = 1.5,
                                  variancia_residual = 1.0,
                                  seed = 123) {
  
  # Define a semente para reprodutibilidade
  set.seed(seed)
  
  # Número total de observações
  n_total <- n_grupos * n_por_grupo
  
  # Cria IDs de grupo
  grupo_id <- rep(1:n_grupos, each = n_por_grupo)
  
  # Gera efeitos aleatórios para cada grupo
  efeitos_aleatorios <- rnorm(n_grupos, mean = 0, sd = sqrt(variancia_grupo))
  
  # Gera variável preditora
  x <- rnorm(n_total, mean = 0, sd = 1)
  
  # Calcula o valor esperado
  mu <- efeito_fixo * x + efeitos_aleatorios[grupo_id]
  
  # Gera a variável resposta com erro
  y <- mu + rnorm(n_total, mean = 0, sd = sqrt(variancia_residual))
  
  # Cria o data.table
  dados <- data.table(
    grupo = factor(grupo_id),
    x = x,
    y = y
  )
  
  # Adiciona algumas variáveis categóricas para demonstração
  dados[, categoria1 := factor(sample(LETTERS[1:5], n_total, replace = TRUE))]
  dados[, categoria2 := factor(sample(c("Baixo", "Médio", "Alto"), n_total, replace = TRUE))]
  
  return(dados)
}

# Gera um conjunto de dados simulados grande
# Aqui estamos gerando 100 grupos com 1000 observações cada = 100.000 observações
cat("Gerando dados simulados...\n")
dados_grandes <- gerar_dados_simulados(n_grupos = 100, n_por_grupo = 1000)
cat("Dimensões dos dados simulados:", dim(dados_grandes), "\n")

###############################################################################
# PARTE 4: ANÁLISE EXPLORATÓRIA BÁSICA
###############################################################################

# Função para análise exploratória básica - CORRIGIDA
analise_exploratoria <- function(dados) {
  # Resumo estatístico - versão corrigida
  cat("Resumo estatístico das variáveis numéricas:\n")
  
  # Para variável x
  cat("\nResumo de x:\n")
  print(summary(dados$x))
  
  # Para variável y
  cat("\nResumo de y:\n")
  print(summary(dados$y))
  
  # Contagem por grupo (primeiros 10 grupos)
  cat("\nContagem de observações por grupo (primeiros 10):\n")
  print(dados[, .N, by = grupo][1:10])
  
  # Médias por grupo (primeiros 10 grupos)
  cat("\nMédia de y por grupo (primeiros 10):\n")
  print(dados[, .(media_y = mean(y)), by = grupo][1:10])
  
  # Correlação entre x e y
  cat("\nCorrelação entre x e y:", cor(dados$x, dados$y), "\n")
}

# Executa análise exploratória nos dados simulados
cat("Realizando análise exploratória...\n")
analise_exploratoria(dados_grandes)

###############################################################################
# PARTE 5: AJUSTE DE MODELOS LINEARES MISTOS
###############################################################################

# Função para ajustar modelo linear misto com lme4
# Esta função implementa várias otimizações para grandes bases de dados
ajustar_modelo_misto <- function(dados, 
                                 formula, 
                                 controle = NULL,
                                 verbose = TRUE) {
  
  # Monitora o tempo de execução
  tempo_inicio <- Sys.time()
  
  # Configura controles padrão se não fornecidos
  if (is.null(controle)) {
    controle <- lmerControl(
      optimizer = "nloptwrap",  # Otimizador mais eficiente
      optCtrl = list(maxeval = 100), # Limita número de avaliações
      calc.derivs = FALSE,      # Desativa cálculo de derivadas quando possível
      check.nobs.vs.rankZ = "warning", # Apenas avisa em vez de parar
      check.nobs.vs.nlev = "warning",  # Apenas avisa em vez de parar
      check.nobs.vs.nRE = "warning"    # Apenas avisa em vez de parar
    )
  }
  
  # Ajusta o modelo
  if (verbose) cat("Ajustando modelo linear misto...\n")
  modelo <- lmer(formula, data = dados, control = controle)
  
  # Calcula o tempo de execução
  tempo_fim <- Sys.time()
  tempo_total <- difftime(tempo_fim, tempo_inicio, units = "secs")
  
  if (verbose) {
    cat("Modelo ajustado em", round(tempo_total, 2), "segundos\n")
    cat("Resumo do modelo:\n")
    print(summary(modelo))
  }
  
  return(modelo)
}

# Ajusta um modelo linear misto nos dados simulados
cat("Ajustando modelo linear misto...\n")
modelo_misto <- ajustar_modelo_misto(
  dados = dados_grandes,
  formula = y ~ x + categoria1 + categoria2 + (1 | grupo)
)

###############################################################################
# PARTE 6: VALIDAÇÃO DO MODELO
###############################################################################

# Função para validar o modelo ajustado
validar_modelo <- function(modelo, dados, plot = TRUE) {
  # Extrai resíduos
  residuos <- resid(modelo)
  
  # Extrai valores ajustados
  valores_ajustados <- fitted(modelo)
  
  # Calcula estatísticas de diagnóstico
  cat("Estatísticas dos resíduos:\n")
  print(summary(residuos))
  
  # Testes de normalidade nos resíduos (amostra para grandes bases)
  if (length(residuos) > 5000) {
    # Para bases muito grandes, amostra 5000 pontos para o teste
    amostra_indices <- sample(length(residuos), 5000)
    residuos_amostra <- residuos[amostra_indices]
    cat("\nTeste de normalidade (Shapiro-Wilk) em amostra de resíduos:\n")
    print(shapiro.test(residuos_amostra))
  } else {
    cat("\nTeste de normalidade (Shapiro-Wilk) nos resíduos:\n")
    print(shapiro.test(residuos))
  }
  
  # Gráficos de diagnóstico
  if (plot) {
    # Para bases muito grandes, amostra pontos para os gráficos
    if (length(residuos) > 10000) {
      amostra_indices <- sample(length(residuos), 10000)
      residuos_plot <- residuos[amostra_indices]
      valores_ajustados_plot <- valores_ajustados[amostra_indices]
    } else {
      residuos_plot <- residuos
      valores_ajustados_plot <- valores_ajustados
    }
    
    # Cria data.frame para ggplot
    dados_plot <- data.frame(
      residuos = residuos_plot,
      valores_ajustados = valores_ajustados_plot
    )
    
    # Gráfico de resíduos vs valores ajustados
    p1 <- ggplot(dados_plot, aes(x = valores_ajustados, y = residuos)) +
      geom_point(alpha = 0.3) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
      geom_smooth(method = "loess", se = FALSE, color = "blue") +
      labs(title = "Resíduos vs Valores Ajustados",
           x = "Valores Ajustados",
           y = "Resíduos") +
      theme_minimal()
    
    # QQ-plot dos resíduos
    p2 <- ggplot(dados_plot, aes(sample = residuos)) +
      stat_qq() +
      stat_qq_line(color = "red") +
      labs(title = "QQ-Plot dos Resíduos",
           x = "Quantis Teóricos",
           y = "Quantis Amostrais") +
      theme_minimal()
    
    # Histograma dos resíduos
    p3 <- ggplot(dados_plot, aes(x = residuos)) +
      geom_histogram(bins = 30, fill = "steelblue", color = "black") +
      labs(title = "Distribuição dos Resíduos",
           x = "Resíduos",
           y = "Frequência") +
      theme_minimal()
    
    # Exibe os gráficos
    print(p1)
    print(p2)
    print(p3)
  }
  
  # Retorna estatísticas de diagnóstico
  return(list(
    residuos = residuos,
    valores_ajustados = valores_ajustados
  ))
}

# Valida o modelo ajustado
cat("Validando o modelo...\n")
diagnostico <- validar_modelo(modelo_misto, dados_grandes, plot = FALSE)

###############################################################################
# PARTE 7: PREDIÇÃO COM O MODELO
###############################################################################

# Função para fazer predições com o modelo
fazer_predicoes <- function(modelo, novos_dados, tipo = "resposta") {
  # Verifica se os dados são data.table e converte se necessário
  if (!is.data.table(novos_dados)) {
    novos_dados <- as.data.table(novos_dados)
  }
  
  # Faz predições
  if (tipo == "resposta") {
    # Predição da resposta (inclui efeitos fixos e aleatórios)
    predicoes <- predict(modelo, newdata = novos_dados, re.form = NULL)
  } else if (tipo == "fixos") {
    # Predição apenas com efeitos fixos
    predicoes <- predict(modelo, newdata = novos_dados, re.form = NA)
  } else {
    stop("Tipo de predição não reconhecido. Use 'resposta' ou 'fixos'.")
  }
  
  # Adiciona predições aos dados
  novos_dados[, predicao := predicoes]
  
  return(novos_dados)
}

# Cria um conjunto de dados para predição (amostra dos dados originais)
dados_predicao <- dados_grandes[sample(1:.N, 1000)]

# Faz predições
cat("Fazendo predições com o modelo...\n")
dados_com_predicoes <- fazer_predicoes(modelo_misto, dados_predicao)

# Calcula métricas de desempenho
rmse <- sqrt(mean((dados_com_predicoes$y - dados_com_predicoes$predicao)^2))
mae <- mean(abs(dados_com_predicoes$y - dados_com_predicoes$predicao))
r2 <- cor(dados_com_predicoes$y, dados_com_predicoes$predicao)^2

cat("Métricas de desempenho do modelo:\n")
cat("RMSE:", rmse, "\n")
cat("MAE:", mae, "\n")
cat("R²:", r2, "\n")

###############################################################################
# PARTE 8: PROCESSAMENTO PARALELO PARA ANÁLISES MÚLTIPLAS
###############################################################################

# Função para executar análises em paralelo por subgrupos
analise_por_subgrupos <- function(dados, formula_base, grupos_var) {
  # Identifica os grupos únicos
  grupos_unicos <- unique(dados[[grupos_var]])
  
  # Executa a análise em paralelo
  resultados <- foreach(g = grupos_unicos, .packages = c("lme4", "data.table")) %dopar% {
    # Filtra dados para o grupo atual
    dados_grupo <- dados[get(grupos_var) == g]
    
    # Ajusta o modelo para este grupo
    modelo_grupo <- try(lmer(formula_base, data = dados_grupo), silent = TRUE)
    
    # Verifica se o modelo foi ajustado com sucesso
    if (inherits(modelo_grupo, "try-error")) {
      return(list(grupo = g, sucesso = FALSE, erro = attr(modelo_grupo, "condition")$message))
    }
    
    # Extrai coeficientes e outras estatísticas
    coefs <- fixef(modelo_grupo)
    var_aleatorios <- VarCorr(modelo_grupo)
    aic <- AIC(modelo_grupo)
    bic <- BIC(modelo_grupo)
    
    # Retorna resultados para este grupo
    return(list(
      grupo = g,
      sucesso = TRUE,
      coeficientes = coefs,
      variancias = var_aleatorios,
      aic = aic,
      bic = bic
    ))
  }
  
  # Combina os resultados em uma lista nomeada
  names(resultados) <- as.character(grupos_unicos)
  
  return(resultados)
}

# Exemplo de uso da função de análise paralela por subgrupos
# Neste exemplo, vamos analisar separadamente para cada categoria1
cat("Executando análises paralelas por subgrupos...\n")
resultados_por_categoria <- analise_por_subgrupos(
  dados = dados_grandes,
  formula_base = y ~ x + (1 | grupo),
  grupos_var = "categoria1"
)

# Exibe resumo dos resultados
cat("Resumo dos resultados por categoria:\n")
for (cat_nome in names(resultados_por_categoria)) {
  res <- resultados_por_categoria[[cat_nome]]
  if (res$sucesso) {
    cat("\nCategoria:", cat_nome, "\n")
    cat("Coeficientes fixos:\n")
    print(res$coeficientes)
    cat("AIC:", res$aic, "BIC:", res$bic, "\n")
  } else {
    cat("\nCategoria:", cat_nome, "- Erro no ajuste:", res$erro, "\n")
  }
}

###############################################################################
# PARTE 9: LIMPEZA E FINALIZAÇÃO
###############################################################################

# Encerra o cluster paralelo
stopCluster(cl)

# Limpa a memória
monitorar_memoria()

cat("\nAnálise de modelos lineares mistos concluída com sucesso!\n")
