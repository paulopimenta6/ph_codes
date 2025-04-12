source("./src/data_kNN_v2.R")
source("./src/mice_inputation_v2.R")
library(ggplot2)
library(dplyr)
################################################################################
### dados onda 1 usando pmm
### data frame pmm: dadosOnda1Mice_inp
### dados onda 1 usando kNN
### data frame kNN: dadosOnda1kNN_inp
################################################################################
################################ Onda 1 ########################################
################################################################################
### Estatisticas dos data frames criados
summary(dadosOnda1Mice_inp)
summary(dadosOnda1kNN_inp)
################################################################################
### potassio
stats_compare_pot_onda1 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfPotassio$pot_onda1, na.rm = TRUE),
            mean(dadosOnda1Mice_inp$pot),
            mean(dadosOnda1kNN_inp$pot)),
  Mediana = c(median(dfPotassio$pot_onda1, na.rm = TRUE),
              median(dadosOnda1Mice_inp$pot),
              median(dadosOnda1kNN_inp$pot)),
  DesvioPadrao = c(sd(dfPotassio$pot_onda1, na.rm = TRUE),
                   sd(dadosOnda1Mice_inp$pot),
                   sd(dadosOnda1kNN_inp$pot))
)
### sodio
stats_compare_sod_onda1 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfSodio$sod_onda1, na.rm = TRUE),
            mean(dadosOnda1Mice_inp$sod),
            mean(dadosOnda1kNN_inp$sod)),
  Mediana = c(median(dfSodio$sod_onda1, na.rm = TRUE),
              median(dadosOnda1Mice_inp$sod),
              median(dadosOnda1kNN_inp$sod)),
  DesvioPadrao = c(sd(dfSodio$sod_onda1, na.rm = TRUE),
                   sd(dadosOnda1Mice_inp$sod),
                   sd(dadosOnda1kNN_inp$sod))
)
### PAS
stats_compare_pas_onda1 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfPAS$PAS_onda1, na.rm = TRUE),
            mean(dadosOnda1Mice_inp$pas),
            mean(dadosOnda1kNN_inp$pas)),
  Mediana = c(median(dfPAS$PAS_onda1, na.rm = TRUE),
              median(dadosOnda1Mice_inp$pas),
              median(dadosOnda1kNN_inp$pas)),
  DesvioPadrao = c(sd(dfPAS$PAS_onda1, na.rm = TRUE),
                   sd(dadosOnda1Mice_inp$pas),
                   sd(dadosOnda1kNN_inp$pas))
)
### PAD
stats_compare_pad_onda1 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfPAD$PAD_onda1, na.rm = TRUE),
            mean(dadosOnda1Mice_inp$pad),
            mean(dadosOnda1kNN_inp$pad)),
  Mediana = c(median(dfPAD$PAD_onda1, na.rm = TRUE),
              median(dadosOnda1Mice_inp$pad),
              median(dadosOnda1kNN_inp$pad)),
  DesvioPadrao = c(sd(dfPAD$PAD_onda1, na.rm = TRUE),
                   sd(dadosOnda1Mice_inp$pad),
                   sd(dadosOnda1kNN_inp$pad))
)

################################################################################
### 1. Comparação de Estatísticas Resumo já realizada:
print(stats_compare_pot_onda1)
print(stats_compare_sod_onda1)
print(stats_compare_pas_onda1)
print(stats_compare_pad_onda1)
################################################################################
### 2. Preparação dos dados para gráficos de distribuição

# Para Potássio
df_pot <- data.frame(
  pot = c(dfPotassio$pot_onda1,
          dadosOnda1kNN_inp$pot,
          dadosOnda1Mice_inp$pot),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfPotassio), nrow(dadosOnda1kNN_inp), nrow(dadosOnda1Mice_inp))))
)

# Para Sódio
df_sod <- data.frame(
  sod = c(dfSodio$sod_onda1,
          dadosOnda1kNN_inp$sod,
          dadosOnda1Mice_inp$sod),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfSodio), nrow(dadosOnda1kNN_inp), nrow(dadosOnda1Mice_inp))))
)

# Para PAS
df_pas <- data.frame(
  pas = c(dfPAS$PAS_onda1,
          dadosOnda1kNN_inp$pas,
          dadosOnda1Mice_inp$pas),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfPAS), nrow(dadosOnda1kNN_inp), nrow(dadosOnda1Mice_inp))))
)

# Para PAD
df_pad <- data.frame(
  pad = c(dfPAD$PAD_onda1,
          dadosOnda1kNN_inp$pad,
          dadosOnda1Mice_inp$pad),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfPAD), nrow(dadosOnda1kNN_inp), nrow(dadosOnda1Mice_inp))))
)

### 3. Gráficos de Densidade

# Potássio
ggplot(df_pot, aes(x = pot, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de Potássio - Onda 1", x = "Potássio", y = "Densidade") +
  theme_minimal()

# Sódio
ggplot(df_sod, aes(x = sod, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de Sódio - Onda 1", x = "Sódio", y = "Densidade") +
  theme_minimal()

# PAS
ggplot(df_pas, aes(x = pas, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de PAS - Onda 1", x = "PAS", y = "Densidade") +
  theme_minimal()

# PAD
ggplot(df_pad, aes(x = pad, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de PAD - Onda 1", x = "PAD", y = "Densidade") +
  theme_minimal()

### 4. Boxplots para Visualização Comparativa

# Potássio
ggplot(df_pot, aes(x = Metodo, y = pot, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de Potássio - Onda 1", x = "Método", y = "Potássio") +
  theme_minimal()

# Sódio
ggplot(df_sod, aes(x = Metodo, y = sod, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de Sódio - Onda 1", x = "Método", y = "Sódio") +
  theme_minimal()

# PAS
ggplot(df_pas, aes(x = Metodo, y = pas, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de PAS - Onda 1", x = "Método", y = "PAS") +
  theme_minimal()

# PAD
ggplot(df_pad, aes(x = Metodo, y = pad, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de PAD - Onda 1", x = "Método", y = "PAD") +
  theme_minimal()

################################################################################
################################ Onda 2 ########################################
################################################################################
cat("### Estatísticas Onda 2 - PMM\n")
summary(dadosOnda2Mice_inp)
cat("### Estatísticas Onda 2 - kNN\n")
summary(dadosOnda2kNN_inp)

### Comparação de estatísticas resumo para a Onda 2
### Potássio
stats_compare_pot_onda2 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfPotassio$pot_onda2, na.rm = TRUE),
            mean(dadosOnda2kNN_inp$pot),
            mean(dadosOnda2Mice_inp$pot)),
  Mediana = c(median(dfPotassio$pot_onda2, na.rm = TRUE),
              median(dadosOnda2kNN_inp$pot),
              median(dadosOnda2Mice_inp$pot)),
  DesvioPadrao = c(sd(dfPotassio$pot_onda2, na.rm = TRUE),
                   sd(dadosOnda2kNN_inp$pot),
                   sd(dadosOnda2Mice_inp$pot))
)

### Sódio
stats_compare_sod_onda2 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfSodio$sod_onda2, na.rm = TRUE),
            mean(dadosOnda2kNN_inp$sod),
            mean(dadosOnda2Mice_inp$sod)),
  Mediana = c(median(dfSodio$sod_onda2, na.rm = TRUE),
              median(dadosOnda2kNN_inp$sod),
              median(dadosOnda2Mice_inp$sod)),
  DesvioPadrao = c(sd(dfSodio$sod_onda2, na.rm = TRUE),
                   sd(dadosOnda2kNN_inp$sod),
                   sd(dadosOnda2Mice_inp$sod))
)

### PAS
stats_compare_pas_onda2 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfPAS$PAS_onda2, na.rm = TRUE),
            mean(dadosOnda2kNN_inp$pas),
            mean(dadosOnda2Mice_inp$pas)),
  Mediana = c(median(dfPAS$PAS_onda2, na.rm = TRUE),
              median(dadosOnda2kNN_inp$pas),
              median(dadosOnda2Mice_inp$pas)),
  DesvioPadrao = c(sd(dfPAS$PAS_onda2, na.rm = TRUE),
                   sd(dadosOnda2kNN_inp$pas),
                   sd(dadosOnda2Mice_inp$pas))
)

### PAD
stats_compare_pad_onda2 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfPAD$PAD_onda2, na.rm = TRUE),
            mean(dadosOnda2kNN_inp$pad),
            mean(dadosOnda2Mice_inp$pad)),
  Mediana = c(median(dfPAD$PAD_onda2, na.rm = TRUE),
              median(dadosOnda2kNN_inp$pad),
              median(dadosOnda2Mice_inp$pad)),
  DesvioPadrao = c(sd(dfPAD$PAD_onda2, na.rm = TRUE),
                   sd(dadosOnda2kNN_inp$pad),
                   sd(dadosOnda2Mice_inp$pad))
)

# Exibindo tabelas resumo para Onda 2
print(stats_compare_pot_onda2)
print(stats_compare_sod_onda2)
print(stats_compare_pas_onda2)
print(stats_compare_pad_onda2)

### Preparando os dados para gráficos - Onda 2

# Potássio
df_pot_onda2 <- data.frame(
  pot = c(dfPotassio$pot_onda2,
          dadosOnda2kNN_inp$pot,
          dadosOnda2Mice_inp$pot),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfPotassio), nrow(dadosOnda2kNN_inp), nrow(dadosOnda2Mice_inp))))
)
# Sódio
df_sod_onda2 <- data.frame(
  sod = c(dfSodio$sod_onda2,
          dadosOnda2kNN_inp$sod,
          dadosOnda2Mice_inp$sod),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfSodio), nrow(dadosOnda2kNN_inp), nrow(dadosOnda2Mice_inp))))
)
# PAS
df_pas_onda2 <- data.frame(
  pas = c(dfPAS$PAS_onda2,
          dadosOnda2kNN_inp$pas,
          dadosOnda2Mice_inp$pas),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfPAS), nrow(dadosOnda2kNN_inp), nrow(dadosOnda2Mice_inp))))
)
# PAD
df_pad_onda2 <- data.frame(
  pad = c(dfPAD$PAD_onda2,
          dadosOnda2kNN_inp$pad,
          dadosOnda2Mice_inp$pad),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfPAD), nrow(dadosOnda2kNN_inp), nrow(dadosOnda2Mice_inp))))
)

### Gráficos de Densidade - Onda 2
ggplot(df_pot_onda2, aes(x = pot, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de Potássio - Onda 2", x = "Potássio", y = "Densidade") +
  theme_minimal()

ggplot(df_sod_onda2, aes(x = sod, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de Sódio - Onda 2", x = "Sódio", y = "Densidade") +
  theme_minimal()

ggplot(df_pas_onda2, aes(x = pas, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de PAS - Onda 2", x = "PAS", y = "Densidade") +
  theme_minimal()

ggplot(df_pad_onda2, aes(x = pad, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de PAD - Onda 2", x = "PAD", y = "Densidade") +
  theme_minimal()

### Boxplots - Onda 2
ggplot(df_pot_onda2, aes(x = Metodo, y = pot, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de Potássio - Onda 2", x = "Método", y = "Potássio") +
  theme_minimal()

ggplot(df_sod_onda2, aes(x = Metodo, y = sod, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de Sódio - Onda 2", x = "Método", y = "Sódio") +
  theme_minimal()

ggplot(df_pas_onda2, aes(x = Metodo, y = pas, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de PAS - Onda 2", x = "Método", y = "PAS") +
  theme_minimal()

ggplot(df_pad_onda2, aes(x = Metodo, y = pad, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de PAD - Onda 2", x = "Método", y = "PAD") +
  theme_minimal()

################################################################################
################################ Onda 3 ########################################
################################################################################
cat("### Estatísticas Onda 3 - PMM\n")
summary(dadosOnda3Mice_inp)
cat("### Estatísticas Onda 3 - kNN\n")
summary(dadosOnda3kNN_inp)

### Comparação de estatísticas resumo para a Onda 3
### Potássio
stats_compare_pot_onda3 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfPotassio$pot_onda3, na.rm = TRUE),
            mean(dadosOnda3kNN_inp$pot),
            mean(dadosOnda3Mice_inp$pot)),
  Mediana = c(median(dfPotassio$pot_onda3, na.rm = TRUE),
              median(dadosOnda3kNN_inp$pot),
              median(dadosOnda3Mice_inp$pot)),
  DesvioPadrao = c(sd(dfPotassio$pot_onda3, na.rm = TRUE),
                   sd(dadosOnda3kNN_inp$pot),
                   sd(dadosOnda3Mice_inp$pot))
)

### Sódio
stats_compare_sod_onda3 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfSodio$sod_onda3, na.rm = TRUE),
            mean(dadosOnda3kNN_inp$sod),
            mean(dadosOnda3Mice_inp$sod)),
  Mediana = c(median(dfSodio$sod_onda3, na.rm = TRUE),
              median(dadosOnda3kNN_inp$sod),
              median(dadosOnda3Mice_inp$sod)),
  DesvioPadrao = c(sd(dfSodio$sod_onda3, na.rm = TRUE),
                   sd(dadosOnda3kNN_inp$sod),
                   sd(dadosOnda3Mice_inp$sod))
)

### PAS
stats_compare_pas_onda3 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfPAS$PAS_onda3, na.rm = TRUE),
            mean(dadosOnda3kNN_inp$pas),
            mean(dadosOnda3Mice_inp$pas)),
  Mediana = c(median(dfPAS$PAS_onda3, na.rm = TRUE),
              median(dadosOnda3kNN_inp$pas),
              median(dadosOnda3Mice_inp$pas)),
  DesvioPadrao = c(sd(dfPAS$PAS_onda3, na.rm = TRUE),
                   sd(dadosOnda3kNN_inp$pas),
                   sd(dadosOnda3Mice_inp$pas))
)

### PAD
stats_compare_pad_onda3 <- data.frame(
  Método = c("Original (sem NA)", "kNN", "PMM"),
  Média = c(mean(dfPAD$PAD_onda3, na.rm = TRUE),
            mean(dadosOnda3kNN_inp$pad),
            mean(dadosOnda3Mice_inp$pad)),
  Mediana = c(median(dfPAD$PAD_onda3, na.rm = TRUE),
              median(dadosOnda3kNN_inp$pad),
              median(dadosOnda3Mice_inp$pad)),
  DesvioPadrao = c(sd(dfPAD$PAD_onda3, na.rm = TRUE),
                   sd(dadosOnda3kNN_inp$pad),
                   sd(dadosOnda3Mice_inp$pad))
)

# Exibindo tabelas resumo para Onda 3
print(stats_compare_pot_onda3)
print(stats_compare_sod_onda3)
print(stats_compare_pas_onda3)
print(stats_compare_pad_onda3)

### Preparando os dados para gráficos - Onda 3

# Potássio
df_pot_onda3 <- data.frame(
  pot = c(dfPotassio$pot_onda3,
          dadosOnda3kNN_inp$pot,
          dadosOnda3Mice_inp$pot),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfPotassio), nrow(dadosOnda3kNN_inp), nrow(dadosOnda3Mice_inp))))
)
# Sódio
df_sod_onda3 <- data.frame(
  sod = c(dfSodio$sod_onda3,
          dadosOnda3kNN_inp$sod,
          dadosOnda3Mice_inp$sod),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfSodio), nrow(dadosOnda3kNN_inp), nrow(dadosOnda3Mice_inp))))
)
# PAS
df_pas_onda3 <- data.frame(
  pas = c(dfPAS$PAS_onda3,
          dadosOnda3kNN_inp$pas,
          dadosOnda3Mice_inp$pas),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfPAS), nrow(dadosOnda3kNN_inp), nrow(dadosOnda3Mice_inp))))
)
# PAD
df_pad_onda3 <- data.frame(
  pad = c(dfPAD$PAD_onda3,
          dadosOnda3kNN_inp$pad,
          dadosOnda3Mice_inp$pad),
  Metodo = factor(rep(c("Original (sem NA)", "kNN", "PMM"),
                      times = c(nrow(dfPAD), nrow(dadosOnda3kNN_inp), nrow(dadosOnda3Mice_inp))))
)

### Gráficos de Densidade - Onda 3
ggplot(df_pot_onda3, aes(x = pot, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de Potássio - Onda 3", x = "Potássio", y = "Densidade") +
  theme_minimal()

ggplot(df_sod_onda3, aes(x = sod, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de Sódio - Onda 3", x = "Sódio", y = "Densidade") +
  theme_minimal()

ggplot(df_pas_onda3, aes(x = pas, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de PAS - Onda 3", x = "PAS", y = "Densidade") +
  theme_minimal()

ggplot(df_pad_onda3, aes(x = pad, fill = Metodo)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribuição de PAD - Onda 3", x = "PAD", y = "Densidade") +
  theme_minimal()

### Boxplots - Onda 3
ggplot(df_pot_onda3, aes(x = Metodo, y = pot, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de Potássio - Onda 3", x = "Método", y = "Potássio") +
  theme_minimal()

ggplot(df_sod_onda3, aes(x = Metodo, y = sod, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de Sódio - Onda 3", x = "Método", y = "Sódio") +
  theme_minimal()

ggplot(df_pas_onda3, aes(x = Metodo, y = pas, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de PAS - Onda 3", x = "Método", y = "PAS") +
  theme_minimal()

ggplot(df_pad_onda3, aes(x = Metodo, y = pad, fill = Metodo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Boxplot de PAD - Onda 3", x = "Método", y = "PAD") +
  theme_minimal()