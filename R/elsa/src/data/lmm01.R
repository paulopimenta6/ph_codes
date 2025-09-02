################################################################################
########################## Passo 1. Preparar os dados ##########################
################################################################################
# carregar pacotes
library(lme4)
library(lmerTest)
library(DHARMa)
library(performance)
library(clubSandwich)
library(robustlmm)

# carregar base
dados <- read.csv("./dados_elsa/dados_long.csv", stringsAsFactors = FALSE)

# fatores
dados$id_elsa <- factor(dados$id_elsa)
dados$onda <- as.integer(dados$onda)
dados$onda_f <- factor(dados$onda)

# manter apenas colunas de interesse
vars <- c("taxa_filt","pot","sod","hba1c","insulina","antidiabeticos_orais",
          "albcreat","diabetes","pad","pas","onda","id_elsa")
dados_sub <- dados[complete.cases(dados[, vars]), ]

# padronizar preditores contínuos
cont_vars <- c("pot","sod","hba1c","insulina","albcreat","pad","pas")
dados_sub[cont_vars] <- scale(dados_sub[cont_vars])

# fatores binários
dados_sub$diabetes <- factor(dados_sub$diabetes)
if("antidiabeticos_orais" %in% names(dados_sub)){
  dados_sub$antidiabeticos_orais <- factor(dados_sub$antidiabeticos_orais)
}
################################################################################
################ Passo 2. Modelo inicial (intercepto aleatório #################
mod_taxa0 <- lmer(taxa_filt ~ onda + pot + sod + hba1c + insulina + 
                    antidiabeticos_orais + albcreat + pad + pas + diabetes + 
                    (1 | id_elsa),
                  data = dados_sub, REML = TRUE)
summary(mod_taxa0)
performance::icc(mod_taxa0)
################################################################################
######################### Passo 3. Testar random slope #########################
################################################################################
mod_taxa_rs <- lmer(taxa_filt ~ onda + pot + sod + hba1c + insulina +
                      antidiabeticos_orais + albcreat + pad + pas + diabetes + 
                      (1 + onda | id_elsa),
                    data = dados_sub, REML = TRUE,
                    control = lmerControl(check.nobs.vs.nRE="ignore"))
anova(mod_taxa0, mod_taxa_rs)
################################################################################
########################## Passo 4. Seleção de fixos ###########################
################################################################################
mod_taxa0_ml <- update(mod_taxa0, REML = FALSE)
mod_taxa_noAlb <- update(mod_taxa0_ml, . ~ . - albcreat)
anova(mod_taxa0_ml, mod_taxa_noAlb)
################################################################################
########################### Passo 5. Diagnóstico ###############################
################################################################################
plot(mod_taxa0)
qqnorm(resid(mod_taxa0)); qqline(resid(mod_taxa0))
sim <- simulateResiduals(mod_taxa0); plot(sim)
################################################################################
########################### Passo 6. ICs e robustez ############################
###########################################################confint(mod_taxa0, method="profile", parm="beta_", oldNames=FALSE)
coef_test(mod_taxa0, vcov="CR2", cluster=dados_sub$id_elsa)

# versão robusta (se outliers forem problema)
mod_taxa_rlmer <- rlmer(taxa_filt ~ onda + pot + sod + hba1c + insulina + 
                          antidiabeticos_orais + albcreat + pad + pas + diabetes + 
                          (1 | id_elsa),
                        data = dados_sub)
summary(mod_taxa_rlmer)
#####################
