# Regressão Logística Binária — Tutorial de Análise 📊

**Inferência + Interpretação + Implementação em R e Python**

> Um tutorial **rigoroso e lúdico** com foco em **análise** (e não
> predição): interpretação de coeficientes, odds ratios, efeitos
> marginais, testes de hipóteses, diagnóstico do modelo e inferência
> estatística.

---

## Sobre este Tutorial ☕

Este tutorial nasceu de notas de aula manuscritas e foi expandido com
formalismo estatístico completo. Acompanhe a história do **Seu Bento**,
dono de uma cafeteria, que quer entender o que influencia o sorteio do
"vale-café" — ou seja: compreender **relações**, testar **hipóteses** e
quantificar **efeitos**, e não apenas classificar clientes.

### Características

- **Foco analítico** — coeficientes, OR, efeitos marginais, significância
- **Formalismo matemático rigoroso** — derivações completas em LaTeX
- **Fundamentação estatística** — suposições, diagnóstico, testes
- **Código reutilizável** — R e Python totalmente funcionais
- **Dados simulados automáticos** — nenhum arquivo externo necessário
- **Leitura leve** — analogias, "ciladas", quizzes e resumos em cada capítulo

### Convenções de leitura 🎨

| Símbolo | Significado |
|:---:|:---|
| 🎯 | Objetivos do capítulo |
| 💡 | Sacada — intuição que simplifica |
| ⚠️ | Cilada — erro comum a evitar |
| 🧪 | Teste seu radar — quiz com respostas |
| ✅ | Para levar — resumo do capítulo |
| 🚩 | Erro comum (para não repetir) |

---

## Mapa do Tutorial 🗺️

| Seção | Descrição | Trilha |
|:---|:---|:---|
| [00. README](./00_README.md) | Este mapa: por onde começar e como estudar | — |
| [1. Introdução](./01_introducao.md) | Por que a regressão linear falha, suposições, aplicações, fluxo | 1ª leitura |
| [2. Modelo Logístico](./02_modelo_logistico.md) | Sigmoide, logit, odds ratio, efeitos marginais | 2ª leitura |
| [3. Estimação MV](./03_estimacao.md) | Máxima verossimilhança, log-verossimilhança, algoritmo IRLS | 3ª leitura |
| [4. Avaliação](./04_avaliacao.md) | Pseudo-R², AIC, BIC, deviance, diagnóstico, Hosmer-Lemeshow | 4ª leitura |
| [5. Testes de Hipóteses](./05_testes.md) | TRV global, Teste de Wald, intervalos de confiança | 5ª leitura |
| [6. Da Teoria ao Código](./06_da_teoria_ao_codigo.md) | Mapa teoria↔código, leitura guiada da saída, experimentos | depois da teoria |
| [7. Script R](./07_implementacao_r.R) | Implementação completa com foco analítico | quando quiser rodar |
| [8. Script Python](./08_implementacao_python.py) | Implementação completa com foco analítico | quando quiser rodar |
| [9. Glossário](./09_glossario.md) | Termos "em uma frase", cola de fórmulas, sinais de alerta | consulta |

---

## Como Estudar (3 Trilhas) 🧭

**🐢 Trilha da calma (teoria primeiro):**
1 → 2 → 3 → 4 → 5 → 6 → (rode os scripts) → 9 sempre à mão.

**🎧 Trilha do ouvinte (conceitos primeiro):**
leia os ✅ resumos e 💡 sacadas de 1–5, depois faça a trilha da calma
com calma.

**🛠️ Trilha hands-on (mãos na massa):**
rode o [R](./07_implementacao_r.R) ou o [Python](./08_implementacao_python.py),
e vá ao capítulo 6 para entender cada bloco da saída; volte aos demais
capítulos apenas quando uma dúvida aparecer.

---

## Quick Start ⚡

### Executar os códigos

```bash
# R (instala os pacotes automaticamente na primeira vez)
Rscript 07_implementacao_r.R

# Python (instale as dependências antes)
pip install numpy pandas scipy scikit-learn statsmodels matplotlib
python 08_implementacao_python.py
```

💡 **Dica (WSL/Linux):** use um venv para não poluir o Python do sistema:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install numpy pandas scipy scikit-learn statsmodels matplotlib
```

A saída inclui tabelas de coeficientes/OR, efeitos marginais, testes
(TRV, Wald, Hosmer-Lemeshow), diagnóstico de resíduos e gráficos
(`*_eda.png`, `*_roc.png`).

---

## Arquivos 📁

```
analise_de_regressao_logistica/
├── 00_README.md              ← você está aqui
├── 01_introducao.md          ← por que linear falha; suposições; fluxo
├── 02_modelo_logistico.md    ← sigmoide, logit, OR, efeitos marginais
├── 03_estimacao.md           ← MV, IRLS, propriedades assintóticas
├── 04_avaliacao.md           ← McFadden, AIC/BIC, H-L, resíduos
├── 05_testes.md              ← TRV, Wald, intervalos de confiança
├── 06_da_teoria_ao_codigo.md ← teoria ↔ código, saída guiada
├── 07_implementacao_r.R      ← script R completo
├── 08_implementacao_python.py← script Python completo
├── 09_glossario.md           ← glossário + cola de fórmulas
├── dados.csv                 ← gerado ao rodar os scripts (opcional)
└── old/                      ← versão anterior do tutorial
```

---

## Análise vs. Predição ⚖️

| Aspecto | Análise (foco deste tutorial) | Predição |
|:---|:---|:---|
| Objetivo | Entender relações, testar teorias | Classificar novos casos |
| Coeficientes | Interpretados como OR e efeitos marginais | Meio para um fim |
| Testes | TRV, Wald, Hosmer-Lemeshow | Validação cruzada |
| Avaliação | Pseudo-R², AIC, deviance | AUC, acurácia em teste |
| Pergunta | *Qual o efeito de X sobre Y?* | *Qual a classe de Y?* |

---

## Pré-requisitos

- **R** ≥ 4.0 ou **Python** ≥ 3.8
- Conceitos básicos de probabilidade (distribuição Bernoulli) e
  estatística (teste de hipóteses, valor-p)
- Curiosidade para brincar com os números

---

## Licença e Autor

**MIT** — Livre para usar e modificar.

**Paulo Pimenta** — Baseado em notas de aula revisadas.

**Versão:** 3.0 \| **Data:** 2026-08-11