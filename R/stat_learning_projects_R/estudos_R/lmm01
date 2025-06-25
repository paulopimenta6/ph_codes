library(lme4)

set.seed(123)

# Simulando dados
n_escolas <- 10
n_alunos_por_escola <- 30

escola <- rep(paste0("Escola_", 1:n_escolas), each = n_alunos_por_escola)
horas_estudo <- rnorm(n_escolas * n_alunos_por_escola, mean = 5, sd = 2)
efeito_escola <- rnorm(n_escolas, mean = 0, sd = 5)
intercepto_base <- 60

# Criando a nota com variação por escola
nota <- intercepto_base + 3 * horas_estudo + rep(efeito_escola, each = n_alunos_por_escola) + rnorm(n_escolas * n_alunos_por_escola, sd = 5)

dados <- data.frame(
  escola = as.factor(escola),
  horas_estudo = horas_estudo,
  nota = nota
)

modelo <- lmer(nota ~ horas_estudo + (1 | escola), data = dados)
summary(modelo)