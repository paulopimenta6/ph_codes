# 2. O Modelo Logístico — a Porta que Abre Devagar 🚪

> **Continuando o caso:** o Seu Bento notou que a chance de ganhar o
> vale-café parece "acelerar" com a idade. Mas idades não entram numa
> reta... Algo precisa **dobrar os odds** em vez de somar. Bem-vindo à
> sigmoide.

A regressão logística tem uma peça central: uma função que "encurva" a
linha reta para dentro do intervalo $(0,1)$. É a **sigmoide logística** —
a porta que vai abrindo conforme a força $z$ cresce, mas nunca sai do
lugar ($0$ ou $1$).

🎯 **Neste capítulo:**

- a **sigmoide** e suas propriedades (a porta que abre devagar);
- o **logit** e a mágica dos **odds** (a "aposta" do Seu Bento);
- interpretar coeficientes como **Odds Ratio**, com exemplos;
- **efeitos marginais**: a mesma porta, vista de perto.

---

## 2.1 A Função Sigmoide

A equação central do modelo:

$$\pi(\mathbf{x}) = P(Y = 1 \mid \mathbf{x}) = \frac{1}{1 + e^{-z}}, \quad z = \beta_0 + \beta_1 x_1 + \cdots + \beta_p x_p$$

| Símbolo | Nome | Descrição |
|:---:|:---|:---|
| $x_1,\ldots,x_p$ | Variáveis preditoras | Características observadas (idade, consumo...) |
| $\beta_0$ | Intercepto | Log-odds quando todas as $x_j = 0$ |
| $\beta_1,\ldots,\beta_p$ | Coeficientes de regressão | Parâmetros a estimar |
| $z$ | Logit (log-odds) | Combinação linear das preditoras |
| $\pi(\mathbf{x})$ | Probabilidade condicional | $P(Y=1 \mid \mathbf{x}) \in (0,1)$ |

### Propriedades da Sigmoide 🎈

- **Domínio e imagem:** $\sigma: \mathbb{R} \to (0,1)$ — nunca sai do
  intervalo, por maior que seja a "força" $z$.
- **Monotonicidade:** estritamente crescente — $z$ maior, chance maior.
- **Ponto de inflexão:** $\sigma(0) = 0{,}5$ — ali a porta se move mais
  depressa.
- **Simetria:** $\sigma(-z) = 1 - \sigma(z)$ — o espelho do evento é o
  não-evento.
- **Derivada:** $\sigma'(z) = \sigma(z)(1 - \sigma(z))$ — propriedade
  ouro para a estimação (Capítulo 3).

### Forma Alternativa

$$\sigma(z) = \frac{e^z}{1 + e^z} = \frac{1}{1 + e^{-z}}$$

💡 **Sacada:** a sigmoide comprime $z \in (-\infty, \infty)$ dentro de
$(0,1)$. A reta do Seu Bento não "vaza" mais para $1{,}4$.

---

## 2.2 A Transformação Logit 🔄

Invertendo a sigmoide, obtemos o **logit** (ou log-odds):

$$\text{logit}(\pi) = \ln\left(\frac{\pi}{1-\pi}\right) = z = \beta_0 + \beta_1 x_1 + \cdots + \beta_p x_p$$

O termo $\dfrac{\pi}{1-\pi}$ são os **odds** (razão de chances) — a
"aposta":

$$\text{Odds} = \frac{P(\text{evento})}{P(\text{não-evento})} = \frac{\pi}{1-\pi}$$

**Exemplo:** Se $\pi = 0{,}75$, então $\text{Odds} = 0{,}75/0{,}25 = 3$ —
as chances são "3 para 1" a favor do evento. Seu Bento diria: "para cada
3 clientes sorteados, 1 não é".

⚠️ **Cilada:** **odds não é probabilidade.** Odds 3 ≠ probabilidade 3.
Odds variam de $0$ a $\infty$; probabilidade, de $0$ a $1$.

A transformação logit **lineariza** a relação entre preditoras e
log-odds — é nessa escala que os coeficientes "moram". Por isso eles
**somam** no logit $z$, mas **multiplicam** os odds.

---

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

**Exemplo numérico:** se $\beta_1 = 2{,}44$ e $\beta_2 = -0{,}92$:
- $OR_1 = e^{2{,}44} \approx 11{,}47$ — aumento de 1 unidade em $x_1$
  eleva os odds em **1047%**
- $OR_2 = e^{-0{,}92} \approx 0{,}40$ — aumento de 1 unidade em $x_2$
  reduz os odds em **60%**

💡 **Sacada:** $OR = 1$ é o "ponto de equilíbrio" (sem efeito). Quanto
mais longe de 1, maior o efeito — para cima aumenta, para baixo reduz.

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
$\alpha$. É a "rede de segurança" da estimativa: ela reporta o erro
junto com o efeito.

---

## 2.4 Efeitos Marginais 📏

Para **análise**, uma interpretação mais intuitiva que o OR é o **efeito
marginal**: a variação em $P(Y=1)$ decorrente de uma variação unitária
em $x_j$.

### Efeito Marginal (EM)

Derivando $\pi(\mathbf{x})$ em relação a $x_j$:

$$\frac{\partial \pi(\mathbf{x})}{\partial x_j} = \pi(\mathbf{x})(1 - \pi(\mathbf{x})) \cdot \beta_j$$

A mudança na **probabilidade** do evento para um aumento de 1 unidade em
$x_j$ depende do nível de $\pi(\mathbf{x})$: o efeito é **máximo** quando
$\pi = 0{,}5$ e **mínimo** perto de 0 ou 1. (A porta se move mais no
meio do caminho!)

### Efeito Marginal na Média (MEM)

O MEM avalia o efeito marginal **no ponto médio das preditoras**
$\bar{\mathbf{x}}$ (vetor com as médias de $x_1, \ldots, x_p$):

$$MEM_j = \pi(\bar{\mathbf{x}})\big(1 - \pi(\bar{\mathbf{x}})\big) \cdot \beta_j, \quad \pi(\bar{\mathbf{x}}) = \frac{1}{1 + e^{-\bar{\mathbf{x}}^\top\boldsymbol{\beta}}}$$

> ⚠️ **Cilada (correção de versões antigas):** o MEM **não** é
> $\bar{\pi}(1-\bar{\pi})\beta_j$ com $\bar{\pi}$ a média das
> probabilidades previstas (isso é outra coisa — e misturar as duas
> definições gera resultados diferentes). Calcule $\pi$ apenas na média
> das variáveis.

### Efeito Marginal Médio (AME)

Média dos efeitos marginais individuais (cada observação "vota"):

$$AME_j = \frac{1}{n}\sum_{i=1}^n \pi(\mathbf{x}_i)(1 - \pi(\mathbf{x}_i)) \cdot \beta_j$$

> 🖥️ **Nos scripts (Capítulo 6):** os scripts R e Python reportam o AME
> **e** o MEM lado a lado — compare como as duas medidas respondem quando
> você muda o DGP nos experimentos.

**Exemplo comparativo:** para $\beta_j = 1{,}5$:

| $\pi$ | EM($x_j$) | Interpretação |
|:---:|:---:|:---|
| 0,10 | 0,135 | Aumento de 1 un. eleva $P(Y=1)$ em 13,5 pp |
| 0,50 | 0,375 | Efeito máximo: 37,5 pp |
| 0,90 | 0,135 | Idem a $\pi=0{,}10$ pela simetria |

> O OR é constante ($e^{\beta_j}$), mas o efeito na **probabilidade**
> varia com o nível de $\pi$ — daí a importância dos efeitos marginais
> na análise substantiva. (pp = pontos percentuais, não %.)

---

## 2.5 Comparação: OR vs. Efeito Marginal

| Medida | Escala | Constante? | Uso |
|:---|:---:|:---:|:---|
| Odds Ratio | odds | Sim | Quantificação do efeito, comunicação clínica |
| Efeito Marginal | probabilidade (pp) | Não | Interpretação substantiva, ciências sociais |
| Log-odds ($\beta$) | log-odds | Sim | Inferência estatística, testes |

---

## 🧪 Teste seu radar (respostas no fim)

1. Se $\beta = 0$, qual o OR e o que ele significa?
2. $\pi = 0{,}8$: qual o valor dos odds?
3. Onde o efeito marginal na probabilidade atinge o máximo?

**Respostas:** 1) $OR = e^0 = 1$ — sem efeito. 2) $0{,}8/0{,}2 = 4$ —
"4 contra 1". 3) Em $\pi = 0{,}5$.

---

## ✅ Para levar

- A sigmoide vive em $(0,1)$ e abre mais rápido no meio.
- Os coeficientes **somam** no logit, mas **multiplicam** os odds:
  $OR = e^{\beta}$.
- O efeito na *probabilidade* depende de onde você está na curva — por
  isso usamos efeitos marginais (MEM na média das variáveis; AME na
  média das observações).

---
**Anterior:** [1. Introdução](./01_introducao.md) |
**Próximo:** [3. Estimação por Máxima Verossimilhança](./03_estimacao.md)