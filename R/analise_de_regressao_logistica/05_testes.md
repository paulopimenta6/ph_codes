# 5. Testes de Hipóteses

Na análise de regressão logística, os testes de hipóteses são
ferramentas centrais para **inferência** — determinam se as variáveis
exercem efeito estatisticamente significativo sobre a resposta.

## 5.1 Teste da Razão de Verossimilhanças (TRV) — Global

### Objetivo

Avaliar se o modelo completo é **globalmente** superior ao modelo nulo
(modelo sem preditoras).

### Hipóteses

$$H_0: \beta_1 = \beta_2 = \cdots = \beta_p = 0$$
$$H_1: \exists\, j \in \{1,\ldots,p\} \text{ tal que } \beta_j \neq 0$$

### Estatística de Teste

$$G = 2\left[\ell(\hat{\boldsymbol{\beta}}) - \ell_0\right]$$

Sob $H_0$, para amostras grandes:

$$G \stackrel{H_0}{\sim} \chi^2_{(p)}$$

onde $p$ é o número de preditoras (diferença no número de parâmetros
entre os dois modelos).

### Interpretação

$G$ mede o ganho de ajuste ao adicionar as $p$ preditoras. Quanto maior
$G$, maior a evidência contra $H_0$.

### Protocolo de Decisão

1.  Fixar $\alpha$ (geralmente $0{,}05$)
2.  Calcular $G = 2[\ell(\hat{\boldsymbol{\beta}}) - \ell_0]$
3.  Obter valor-p: $P(\chi^2_{(p)} \geq G)$
4.  Se valor-p $< \alpha$, rejeitar $H_0$ — o modelo é globalmente
    significativo

### Relação com Deviance

$G$ equivale à **redução de deviance**: $G = D_0 - D$, onde $D_0$ é a
deviance nula e $D$ a deviance residual.

## 5.2 Teste de Wald — Coeficientes Individuais

### Objetivo

Avaliar a significância de **cada coeficiente** individualmente,
mantendo as demais variáveis no modelo.

### Hipóteses

Para cada $j = 0, 1, \ldots, p$:

$$H_0: \beta_j = 0 \qquad \text{vs.} \qquad H_1: \beta_j \neq 0$$

### Estatística de Teste

**Forma Qui-Quadrado:**

$$W_j = \left(\frac{\hat{\beta}_j}{\widehat{SE}(\hat{\beta}_j)}\right)^2
\stackrel{H_0}{\sim} \chi^2_{(1)}$$

**Forma Normal (z):**

$$z_j = \frac{\hat{\beta}_j}{\widehat{SE}(\hat{\beta}_j)}
\stackrel{H_0}{\sim} \mathcal{N}(0,1)$$

As duas formas são equivalentes: $W_j = z_j^2$.

### Erro Padrão

O erro padrão de $\hat{\beta}_j$ é a raiz quadrada do $j$-ésimo
elemento diagonal da matriz de covariância:

$$\widehat{\text{Cov}}(\hat{\boldsymbol{\beta}}) =
\left(\mathbf{X}^\top \widehat{\mathbf{W}} \mathbf{X}\right)^{-1}$$

onde $\widehat{\mathbf{W}} = \text{diag}\{\hat{\pi}_i(1 - \hat{\pi}_i)\}$.

### Tabela de Decisão

| Valor-p | Interpretação |
|:---:|:---|
| $< 0{,}001$ | Evidência muito forte contra $H_0$ ($***$) |
| $< 0{,}01$ | Evidência forte contra $H_0$ ($**$) |
| $< 0{,}05$ | Evidência moderada contra $H_0$ ($*$) |
| $\geq 0{,}05$ | Insuficiente para rejeitar $H_0$ |

## 5.3 TRV vs. Wald: Comparação

| Aspecto | TRV | Wald |
|:---|:---|:---|
| Escopo | Global ou subconjunto de parâmetros | Individual |
| Invariância a reparametrização | Sim | Não |
| Precisão | Geralmente mais confiável (especialmente em amostras pequenas) | Pode ser instável para $|\hat{\beta}_j| \to \infty$ |
| Cálculo | Requer ajustar dois modelos | Apenas o modelo completo |
| Saída do R | `anova(modelo_nulo, modelo, test="Chisq")` | `summary(modelo)` (z value) |
| Saída Python | $2 \times (\texttt{modelo\_sm.llf} - \texttt{modelo\_nulo.llf})$ | `modelo_sm.tvalues`² |

> **Recomendação:** Prefira TRV para decisões globais (testar um conjunto
> de variáveis) e Wald como aproximação rápida para coeficientes
> individuais. Em amostras grandes, ambos convergem para a mesma
> conclusão.

## 5.4 Teste de Wald para Múltiplos Coeficientes

Para testar simultaneamente $q$ restrições lineares
$\mathbf{R}\boldsymbol{\beta} = \mathbf{0}$:

$$W = (\mathbf{R}\hat{\boldsymbol{\beta}})^\top
\left(\mathbf{R}\,\widehat{\text{Cov}}(\hat{\boldsymbol{\beta}})\,\mathbf{R}^\top\right)^{-1}
(\mathbf{R}\hat{\boldsymbol{\beta}})
\stackrel{H_0}{\sim} \chi^2_{(q)}$$

**Exemplo:** Testar se $\beta_1 = \beta_2 = 0$ (duas preditoras):

$$\mathbf{R} = \begin{pmatrix}
0 & 1 & 0 \\
0 & 0 & 1
\end{pmatrix}$$

## 5.5 Intervalos de Confiança

### Para Coeficientes $\beta_j$

$$IC_{95\%}(\beta_j) = \hat{\beta}_j \pm z_{0{,}025} \cdot \widehat{SE}(\hat{\beta}_j)$$

### Para Odds Ratios $e^{\beta_j}$

$$IC_{95\%}(OR_j) = \exp\left(\hat{\beta}_j \pm z_{0{,}025} \cdot \widehat{SE}(\hat{\beta}_j)\right)$$

**Interpretação:** Se o IC do OR excluir 1, o efeito é
estatisticamente significativo ao nível $\alpha$.

---

**Anterior:** [4. Avaliação](./04_avaliacao.md)
