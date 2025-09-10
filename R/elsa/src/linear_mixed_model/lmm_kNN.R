################################################################################
########################## Passo 1. Preparar os dados ##########################
################################################################################
if(!require(pacman)) install.packages("pacman")
library(pacman)
pacman::p_load(DHARMa, ggeffects, ggplot2, lme4, performance, tidyr)

# carregar base
dados <- read.csv("./dados_elsa/dados_long_kNN.csv", stringsAsFactors = FALSE)

# fatores
#dados$id_elsa <- factor(dados$id_elsa)
dados$onda <- as.integer(dados$onda)
dados$onda_f <- factor(dados$onda)

# manter apenas colunas de interesse
vars <- c("taxa_filt", "hip", "pot","sod","hba1c","insulina","antidiabeticos_orais",
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
mod0 <- lmerTest::lmer(taxa_filt ~ onda + hip + pot + sod + hba1c + insulina + 
                         antidiabeticos_orais + albcreat + pad + pas + diabetes + 
                         (1 | id_elsa),
                       data = dados_sub, REML = TRUE)
summary(mod0)
performance::icc(mod0)
ggeffects::ggpredict(mod0)
performance::r2(mod0)
################################################################################
########################### Passo 4. Diagnóstico ###############################
################################################################################
plot(mod0)
qqnorm(resid(mod0))
qqline(resid(mod0))
sim <- DHARMa::simulateResiduals(fittedModel = mod0)
plot(sim)
################################################################################
############################ plot fixed each effect ############################
################################################################################
### Albumina Creatinina
ggeffects::ggpredict(mod0, terms=c("albcreat", "id_elsa[sample=9]"), type = "random") %>%
  plot() +
  labs(x="Albumina|Creatinina", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X AlbCreat") + 
  theme_minimal()

model1_fixef_albcreat <- ggpredict(mod0, "albcreat") 
model1_fixef_albcreat 
plot(model1_fixef_albcreat) + labs(x="Albumina|Creatinina", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X AlbCreat")
################################################################################
### onda
ggeffects::ggpredict(mod0, terms=c("onda", "id_elsa[sample=9]"), type = "random") %>%
  plot() +
  labs(x="onda", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X onda") + 
  theme_minimal()

model1_fixef_albcreat <- ggpredict(mod0, "onda") 
model1_fixef_albcreat 
plot(model1_fixef_albcreat) + labs(x="onda", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X onda")
################################################################################
### pot 
ggeffects::ggpredict(mod0, terms=c("pot", "id_elsa[sample=9]"), type = "random") %>%
  plot() +
  labs(x="pot", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X pot") + 
  theme_minimal()

model1_fixef_pot <- ggpredict(mod0, "pot") 
model1_fixef_pot 
plot(model1_fixef_pot) + labs(x="pot", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X pot")
################################################################################
### sod 
ggeffects::ggpredict(mod0, terms=c("sod", "id_elsa[sample=9]"), type = "random") %>%
  plot() +
  labs(x="sod", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X sod") + 
  theme_minimal()

model1_fixef_sod <- ggpredict(mod0, "sod") 
model1_fixef_sod 
plot(model1_fixef_sod) + labs(x="sod", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X sod")
################################################################################
### hba1c 
ggeffects::ggpredict(mod0, terms=c("hba1c", "id_elsa[sample=9]"), type = "random") %>%
  plot() +
  labs(x="hba1c", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X hba1c") + 
  theme_minimal()

model1_fixef_hba1c <- ggpredict(mod0, "hba1c") 
model1_fixef_hba1c 
plot(model1_fixef_hba1c) + labs(x="hba1c", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X hba1c")
################################################################################
### insulina
ggeffects::ggpredict(mod0, terms=c("insulina", "id_elsa[sample=9]"), type = "random") %>%
  plot() +
  labs(x="insulina", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X insulina") + 
  theme_minimal()

model1_fixef_insulina <- ggpredict(mod0, "insulina") 
model1_fixef_insulina 
plot(model1_fixef_insulina) + labs(x="insulina", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X insulina")
################################################################################
### pad
ggeffects::ggpredict(mod0, terms=c("pad", "id_elsa[sample=9]"), type = "random") %>%
  plot() +
  labs(x="pad", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X pad") + 
  theme_minimal()

model1_fixef_pad <- ggpredict(mod0, "pad") 
model1_fixef_pad 
plot(model1_fixef_pad) + labs(x="pad", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X pad")
################################################################################
### pas
ggpredict(mod0, terms=c("pas", "id_elsa[sample=9]"), type = "random") %>%
  plot() +
  labs(x="pas", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X pas") + 
  theme_minimal()

model1_fixef_pas <- ggpredict(mod0, "pas") 
model1_fixef_pas 
plot(model1_fixef_pas) + labs(x="pas", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X pas")
################################################################################
### diabetes
model1_fixef_diabetes <- ggpredict(mod0, "diabetes") 
model1_fixef_diabetes 
plot(model1_fixef_diabetes) + labs(x="diabetes", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X diabetes")
################################################################################
################################################################################
### hip
ggpredict(mod0, terms=c("hip", "id_elsa[sample=9]"), type = "random") %>%
  plot() +
  labs(x="hip", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X hip") + 
  theme_minimal()

model1_fixef_hip <- ggpredict(mod0, "hip") 
model1_fixef_hip 
plot(model1_fixef_hip) + labs(x="diabetes", y = "Taxa de Filtracao Glomerular", title = "Efeito de taxa de filtracao Glomerular X hip")
################################################################################
# Check fitted vs. real
Pred_model_1 <- predict(mod0)
mydata_model_1 <- dados_sub %>% drop_na()
mydata_model_1 <- cbind(mydata_model_1, Pred_model_1)
ggplot(mydata_model_1, aes(x = Pred_model_1, y = taxa_filt)) +
  geom_point() + 
  geom_smooth(method=lm) + 
  theme_bw(base_size = 16) +  
  xlab("Taxa de filtração glomerular prevista") +  
  ylab("Taxa de filtração glomerular Medida")