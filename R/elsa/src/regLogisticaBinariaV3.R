if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(dplyr,ggplot2, car, fpp)
source("./src/script_analise_dados_elsa_Var_Lib.R")
source("./src/dadosRegLogistica.R")

removeOurliers <- function(df, elem){
  # Calcular o IQR da coluna original
  Q1 <- quantile(df[[elem]], 0.25)
  Q3 <- quantile(df[[elem]], 0.75)
  IQR <- IQR(df[[elem]])
  
  # Definir os limites inferior e superior para identificar os outliers
  lower_bound <- Q1 - (1.5 * IQR)
  upper_bound <- Q3 + (1.5 * IQR)
  
  idx <- which(df[[elem]] >= lower_bound & df[[elem]] <= upper_bound)
  return(idx)
}

dadosOnda1 <- data.frame(hip = dataGLM$hip_onda1,
                         pot = dataGLM$pot_onda1,
                         sod = dataGLM$sod_onda1,
                         albCreat = dataGLM$albCreat_onda1,
                         pas = dataGLM$PAS_onda1,
                         pad = dataGLM$PAD_onda1,
                         filt = dataGLM$filt_onda1
)

###Transformacao de hip em variavel dummy para usar proporcao
dadosOnda1$hip <- ifelse(dadosOnda1$hip == "S", 1, 0)
dadosOnda1$ntotal <- 1
################################################################################
idx_pas_sem_outliers <- removeOurliers(dadosOnda1, "pas")
################################################################################
dadosOnda1_hip_pas_sen_outliers <- data.frame(hip = dadosOnda1$hip[idx_pas_sem_outliers],
                                              pas = dadosOnda1$pas[idx_pas_sem_outliers],
                                              ntotal = dadosOnda1$ntotal[idx_pas_sem_outliers]
                                      )
################################################################################
lambda_pas <- BoxCox.lambda (dadosOnda1_hip_pas_sen_outliers$pas, method=c("loglik"), lower=-3, upper= 3)
dadosOnda1_hip_pas_sen_outliers$pas_boxcox <- BoxCox(dadosOnda1_hip_pas_sen_outliers$pas, lambda_pas)
attr(dadosOnda1$pas_boxcox, "lambda") <- NULL
################################################################################
head(dadosOnda1_hip_pas_sen_outliers$pas_boxcox)
str(dadosOnda1_hip_pas_sen_outliers$pas_boxcox)
summary(dadosOnda1_hip_pas_sen_outliers$pas_boxcox)
################################################################################
m1 <- glm(data = dadosOnda1_hip_pas_sen_outliers, (hip/ntotal)~pas_boxcox, family = binomial, weights = ntotal)
m1nulo <- glm(data = dadosOnda1_hip_pas_sen_outliers, (hip/ntotal)~1, family = binomial, weights = ntotal)
################################################################################
residuals_std <- rstandard(m1)
anova(m1nulo, m1, test="Chisq")
anova(m1, test="Chisq")
################################################################################
qqnorm(residuals_std, main = "Normal Q-Q Plot dos Resíduos Padronizados")
qqline(residuals_std, col = "red")
plot(m1, which = 1)
plot(m1, which = 2)
plot(m1, which = 3)
plot(m1, which = 4)
plot(m1, which = 5)
plot(m1, which = 6)


qq_plot <- ggplot(data.frame(residuals_std), aes(sample = residuals_std)) +
  stat_qq() +
  stat_qq_line(col = "red") +
  geom_hline(yintercept = min(residuals_std), linetype = "dashed", color = "blue") +
  geom_hline(yintercept = max(residuals_std), linetype = "dashed", color = "green") +
  ggtitle("Normal Q-Q Plot dos Resíduos Padronizados")

print(qq_plot)

