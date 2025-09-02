################################################################################
########################## Passo 1. Preparar os dados ##########################
################################################################################
if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(lme4, ggeffects)

# carregar base
dados <- read.csv("./dados_elsa/dados_long.csv", stringsAsFactors = FALSE)

# fatores
#dados$id_elsa <- factor(dados$id_elsa)
dados$onda <- as.integer(dados$onda)
dados$onda_f <- factor(dados$onda)

# manter apenas colunas de interesse
vars <- c("taxa_filt","pot","sod","hba1c","insulina","antidiabeticos_orais",
          "albcreat","diabetes","pad","pas","onda","id_elsa")
dados_sub <- dados[, vars]

# padronizar preditores contínuos
cont_vars <- c("pot","sod","hba1c","albcreat","pad","pas")
dados_sub[cont_vars] <- scale(dados_sub[cont_vars])

# fatores binários
dados_sub$diabetes <- factor(dados_sub$diabetes)
if("antidiabeticos_orais" %in% names(dados_sub)){
  dados_sub$antidiabeticos_orais <- factor(dados_sub$antidiabeticos_orais)
}
################################################################################
################ Passo 2. Modelo inicial (intercepto aleatório #################
mod0 <- lmerTest::lmer(taxa_filt ~ onda + pot + sod + hba1c + insulina + 
                              antidiabeticos_orais + albcreat + pad + pas + diabetes + 
                              (1 | id_elsa),
                            data = dados_sub, REML = TRUE)
summary(mod0)
################################################################################
### Retirando:
###Fixed effects:           Estimate    Std.   Error      df t   value Pr(>|t|)
### antidiabeticos_orais1   -0.4375     0.4936 8167.7699  -0.886 0.375397 
### diabetes1                0.5735     0.7568 6994.0414   0.758 0.448651
################################################################################
########### Passo 3. Testar random slope  (só slope aleatório) #################
################################################################################
#mod_taxa_rs <- lmerTest::lmer(taxa_filt ~ onda + pot + sod + hba1c + insulina +
#                                antidiabeticos_orais + albcreat + pad + pas + diabetes + 
#                                (0 + onda | id_elsa),
#                              data = dados_sub, REML = FALSE)
#anova(mod_taxa_rs, mod0, refit=FALSE)
################################################################################
ggeffects::ggpredict(mod0)
################################################################################
################ Passo 4. Testando um modelo complexo ##########################
################################################################################
mod1 <- lmerTest::lmer(taxa_filt ~ onda + pot + sod + hba1c + insulina + 
                       albcreat + pad + pas +
                       (1 | id_elsa),
                       data = dados_sub)
anova(mod1, mod0)
summary(mod1)
################################################################################
### Sera retido o modelo simples
################################################################################
ggeffects::ggpredict(mod1, terms=c("albcreat", "id_elsa[sample=9]"), type = "fixed") %>%
  plot() +
  labs(x="Albumina|Creatinina", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X AlbCreat") + 
  theme_minimal()