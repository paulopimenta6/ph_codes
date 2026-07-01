# 2. O Modelo Logístico

## 2.1 A Função Sigmoide

A equação central do modelo é a **função sigmoide logística**:

$$\pi(\mathbf{x}) = P(Y = 1 \mid \mathbf{x}) = \frac{1}{1 + e^{-z}}, \quad z = \beta_0 + \beta_1 x_1 + \cdots + \beta_p x_p$$

| Símbolo | Nome | Descrição |
|:---:|:---|:---|
| $x_1,\ldots,x_p$ | Variáveis preditoras | Características observadas |
| $\beta_0$ | Intercepto | Log-odds quando todas as $x_j = 0$ |
| $\beta_1,\ldots,\beta_p$ | Coeficientes de regressão | Parâmetros a estimar |
| $z$ | Logit (log-odds) | Combinação linear das preditoras |
| $\pi(\mathbf{x})$ | Probabilidade condicional | $P(Y=1 \mid \mathbf{x}) \in (0,1)$ |

### Propriedades da Sigmoide

-   **Domínio e imagem:** $\sigma: \mathbb{R} \to (0,1)$
-   **Monotonicidade:** estritamente crescente
-   **Ponto de inflexão:** $\sigma(0) = 0{,}5$
-   **Simetria:** $\sigma(-z) = 1 - \sigma(z)$
-   **Derivada:** $\sigma'(z) = \sigma(z)(1 - \sigma(z))$ — propriedade
    computacionalmente importante para estimação

### Forma Alternativa

$$\sigma(z) = \frac{e^z}{1 + e^z} = \frac{1}{1 + e^{-z}}$$

## 2.2 A Transformação Logit

Invertendo a sigmoide, obtemos o **logit** (ou log-odds):

$$\text{logit}(\pi) = \ln\left(\frac{\pi}{1-\pi}\right) = z = \beta_0 + \beta_1 x_1 + \cdots + \beta_p x_p$$

O termo $\dfrac{\pi}{1-\pi}$ são os **odds** (razão de chances):

$$\text{Odds} = \frac{P(\text{evento})}{P(\text{não-evento})} = \frac{\pi}{1-\pi}$$

**Exemplo:** Se $\pi = 0{,}75$, então $\text{Odds} = 0{,}75/0{,}25 = 3$ — as
chances são "3 para 1" a favor do evento.

A transformação logit **lineariza** a relação entre as preditoras e os
log-odds, base da interpretação dos coeficientes.

## 2.3 Interpretação dos Coeficientes — Odds Ratio

### Odds Ratio (OR)

Quando aumentamos $x_j$ em **1 unidade**, mantendo as demais variáveis
constantes, os odds se multiplicam por:

$$OR_j = e^{\beta_j}$$

| Situação | Efeito nos Odds |
|:---|:---|
| $\beta_j > 0 \Rightarrow OR_j > 1$ | Aumento de 1 unidade em $x_j$ **multiplica** os odds por $e^{\beta_j}$ (aumento percentual: $(e^{\beta_j} - 1) \times 100\%$) |
| $\beta_j < 0 \Rightarrow OR_j < 1$ | Aumento de 1 unidade em $x_j$ **reduz** os odds por fator $e^{\beta_j}$ (redução percentual: $(1 - e^{\beta_j}) \times 100\%$) |
| $\beta_j = 0 \Rightarrow OR_j = 1$ | Sem efeito nos odds |

**Exemplo numérico:** Se $\beta_1 = 2{,}44$ e $\beta_2 = -0{,}92$:
- $OR_1 = e^{2{,}44} \approx 11{,}47$ — aumento de 1 unidade em $x_1$
  eleva os odds em **1047%**
- $OR_2 = e^{-0{,}92} \approx 0{,}40$ — aumento de 1 unidade em $x_2$
  reduz os odds em **60%**

### Variação em Múltiplas Unidades

Para um aumento de $\Delta$ unidades em $x_j$:

$$OR_j(\Delta) = e^{\beta_j \cdot \Delta}$$

**Exemplo:** $\beta_1 = 0{,}15$, $\Delta = 5$:

$$OR_1(5) = e^{0{,}15 \times 5} = e^{0{,}75} \approx 2{,}12$$

Os odds aumentam em **112%**.

### Intervalo de Confiança para OR

O intervalo de $100(1-\alpha)\%$ confiança para o OR é:

$$IC(OR_j) = \exp\left(\hat{\beta}_j \pm z_{\alpha/2} \cdot SE(\hat{\beta}_j)\right)$$

Se o IC **não contiver 1**, rejeita-se $H_0: \beta_j = 0$ ao nível
$\alpha$.

## 2.4 Efeitos Marginais

Para **análise**, uma interpretação mais intuitiva que o OR é o **efeito
marginal**: a variação em $P(Y=1)$ decorrente de uma variação unitária
em $x_j$.

### Efeito Marginal (EM)

Derivando $\pi(\mathbf{x})$ em relação a $x_j$:

$$\frac{\partial \pi(\mathbf{x})}{\partial x_j} = \pi(\mathbf{x})(1 - \pi(\mathbf{x})) \cdot \beta_j$$

Interpretação: a mudança na **probabilidade** do evento para um aumento
de 1 unidade em $x_j$ depende do nível de $\pi(\mathbf{x})$ — o efeito é
**máximo** quando $\pi = 0{,}5$ e **mínimo** próximo de 0 ou 1.

### Efeito Marginal na Média (MEM)

Avalia o EM no ponto médio das preditoras:

$$MEM_j = \bar{\pi}(1 - \bar{\pi}) \cdot \beta_j, \quad \bar{\pi} = \frac{1}{n}\sum_{i=1}^n \pi(\mathbf{x}_i)$$

### Efeito Marginal Médio (AME)

Média dos efeitos marginais individuais:

$$AME_j = \frac{1}{n}\sum_{i=1}^n \pi(\mathbf{x}_i)(1 - \pi(\mathbf{x}_i)) \cdot \beta_j$$

**Exemplo comparativo:** Para $\beta_j = 1{,}5$:

| $\pi$ | EM($x_j$) | Interpretação |
|:---:|:---:|:---|
| 0,10 | 0,135 | Aumento de 1 un. eleva $P(Y=1)$ em 13,5 pp |
| 0,50 | 0,375 | Efeito máximo: 37,5 pp |
| 0,90 | 0,135 | Idem a $\pi=0{,}10$ pela simetria |

> O OR é constante ($e^{\beta_j}$), mas o efeito na **probabilidade**
> varia com o nível de $\pi$ — daí a importância dos efeitos marginais
> na análise substantiva.

## 2.5 Comparação: OR vs. Efeito Marginal

| Medida | Escala | Constante? | Uso |
|:---|:---:|:---:|:---|
| Odds Ratio | odds | Sim | Quantificação do efeito, comunicação clínica |
| Efeito Marginal | probabilidade (pp) | Não | Interpretação substantiva, ciências sociais |
| Log-odds ($\beta$) | log-odds | Sim | Inferência estatística, testes |

---

**Anterior:** [1. Introdução](./01_introducao.md) |
**Próximo:** [3. Estimação por Máxima Verossimilhança](./03_estimacao.md)
