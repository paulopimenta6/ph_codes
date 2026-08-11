# 3. Estimação por Máxima Verossimilhança — Como o Modelo "Aprende" 🎯

> **Continuando o caso:** o Seu Bento tem os dados de 350 clientes. Falta
> descobrir os valores de $\beta_0, \beta_1, \beta_2$ que melhor contam a
> história. Na linear, uma fórmula fechada resolvia. Na logística, o
> cérebro do modelo trabalha por **tentativa e ajuste** — a Máxima
> Verossimilhança.

🎯 **Neste capítulo:**

- o princípio da **máxima verossimilhança** (MV) em linguagem de botequim;
- a função de verossimilhança e sua prima, a log-verossimilhança;
- um exemplo didático completo (o café, claro!);
- o algoritmo **Newton-Raphson / IRLS**, que chuta e melhora sozinho;
- as propriedades assintóticas dos estimadores.

---

## 3.1 O Princípio 👓

A **Máxima Verossimilhança** (MV) encontra os valores de
$\boldsymbol{\beta} = (\beta_0, \beta_1, \ldots, \beta_p)^\top$ que
**maximizam a probabilidade de observar exatamente os dados coletados**,
dado o modelo especificado.

> 💡 **Sacada (versão botequim):** entre todas as "teorias da conspiração"
> (conjuntos de $\boldsymbol{\beta}$), escolha a que torna os números que
> você já viu o **menos surpreendentes** possível.

Diferentemente da regressão linear (que tem solução analítica via MQO),
a regressão logística **não tem solução fechada** — os estimadores são
obtidos por **otimização numérica iterativa** (mais adiante).

---

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

> 🔍 **Leitura:** cada cliente "vota" com sua probabilidade $\pi_i$. Se
> ele ganhou o vale ($y_i = 1$), a "voz" dele é $\pi_i$; se não, é
> $1-\pi_i$. O produto de todas as vozes é a verossimilhança.

---

## 3.3 Log-Verossimilhança

Por conveniência analítica e numérica, maximizamos o **logaritmo
natural** da verossimilhança:

$$\ell(\boldsymbol{\beta}) = \sum_{i=1}^n \left[ y_i \ln \pi_i + (1 - y_i) \ln(1 - \pi_i) \right]$$

Substituindo $\pi_i = \sigma(z_i) = (1 + e^{-z_i})^{-1}$ e simplificando:

$$\ell(\boldsymbol{\beta}) = \sum_{i=1}^n \left[ y_i z_i - \ln(1 + e^{z_i}) \right]$$

onde $z_i = \mathbf{x}_i^\top \boldsymbol{\beta}$.

**Propriedades:**
- Cada termo é $\leq 0$ (pois é uma probabilidade logaritmada), logo
  $\ell(\boldsymbol{\beta}) \leq 0$;
- $\ell(\boldsymbol{\beta}) = 0$ só quando $\pi_i = y_i$ para todo $i$
  (ajuste perfeito — suspeite!);
- Maximizar $\ell$ equivale a minimizar a **entropia cruzada binária**
  (o mesmo "custo" usado em redes neurais).

---

## 3.4 Exemplo Didático: Preferência por Café ☕

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
amostral, como deveria. O modelo "aprende" exatamente o que os dados
dizem.

---

## 3.5 Sistema de Equações (Modelo Geral)

Para o modelo com preditoras, derivamos $\ell$ em relação a cada
$\beta_j$:

$$\frac{\partial \ell}{\partial \beta_j} = \sum_{i=1}^n (y_i - \pi_i) x_{ij} = 0, \quad j = 0, 1, \ldots, p$$

> 🔍 **Leitura:** cada preditora $x_{ij}$ "pesa" o erro residual
> $(y_i - \pi_i)$. O sistema iguala somas de resíduos ponderados a zero.

Este sistema de $p+1$ equações **não lineares** em $\boldsymbol{\beta}$
não tem solução analítica fechada. Entra o algoritmo.

---

## 3.6 Algoritmo Iterativo: Newton-Raphson (IRLS) 🔁

A solução é obtida iterativamente. O algoritmo **Newton-Raphson** (ou
**IRLS** — *Iteratively Reweighted Least Squares*) atualiza os
parâmetros por:

$$\boldsymbol{\beta}^{(t+1)} = \boldsymbol{\beta}^{(t)} - \mathbf{H}^{-1}\big(\boldsymbol{\beta}^{(t)}\big) \, \mathbf{g}\big(\boldsymbol{\beta}^{(t)}\big)$$

onde:

- $\mathbf{g}(\boldsymbol{\beta}) = \mathbf{X}^\top(\mathbf{y} - \boldsymbol{\pi})$
  é o vetor gradiente ("pra onde a subida aponta");
- $\mathbf{H}(\boldsymbol{\beta}) = -\mathbf{X}^\top \mathbf{W} \mathbf{X}$
  é a matriz hessiana ("como a colina encurva");
- $\mathbf{W} = \text{diag}\{\pi_i(1 - \pi_i)\}$ é a matriz de pesos.

Na forma de **mínimos quadrados reponderados**:

$$\boldsymbol{\beta}^{(t+1)} = \left(\mathbf{X}^\top \mathbf{W}^{(t)} \mathbf{X}\right)^{-1} \mathbf{X}^\top \mathbf{W}^{(t)} \mathbf{z}^{(t)}$$

onde $\mathbf{z}^{(t)} = \mathbf{X}\boldsymbol{\beta}^{(t)} + (\mathbf{W}^{(t)})^{-1}(\mathbf{y} - \boldsymbol{\pi}^{(t)})$
é a variável dependente ajustada (*working response*).

> 💡 **Sacada:** passo a passo — (1) chute inicial de $\boldsymbol{\beta}$;
> (2) compute $\boldsymbol{\pi}$ e os pesos; (3) resolva um mínimos
> quadrados *ponderado*; (4) repita até convergir. Cada volta é um
> "chute melhor que o anterior". R faz isso em milissegundos como
> `glm(..., family = binomial)`.

### Algoritmos Disponíveis

| Algoritmo | Descrição | Implementação |
|:---|:---|:---|
| Newton-Raphson (IRLS) | Hessiana exata, convergência quadrática | `glm()` no R |
| BFGS / L-BFGS | Aproximação da hessiana, eficiente para muitos parâmetros | `statsmodels`, `scipy.optimize` |
| Gradiente Descendente | Atualização por mini-batch, escalável | `sklearn`, PyTorch, TensorFlow |

---

## 3.7 Propriedades dos Estimadores de MV 🏛️

Sob condições de regularidade, para $n \to \infty$:

1. **Consistência:** $\hat{\boldsymbol{\beta}} \xrightarrow{p} \boldsymbol{\beta}$
   — com dados suficientes, o alvo é o verdadeiro;
2. **Normalidade assintótica:**
   $$\hat{\boldsymbol{\beta}} \sim \mathcal{N}_{p+1}\left(\boldsymbol{\beta},\,
   \mathbf{I}(\boldsymbol{\beta})^{-1}\right)$$
   onde $\mathbf{I}(\boldsymbol{\beta}) = -\mathbb{E}[\mathbf{H}(\boldsymbol{\beta})]$
   é a **matriz de informação de Fisher** — base de todos os intervalos
   e testes dos próximos capítulos;
3. **Eficiência:** atinge o limite inferior de Cramér-Rao — ninguém
   estima com menos variância com os mesmos dados.

A matriz de covariância estimada:

$$\widehat{\text{Cov}}(\hat{\boldsymbol{\beta}}) = \left(\mathbf{X}^\top \widehat{\mathbf{W}} \mathbf{X}\right)^{-1}$$

cujos elementos diagonais fornecem $\widehat{\text{Var}}(\hat{\beta}_j)$,
usados nos testes de Wald (Capítulo 5).

---

## 🧪 Teste seu radar (respostas no fim)

1. Por que a logística não tem fórmula fechada como o MQO?
2. No exemplo do café, por que $\hat{p} = 0{,}7$ e não $0{,}6$?
3. O que o IRLS faz a cada iteração?

**Respostas:** 1) O sistema de equações é **não linear** — resolvido por
iteração numérica. 2) Porque 7 de 10 pessoas gostam — a MV "aprende" a
proporção amostral. 3) Resolve um mínimos quadrados ponderado com pesos
$\pi_i(1-\pi_i)$ e atualiza $\boldsymbol{\beta}$ até convergir.

---

## ✅ Para levar

- A MV escolhe o $\boldsymbol{\beta}$ que torna os dados observados os
  mais prováveis possíveis.
- $\ell(\boldsymbol{\beta})$ é a versão logaritmada e gerenciável da
  verossimilhança.
- Sem solução fechada → **iteração**: Newton-Raphson (IRLS) resolve uma
  sequência de mínimos quadrados ponderados.
- Estimadores de MV: consistentes, assintoticamente normais e
  eficientes — tudo o que os testes precisam.

---
**Anterior:** [2. Modelo Logístico](./02_modelo_logistico.md) |
**Próximo:** [4. Avaliação do Modelo](./04_avaliacao.md)