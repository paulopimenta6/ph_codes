# 3. Estimação por Máxima Verossimilhança

## 3.1 O Princípio

A **Máxima Verossimilhança** (MV) encontra os valores de $\mathbf{a}$ e $b$ que **maximizam a probabilidade de se observar exatamente os dados coletados**, dada a estrutura do modelo.

## 3.2 A Função de Verossimilhança

Para $n$ observações independentes, com $y_i \in \{0,1\}$, cada observação segue uma distribuição de Bernoulli com parâmetro $\hat{y}_i$. A verossimilhança conjunta é:

$$\mathcal{L}(\mathbf{a}, b) = \prod_{i=1}^{n} \hat{y}_i^{\;y_i} \cdot (1 - \hat{y}_i)^{1-y_i}$$

Cada fator contribui com:
- $\hat{y}_i$ quando $y_i = 1$ (probabilidade prevista de sucesso)
- $(1 - \hat{y}_i)$ quando $y_i = 0$ (probabilidade prevista de fracasso)

## 3.3 A Log-Verossimilhança

Para evitar *underflow* numérico e transformar o produto em soma, maximiza-se o logaritmo natural:

$$L(\mathbf{a}, b) = \sum_{i=1}^{n}\left[\, y_i \log_e(\hat{y}_i) + (1-y_i)\log_e(1-\hat{y}_i) \,\right]$$

**Propriedades:**

- $L \leq 0$ sempre, pois $\log_e(\hat{y}_i) \leq 0$ para $\hat{y}_i \in (0,1)$
- $L = 0$ somente quando o modelo classifica perfeitamente todos os pontos
- Maximizar $L$ equivale a minimizar a **entropia cruzada binária**, função de perda usada em redes neurais para classificação binária

## 3.4 Exemplo: Preferência por Café

Pesquisa com 10 pessoas: 7 responderam "Sim" e 3 "Não". Estimar $p$ (proporção que gosta de café).

**Verossimilhança:** $\mathcal{L}(p) = p^7 \cdot (1-p)^3$

**Log-verossimilhança:** $L(p) = 7\log_e(p) + 3\log_e(1-p)$

**Condição de 1ª ordem:**
$$\frac{dL}{dp} = \frac{7}{p} - \frac{3}{1-p} = 0 \implies \hat{p} = \frac{7}{10} = 0.7$$

**Verificação de máximo:** $\frac{d^2L}{dp^2} = -\frac{7}{p^2} - \frac{3}{(1-p)^2} < 0$ ✓

Logo, $\hat{p} = 0.7$ é o **máximo global**.

## 3.5 Modelo Geral com Preditoras

Substituindo $\hat{y}_i = \sigma(z_i)$:

$$L(\mathbf{a}, b) = \sum_{i=1}^{n} \left[\, y_i \log_e\!\left(\frac{1}{1+e^{-z_i}}\right) + (1-y_i)\log_e\!\left(\frac{e^{-z_i}}{1+e^{-z_i}}\right) \,\right]$$

**Não existe solução analítica fechada.** Os coeficientes são estimados por algoritmos iterativos:

| Algoritmo | Descrição | Implementação |
|:----------|:----------|:--------------|
| Newton-Raphson (IRLS) | Usa gradiente e hessiana exata; converge rapidamente | `glm()` no R |
| BFGS / L-BFGS | Aproxima a hessiana; eficiente para muitas variáveis | `statsmodels`, `sklearn` |
| Gradiente Descendente | Atualização por mini-batch; escalável a Big Data | Redes neurais, TensorFlow |

---

**Anterior:** [2. Modelo Logístico](./02_modelo_logistico.md) | **Próximo:** [4. Avaliação](./04_avaliacao.md)
