# 2. O Modelo Logístico

## 2.1 A Função Sigmoide

A equação central do modelo de regressão logística binária é a **função sigmoide logística**:

$$\hat{y} = P(Y = 1 \mid \mathbf{x}) = \frac{1}{1 + e^{-z}}, \quad z = a_1 x_1 + a_2 x_2 + \cdots + a_p x_p + b$$

onde:

| Símbolo | Nome | Descrição |
|:---:|:---|:---|
| $x_1, \ldots, x_p$ | Variáveis preditoras | Características observadas |
| $a_1, \ldots, a_p$ | Coeficientes de regressão | Parâmetros estimados pelo modelo |
| $b$ | Intercepto | Parâmetro constante (viés) |
| $z$ | Log-odds (logit) | Combinação linear das preditoras |
| $\hat{y}$ | Probabilidade predita | $P(Y=1 \mid \mathbf{x}) \in (0,1)$ |

### Propriedade Fundamental

Independentemente do valor de $z$, sempre temos:
$$0 < \hat{y} < 1$$

O modelo **nunca produz uma probabilidade inválida**, ao contrário da regressão linear ordinária que pode gerar valores fora de $[0,1]$.

### Forma Alternativa

A função sigmoide pode ser reescrita como:
$$\sigma(z) = \frac{e^z}{1 + e^z} = \frac{1}{1 + e^{-z}}$$

E sua inversa — a **transformação logit** — é:
$$\text{logit}(\hat{y}) = \log_e\left(\frac{\hat{y}}{1-\hat{y}}\right) = z$$

---

## 2.2 A Transformação Logit e os Odds

### O Conceito de Odds (Razão de Chances)

Invertendo a função sigmoide:
$$\log_e\!\left(\frac{p}{1-p}\right) = z = a_1 x_1 + \cdots + a_p x_p + b$$

O termo $\dfrac{p}{1-p}$ é a **razão de chances** (*odds*):

$$\text{Odds} = \frac{P(\text{evento ocorre})}{P(\text{evento não ocorre})} = \frac{p}{1-p}$$

**Exemplo numérico:** Se a probabilidade de sucesso é $p = 0{,}75$, então:
$$\text{Odds} = \frac{0{,}75}{0{,}25} = 3$$

Interpretação: as chances são "3 para 1" a favor do evento.

### Linearidade na Escala Logit

A transformação logit **lineariza a relação** entre as preditoras e os odds do evento:

$$\log_e(\text{Odds}) = z = a_1 x_1 + \cdots + a_p x_p + b$$

Esta é a base para interpretar os coeficientes!

---

## 2.3 Interpretação dos Coeficientes via Odds Ratio

### Odds Ratio (OR)

Quando aumentamos uma variável preditora $x_i$ em **1 unidade**, os odds se multiplicam por:

$$OR_i = e^{a_i}$$

### Tabela de Interpretações

| Situação | Interpretação |
|:---|:---|
| $a_i > 0$ $\Rightarrow$ $OR_i > 1$ | Aumento de 1 unidade em $x_i$ **multiplica** os odds por $e^{a_i}$ |
| $a_i < 0$ $\Rightarrow$ $OR_i < 1$ | Aumento de 1 unidade em $x_i$ **reduz** os odds por fator $e^{a_i}$ |
| $a_i = 0$ $\Rightarrow$ $OR_i = 1$ | $x_i$ não tem efeito sobre os odds do evento |

### Exemplo Numérico

Se $a_1 = 2{,}44$, então:
$$OR_1 = e^{2{,}44} \approx 11{,}47$$

**Interpretação:** Um aumento de 1 unidade em $x_1$ eleva os odds do evento em **1047%** (ou multiplica os odds por ~11,5), mantidas as demais variáveis constantes.

### Variação em Múltiplas Unidades

Se queremos saber o efeito de um aumento de $\Delta x_i$ unidades:

$$OR(\Delta x_i) = e^{a_i \cdot \Delta x_i}$$

**Exemplo:** Se $a_1 = 0{,}15$ e aumentamos $x_1$ em 5 unidades:
$$OR(5) = e^{0{,}15 \times 5} = e^{0{,}75} \approx 2{,}12$$

Os odds aumentam em ~112%.

---

## 2.4 Visão Gráfica da Sigmoide

A curva sigmoide tem as seguintes características:

- **Forma de S:** passa monotonicamente de 0 a 1
- **Ponto de inflexão:** em $z = 0$ (onde $\hat{y} = 0{,}5$)
- **Simetria:** $\sigma(z) + \sigma(-z) = 1$
- **Limites assintóticos:** $\lim_{z \to \infty} \sigma(z) = 1$ e $\lim_{z \to -\infty} \sigma(z) = 0$

---

**Próximo:** [3. Estimação por Máxima Verossimilhança](./03_estimacao.md)
