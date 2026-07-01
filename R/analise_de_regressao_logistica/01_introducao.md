# 1. Introdução e Motivação

## 1.1 Por que não usar regressão linear?

Quando a variável resposta $Y$ é **binária** — assume apenas os valores
$0$ (fracasso, ausência) e $1$ (sucesso, presença) — a regressão linear
ordinária (OLS) apresenta três problemas fundamentais:

| Problema | Descrição |
|:---|:---|
| **Previsões fora de [0,1]** | $\hat{y} = \mathbf{x}^\top\boldsymbol{\beta}$ pode assumir qualquer valor real, gerando "probabilidades" negativas ou > 1 |
| **Heterocedasticidade estrutural** | $Y \mid \mathbf{x} \sim \text{Bernoulli}(p(\mathbf{x}))$, logo $\text{Var}(Y \mid \mathbf{x}) = p(\mathbf{x})(1-p(\mathbf{x}))$, que depende de $\mathbf{x}$ — viola homocedasticidade |
| **Não normalidade dos resíduos** | Resíduos $\varepsilon_i = y_i - \hat{y}_i$ assumem apenas dois valores possíveis para cada $\mathbf{x}_i$, invalidando testes $t$ e $F$ |

A solução é modelar a **probabilidade condicional**
$\pi(\mathbf{x}) = P(Y=1 \mid \mathbf{x})$ por meio de uma função que
mapeie $\mathbb{R} \to (0,1)$. A função escolhida é a **sigmoide
logística**.

## 1.2 Objetivo da Análise

Diferentemente de problemas de **predição** (classificar novos casos),
a **análise** de regressão logística busca responder:

1.  **Quais variáveis exercem efeito significativo sobre a ocorrência do
    evento?** (Teste de Wald, TRV)
2.  **Qual a magnitude e direção desse efeito?** (Odds Ratio, efeitos
    marginais)
3.  **O modelo se ajusta adequadamente aos dados?** (Pseudo-R²,
    Hosmer-Lemeshow, diagnóstico de resíduos)
4.  **Qual a incerteza associada às estimativas?** (Intervalos de
    confiança, erros-padrão)

## 1.3 Suposições do Modelo

A regressão logística binária baseia-se nas seguintes suposições:

1.  **Resposta binária:** $Y_i \in \{0,1\}$.
2.  **Independência:** as observações são independentes entre si.
3.  **Linearidade no logit:** $\text{logit}(\pi_i) = \mathbf{x}_i^\top\boldsymbol{\beta}$ é linear nos parâmetros.
4.  **Ausência de multicolinearidade severa:** as preditoras não são
    fortemente correlacionadas entre si.
5.  **Tamanho da amostra:** recomenda-se no mínimo 10 eventos por
    parâmetro estimado (regra de eventos por variável, EPV).

> **Nota:** Diferentemente da regressão linear, a logística **não**
> exige normalidade dos resíduos, homocedasticidade, nem que a relação
> entre $Y$ e $\mathbf{x}$ seja linear na escala original.

## 1.4 Aplicações Típicas em Análise

-   **Medicina:** estimar o efeito de um tratamento sobre a
    probabilidade de cura, ajustando por confundidores
-   **Economia:** medir o impacto de anos de escolaridade sobre a
    probabilidade de estar empregado
-   **Epidemiologia:** calcular odds ratio de exposição a um fator de
    risco, controlando por covariáveis
-   **Ciências sociais:** avaliar o efeito de variáveis demográficas
    sobre a probabilidade de um comportamento

## 1.5 Fluxo da Análise

```
                    Dados
                      |
                      v
         1.  Análise exploratória
         2.  Especificação do modelo
         3.  Estimação (MV)
         4.  Interpretação dos coeficientes / OR
         5.  Testes de hipóteses (Wald, TRV)
         6.  Avaliação do ajuste (R², AIC, deviance)
         7.  Diagnóstico (resíduos, Hosmer-Lemeshow)
         8.  Conclusões analíticas
```

---

**Próximo:** [2. O Modelo Logístico](./02_modelo_logistico.md)
