# 3. Estimação por Máxima Verossimilhança

## 3.1 O Princípio

A **Máxima Verossimilhança** (MV) encontra os valores de
$\boldsymbol{\beta} = (\beta_0, \beta_1, \ldots, \beta_p)^\top$ que
**maximizam a probabilidade de observar os dados coletados**, dado o
modelo especificado.

Diferentemente da regressão linear (que tem solução analítica via MQO),
a regressão logística **não tem solução fechada** — os estimadores são
obtidos por otimização numérica iterativa.

## 3.2 Função de Verossimilhança

Para $n$ observações independentes, com $y_i \in \{0,1\}$, cada
observação segue uma distribuição de Bernoulli:

$$Y_i \mid \mathbf{x}_i \sim \text{Bernoulli}(\pi(\mathbf{x}_i))$$

A função de probabilidade de uma observação é:

$$f(y_i \mid \mathbf{x}_i, \boldsymbol{\beta}) = \pi_i^{y_i} (1 - \pi_i)^{1 - y_i}$$

onde $\pi_i = \pi(\mathbf{x}_i) = P(Y_i = 1 \mid \mathbf{x}_i)$.

A verossimilhança conjunta (produto das $n$ observações independentes)
é:

$$\mathcal{L}(\boldsymbol{\beta}) = \prod_{i=1}^n \pi_i^{y_i} (1 - \pi_i)^{1 - y_i}$$

## 3.3 Log-Verossimilhança

Por conveniência analítica e numérica, maximizamos o **logaritmo
natural** da verossimilhança:

$$\ell(\boldsymbol{\beta}) = \sum_{i=1}^n \left[ y_i \ln \pi_i + (1 - y_i) \ln(1 - \pi_i) \right]$$

Substituindo $\pi_i = \sigma(z_i) = (1 + e^{-z_i})^{-1}$:

$$\ell(\boldsymbol{\beta}) = \sum_{i=1}^n \left[ y_i \ln\left(\frac{1}{1+e^{-z_i}}\right) + (1-y_i) \ln\left(\frac{e^{-z_i}}{1+e^{-z_i}}\right) \right]$$

Simplificando:

$$\ell(\boldsymbol{\beta}) = \sum_{i=1}^n \left[ y_i z_i - \ln(1 + e^{z_i}) \right]$$

onde $z_i = \mathbf{x}_i^\top \boldsymbol{\beta}$.

**Propriedades:**
- $\ell(\boldsymbol{\beta}) \leq 0$ (pois $\ln \pi_i \leq 0$)
- $\ell(\boldsymbol{\beta}) = 0$ somente se $\pi_i = y_i$ para todo $i$
  (ajuste perfeito)
- Maximizar $\ell$ equivale a minimizar a **entropia cruzada binária**

## 3.4 Exemplo Didático: Preferência por Café

Uma pesquisa com 10 pessoas constatou que 7 gostam de café (Y = 1) e 3
não (Y = 0). Sem preditoras, o modelo é $\pi = p$ (constante).

**Verossimilhança:**

$$\mathcal{L}(p) = p^7 (1-p)^3$$

**Log-verossimilhança:**

$$\ell(p) = 7\ln p + 3\ln(1-p)$$

**Condição de 1ª ordem:**

$$\frac{d\ell}{dp} = \frac{7}{p} - \frac{3}{1-p} = 0 \implies 7(1-p) = 3p \implies \hat{p} = \frac{7}{10} = 0{,}7$$

**Condição de 2ª ordem (máximo):**

$$\frac{d^2\ell}{dp^2} = -\frac{7}{p^2} - \frac{3}{(1-p)^2} < 0 \quad \forall p \in (0,1)$$

Logo $\hat{p} = 0{,}7$ é o **máximo global** — coincide com a proporção
amostral, como esperado.

## 3.5 Sistema de Equações (Modelo Geral)

Para o modelo com preditoras, derivamos $\ell$ em relação a cada
$\beta_j$:

$$\frac{\partial \ell}{\partial \beta_j} = \sum_{i=1}^n (y_i - \pi_i) x_{ij} = 0, \quad j = 0, 1, \ldots, p$$

Este sistema de $p+1$ equações **não lineares** em $\boldsymbol{\beta}$
não tem solução analítica fechada.

## 3.6 Algoritmo Iterativo: Newton-Raphson (IRLS)

A solução é obtida iterativamente. O algoritmo **Newton-Raphson** (ou
**IRLS** — *Iteratively Reweighted Least Squares*) atualiza os
parâmetros por:

$$\boldsymbol{\beta}^{(t+1)} = \boldsymbol{\beta}^{(t)} - \mathbf{H}^{-1}\big(\boldsymbol{\beta}^{(t)}\big) \, \mathbf{g}\big(\boldsymbol{\beta}^{(t)}\big)$$

onde:

- $\mathbf{g}(\boldsymbol{\beta}) = \mathbf{X}^\top(\mathbf{y} - \boldsymbol{\pi})$
  é o vetor gradiente
- $\mathbf{H}(\boldsymbol{\beta}) = -\mathbf{X}^\top \mathbf{W} \mathbf{X}$
  é a matriz hessiana
- $\mathbf{W} = \text{diag}\{\pi_i(1 - \pi_i)\}$ é a matriz de pesos

Na forma de **mínimos quadrados reponderados**:

$$\boldsymbol{\beta}^{(t+1)} = \left(\mathbf{X}^\top \mathbf{W}^{(t)} \mathbf{X}\right)^{-1} \mathbf{X}^\top \mathbf{W}^{(t)} \mathbf{z}^{(t)}$$

onde $\mathbf{z}^{(t)} = \mathbf{X}\boldsymbol{\beta}^{(t)} + (\mathbf{W}^{(t)})^{-1}(\mathbf{y} - \boldsymbol{\pi}^{(t)})$

é a variável dependente ajustada (*working response*).

### Algoritmos Disponíveis

| Algoritmo | Descrição | Implementação |
|:---|:---|:---|
| Newton-Raphson (IRLS) | Hessiana exata, convergência quadrática | `glm()` no R |
| BFGS / L-BFGS | Aproximação da hessiana, eficiente para muitos parâmetros | `statsmodels`, `scipy.optimize` |
| Gradiente Descendente | Atualização por mini-batch, escalável | `sklearn`, PyTorch, TensorFlow |

## 3.7 Propriedades dos Estimadores de MV

Sob condições de regularidade, para $n \to \infty$:

1.  **Consistência:** $\hat{\boldsymbol{\beta}} \xrightarrow{p} \boldsymbol{\beta}$
2.  **Normalidade assintótica:**
    $$\hat{\boldsymbol{\beta}} \sim \mathcal{N}_{p+1}\left(\boldsymbol{\beta},\,
    \mathbf{I}(\boldsymbol{\beta})^{-1}\right)$$
    onde $\mathbf{I}(\boldsymbol{\beta}) = -\mathbb{E}[\mathbf{H}(\boldsymbol{\beta})]$
    é a **matriz de informação de Fisher**.
3.  **Eficiência:** atinge o limite inferior de Cramér-Rao.

A matriz de covariância estimada é:

$$\widehat{\text{Cov}}(\hat{\boldsymbol{\beta}}) = \left(\mathbf{X}^\top \widehat{\mathbf{W}} \mathbf{X}\right)^{-1}$$

cujos elementos diagonais fornecem $\widehat{\text{Var}}(\hat{\beta}_j)$,
usados nos testes de Wald.

---

**Anterior:** [2. Modelo Logístico](./02_modelo_logistico.md) |
**Próximo:** [4. Avaliação do Modelo](./04_avaliacao.md)
