# Regressão Logística Binária — Tutorial de Análise

**Inferência + Interpretação + Implementação R e Python**

> Tutorial rigoroso focado em **análise** (e não predição): interpretação de
> coeficientes, odds ratios, efeitos marginais, testes de hipóteses,
> diagnóstico do modelo e inferência estatística.

---

## Sobre este Tutorial

Este tutorial nasceu de notas de aula manuscritas e foi expandido com
formalismo estatístico completo. O foco é **análise de regressão
logística binária** — compreender relações entre variáveis, testar
hipóteses e quantificar efeitos — e não a mera classificação ou
predição.

### Características

-   **Foco analítico** — interpretação de coeficientes, OR, efeitos
    marginais, significância estatística
-   **Formalismo matemático rigoroso** — derivações completas em LaTeX
-   **Fundamentação estatística** — suposições, diagnóstico, testes
-   **Código reutilizável** — R e Python totalmente funcionais
-   **Dados simulados automáticos** — nenhum arquivo externo necessário

---

## Estrutura do Tutorial

| Seção | Descrição |
|:---|:---|
| [1. Introdução](./01_introducao.md) | Por que regressão linear falha, suposições do modelo, aplicações |
| [2. Modelo Logístico](./02_modelo_logistico.md) | Sigmoide, logit, odds ratio, efeitos marginais |
| [3. Estimação MV](./03_estimacao.md) | Máxima verossimilhança, função de verossimilhança, algoritmo IRLS |
| [4. Avaliação](./04_avaliacao.md) | Pseudo-R², AIC, BIC, deviance, diagnóstico, Hosmer-Lemeshow |
| [5. Testes de Hipóteses](./05_testes.md) | TRV global, Teste de Wald, intervalos de confiança |
| [R](./07_implementacao_r.R) | Script R completo com foco analítico |
| [Python](./08_implementacao_python.py) | Script Python completo com foco analítico |

---

## Quick Start

### Leitura recomendada

1.  Introdução e motivação
2.  Modelo logístico (entender odds ratio e efeitos marginais)
3.  Estimação MV
4.  Avaliação e diagnóstico
5.  Testes de hipóteses

### Executar os códigos

``` bash
# R
Rscript 07_implementacao_r.R

# Python
python 08_implementacao_python.py
```

---

## Arquivos

```
R/analise_de_regressao_logistica/
├── 00_README.md
├── 01_introducao.md
├── 02_modelo_logistico.md
├── 03_estimacao.md
├── 04_avaliacao.md
├── 05_testes.md
├── 07_implementacao_r.R
├── 08_implementacao_python.py
└── old/                          # versão anterior do tutorial
```

---

## Diferença: Análise vs. Predição

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

---

## Licença

MIT — Livre para usar e modificar

---

## Autor

**Paulo Pimenta** — Baseado em notas de aula revisadas

**Versão:** 2.0 \| **Data:** 2026-06-06
