################################################################################
anderson_darling_test <- function(x) {
  result <- ad.test(x)
  return(tibble(statistic = result$statistic, p.value = result$p.value))
}

ks_test <- function(x) {
  result <- ks.test(x, "pnorm", mean = mean(x), sd = sd(x))
  return(tibble(statistic = result$statistic, p.value = result$p.value))
}
################################################################################