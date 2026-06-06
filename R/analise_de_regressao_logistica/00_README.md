# 📊 Regressão Logística Binária — Tutorial Completo

**Teoria + Formalismo + Implementação R e Python**

> Um tutorial rigoroso cobrindo desde a motivação matemática até implementação prática, com código reutilizável e exemplos interativos.

---

## 🎯 Sobre este Tutorial

Este é um **tutorial abrangente sobre regressão logística binária** que nasceu de notas de aula manuscritas e foi expandido com formalismo estatístico completo.

### ✨ Características

- ✅ **Cobertura teórica completa** — da motivação até implementação prática
- ✅ **Formalismo matemático rigoroso** — com LaTeX e equações bem explicadas
- ✅ **Código pronto para usar** — R e Python totalmente funcionais
- ✅ **Dados simulados automáticos** — não precisa de arquivo externo para começar
- ✅ **Visualizações profissionais** — gráficos publicáveis com ggplot2 e matplotlib
- ✅ **Testes estatísticos completos** — TRV, Wald, intervalos de confiança

---

## 📑 Estrutura do Tutorial

| Seção | Tempo | Descrição |
|-------|-------|-----------|
| [1. Introdução](./01_introducao.md) | 5 min | Por que não usar regressão linear? Aplicações. |
| [2. Modelo Logístico](./02_modelo_logistico.md) | 10 min | Função sigmoide, transformação logit, odds ratio. |
| [3. Estimação MV](./03_estimacao.md) | 15 min | Máxima verossimilhança, exemplo café. |
| [4. Avaliação](./04_avaliacao.md) | 15 min | Pseudo-R², matriz de confusão, ROC-AUC. |
| [5. Testes de Hipóteses](./05_testes.md) | 10 min | TRV global, Teste de Wald. |
| [6. Predição](./06_predicao.md) | 5 min | Como fazer previsões. |
| [7. R](./07_implementacao_r.Rmd) | 20 min | Script R completo. |
| [8. Python](./08_implementacao_python.py) | 20 min | Script Python completo. |

---

## 🚀 Quick Start

### Ler a Teoria
👉 [**regressao_logistica_binaria.md**](./analise_de_regressao_logistica_versao_1.pdf)

### Rodar Código

**Python (sem instalar)**
[![Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/paulopimenta6/ph_codes/blob/regressao-logistica-tutorial/notebooks/regressao_logistica.ipynb)

**Localmente**
```bash
python 08_implementacao_python.py
```

---

## 📚 Arquivos

```
R/analise_de_regressao_logistica/
├── 00_README.md (este arquivo)
├── regressao_logistica_binaria.md (completo)
├── 01_introducao.md
├── 02_modelo_logistico.md
├── 03_estimacao.md
├── 04_avaliacao.md
├── 05_testes.md
├── 06_predicao.md
├── 07_implementacao_r.Rmd
├── 08_implementacao_python.py
└── 09_comparativo_r_vs_python.md
```

---

## 💡 Pré-requisitos

- **R** ≥ 4.0 | **Python** ≥ 3.8
- Conhecimento básico de probabilidade e estatística

---

## ❓ FAQ

**Por que Pseudo-R² é diferente?**
Não há soma de quadrados em logística. Compara log-verossimilhanças.

**Quando usar logística?**
- Resposta binária + interpretabilidade ✅
- Máxima performance → Random Forest/SVM

**Desbalanceamento de classes?**
1. Estratificação (stratify=y)
2. class_weight='balanced'
3. Threshold adaptativo via ROC

---

## 📄 Licença

MIT — Livre para usar e modificar

---

## 👨‍💻 Autor

**Paulo Pimenta** — Baseado em notas de aula revisadas

**Versão:** 1.0 | **Data:** 2026-06-06
