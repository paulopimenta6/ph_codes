# 4. Avaliação do Modelo — o Boletim Escolar do Modelo 📊

> **Continuando o caso:** o Seu Bento ajustou o modelo. Mas... ele é
> bom? Como comparar com um modelo rival? Este capítulo é o "boletim":
> notas de ajuste (pseudo-R²), custos escondidos (AIC/BIC), teste de
> comportamento (Hosmer-Lemeshow) e a "inspeção visual" (resíduos).

Na regressão logística **não existe o $R^2$ tradicional** (não há
decomposição de soma de quadrados). A avaliação é feita por medidas de
**qualidade do ajuste**, **critérios de informação** e **diagnóstico**.

🎯 **Neste capítulo:**

- **pseudo-R² de McFadden** — a nota do boletim;
- **deviance** — o "quanto falta ajustar";
- **AIC e BIC** — comparar modelos pagando imposto por complexidade;
- métricas de classificação (uso auxiliar) e curva ROC/AUC;
- **Hosmer-Lemeshow** e **resíduos** — o raio-x do modelo.

---

## 4.1 Pseudo-R² de McFadden

### Definição

O **pseudo-R² de McFadden** (1974) compara a log-verossimilhança do
modelo ajustado com a do modelo nulo (apenas intercepto — "todo mundo
recebe a mesma chance"):

$$R^2_{\text{McF}} = 1 - \frac{\ell(\hat{\boldsymbol{\beta}})}{\ell_0}$$

| Símbolo | Definição |
|:---:|:---|
| $\ell(\hat{\boldsymbol{\beta}})$ | Log-verossimilhança do modelo completo |
| $\ell_0$ | Log-verossimilhança do modelo nulo ($\beta_1 = \cdots = \beta_p = 0$) |

### Log-Verossimilhança do Modelo Nulo

O modelo nulo prevê $\hat{p} = N_1/N$ para todas as observações, onde
$N_1$ é o número de sucessos e $N = N_0 + N_1$:

$$\ell_0 = N_1 \ln\left(\frac{N_1}{N}\right) + N_0 \ln\left(\frac{N_0}{N}\right)$$

Ou equivalentemente:

$$\ell_0 = N_1 \ln N_1 + N_0 \ln N_0 - N \ln N$$

### Interpretação

Como $\ell(\hat{\boldsymbol{\beta}}) \geq \ell_0$ (ambos $\leq 0$ —
lembre-se do Capítulo 3), temos $0 \leq R^2_{\text{McF}} \leq 1$.

| Valor | Interpretação |
|:---:|:---|
| $< 0{,}20$ | Ajuste fraco |
| $0{,}20 - 0{,}40$ | Bom ajuste |
| $> 0{,}40$ | Ajuste muito bom |

> ⚠️ **Atenção:** na logística, o pseudo-R² costuma ser bem mais baixo
> que o $R^2$ linear. Um $R^2_{\text{McF}} \approx 0{,}4$ é excelente
> (equivale aproximadamente a um $R^2 \approx 0{,}9$ da regressão
> linear — heurística didática, não teorema).

### Exemplo Numérico

$N_1 = 60$, $N_0 = 40$, $N = 100$, $\ell(\hat{\boldsymbol{\beta}}) = -50{,}0$:

$$\ell_0 = 60\ln(0{,}6) + 40\ln(0{,}4) \approx -67{,}3$$

$$R^2_{\text{McF}} = 1 - \frac{-50{,}0}{-67{,}3} = 1 - 0{,}743 = 0{,}257$$

O modelo reduz **25,7%** do "sofrimento" do modelo nulo.

> 🚩 **Erro comum:** a fórmula **incorreta** $-\ell(\hat{\boldsymbol{\beta}})/\ell_0$
> produz sinal e magnitude errados. A correta é
> $1 - \ell(\hat{\boldsymbol{\beta}})/\ell_0$.

---

## 4.2 Deviance 🔥

A **deviance** é uma medida de falta de ajuste, análoga à soma de
quadrados residual na regressão linear:

$$D = -2\left[\ell(\hat{\boldsymbol{\beta}}) - \ell_{\text{saturado}}\right]$$

onde $\ell_{\text{saturado}}$ é a log-verossimilhança do modelo
saturado (um parâmetro por observação — "cada cliente tem sua própria
teoria").

> 💡 **Sacada:** para dados binários não agrupados, o modelo saturado
> ajusta perfeitamente ($\ell_{\text{saturado}} = 0$). Por isso:

- **Deviance nula:** $D_0 = -2\ell_0$ (modelo com apenas intercepto)
- **Deviance residual:** $D = -2\ell(\hat{\boldsymbol{\beta}})$

A redução de deviance é:

$$\Delta D = D_0 - D = 2\left[\ell(\hat{\boldsymbol{\beta}}) - \ell_0\right] = G$$

...que é exatamente a estatística do **TRV** do próximo capítulo. Tudo
se conecta.

---

## 4.3 Critérios de Informação 💰

Para **comparar modelos** (mesmo não aninhados), com penalização por
complexidade:

### AIC (Akaike Information Criterion)

$$\text{AIC} = -2\ell(\hat{\boldsymbol{\beta}}) + 2k$$

onde $k = p + 1$ (número de parâmetros). **Menor AIC** indica melhor
modelo. A penalização $2k$ é o "imposto" por cada parâmetro extra.

### BIC (Bayesian Information Criterion)

$$\text{BIC} = -2\ell(\hat{\boldsymbol{\beta}}) + k\ln n$$

Penaliza a complexidade **mais fortemente** que o AIC (cresce com o
tamanho da amostra). **Menor BIC** preferível.

> ⚠️ **Cilada:** AIC e BIC só servem para **comparar modelos ajustados
> aos mesmos dados**. Não são notas absolutas — um AIC = 300 nada diz
> sozinho.

## 4.4 Medidas de Classificação (Uso Auxiliar) 🎯

Embora o foco deste tutorial seja **análise**, métricas de classificação
auxiliam na compreensão do modelo.

### Matriz de Confusão

Para um limiar $\tau$ (geralmente $\tau = 0{,}5$):

$$\hat{y}_i = \begin{cases} 1 & \text{se } \hat{\pi}_i \geq \tau \\ 0 & \text{caso contrário} \end{cases}$$

| | Predito: 0 | Predito: 1 |
|:---|:---:|:---:|
| **Real: 0** | VN (Verdadeiro Negativo) | FP (Falso Positivo) |
| **Real: 1** | FN (Falso Negativo) | VP (Verdadeiro Positivo) |

**Métricas derivadas (informam, mas não decidem a análise):**

| Métrica | Fórmula | Pergunta |
|:---|:---|:---|
| Sensibilidade | $\text{VP}/(\text{VP}+\text{FN})$ | Qual fração dos eventos foi corretamente identificada? |
| Especificidade | $\text{VN}/(\text{VN}+\text{FP})$ | Qual fração dos não-eventos foi corretamente identificada? |
| Precisão | $\text{VP}/(\text{VP}+\text{FP})$ | Dentre os preditos como evento, quantos realmente são? |

### Curva ROC e AUC

A **curva ROC** (*Receiver Operating Characteristic*) plota Sensibilidade
vs. 1 − Especificidade para todos os $\tau \in [0,1]$.

A **AUC** resume o poder discriminante do modelo:

| AUC | Interpretação |
|:---:|:---|
| $0{,}5$ | Sem poder discriminante (aleatório — cara ou coroa) |
| $0{,}70 - 0{,}80$ | Discriminação aceitável |
| $0{,}80 - 0{,}90$ | Boa discriminação |
| $> 0{,}90$ | Excelente discriminação |

AUC $= P(\hat{\pi}_1 > \hat{\pi}_0)$: probabilidade de que, dado um par
aleatório (positivo, negativo), o modelo atribua maior probabilidade ao
positivo. É a "goleira": quanto mais longe de 0,5, melhor o pega-pega.

---

## 4.5 Teste de Hosmer-Lemeshow 🧤

Avalia a **qualidade do ajuste** (*goodness-of-fit*): as frequências
observadas batem com as esperadas em grupos de risco?

**Procedimento:**

1. As observações são ordenadas por $\hat{\pi}_i$ e divididas em $g = 10$
   grupos (decis) de aproximadamente igual tamanho.
2. Em cada grupo, calcula-se:
   - $O_{1k}$: número observado de eventos
   - $E_{1k}$: soma das probabilidades estimadas ($\sum \hat{\pi}_i$)
   - $O_{0k}$: número observado de não-eventos
   - $E_{0k}$: soma de $1 - \hat{\pi}_i$
3. Estatística:
   $$\hat{C} = \sum_{k=1}^g \frac{(O_{1k} - E_{1k})^2}{E_{1k}} + \frac{(O_{0k} - E_{0k})^2}{E_{0k}}$$
   $$\hat{C} \stackrel{H_0}{\sim} \chi^2_{(g-2)}$$

**Hipóteses:**
- $H_0$: modelo ajusta-se adequadamente aos dados
- $H_1$: modelo não se ajusta adequadamente

Valor-p $< 0{,}05$ indica falta de ajuste (modelo mal especificado).

> ⚠️ **Limitação:** o teste H-L é sensível ao número de grupos e pode ter
> baixo poder para certos tipos de falta de ajuste. É ferramenta
> **diagnóstica complementar** — não um oráculo.

---

## 4.6 Análise de Resíduos 🔬

### Resíduo de Pearson

$$r_i = \frac{y_i - \hat{\pi}_i}{\sqrt{\hat{\pi}_i(1 - \hat{\pi}_i)}}$$

### Resíduo Deviance

$$d_i = \text{sinal}(y_i - \hat{\pi}_i) \sqrt{-2\left[y_i\ln\hat{\pi}_i + (1-y_i)\ln(1-\hat{\pi}_i)\right]}$$

### Resíduo Studentizado (Pearson ajustado)

$$r_{si} = \frac{r_i}{\sqrt{1 - h_{ii}}}$$

onde $h_{ii}$ é o *leverage* (elemento diagonal da matriz de chapéu
generalizada — "quanto cada ponto segura a régua do modelo"). Valores
$|r_{si}| > 2$ merecem investigação.

> 🖥️ **Nos scripts (Capítulo 6):** o diagnóstico reporta os três
> resíduos (Pearson, deviance e o studentizado acima) com a *proporção*
> de pontos além de $|r| > 2$ — procure **padrões**, não perfeição.

> 💡 **Sacada:** na logística os resíduos têm só dois valores possíveis
> por ponto — procure **padrões** (desequilíbrio claro, grupos de
> outliers), não histogramas de normalidade.

---

## 4.7 Comparação com Regressão Linear

| Aspecto | Regressão Linear | Regressão Logística |
|:---|:---:|:---:|
| Variável resposta | Contínua ($\mathbb{R}$) | Binária $\{0,1\}$ |
| Predições | $\mathbb{R}$ | $(0,1)$ (probabilidade) |
| Distribuição condicional | Normal | Bernoulli |
| Variância | $\sigma^2$ (constante) | $\pi_i(1-\pi_i)$ (variável) |
| Função de ligação | Identidade | Logit |
| Estimação | MQO (analítico) | MV (iterativo) |
| $R^2$ | Proporção da variância explicada | Pseudo-R² (McFadden) |
| Critério de ajuste | $R^2$, $F$-test | Deviance, AIC, BIC, TRV |
| Resíduos | Normalidade assumida | Análise via deviance/Pearson |
| Teste de ajuste | $F$-test | Hosmer-Lemeshow, TRV |

---

## 🧪 Teste seu radar (respostas no fim)

1. McFadden 0,30: o ajuste é fraco, bom ou muito bom?
2. AIC e BIC são comparáveis entre conjuntos de dados diferentes?
3. Qual é a hipótese nula do teste de Hosmer-Lemeshow?

**Respostas:** 1) **Bom** (0,20–0,40). 2) **Não** — só entre modelos
ajustados aos mesmos dados. 3) $H_0$: o modelo se ajusta adequadamente —
valor-p baixo indica falta de ajuste.

---

## ✅ Para levar

- Sem $R^2$ clássico: use **pseudo-R² de McFadden** (compare com o nulo).
- **Deviance** mede a falta de ajuste; AIC/BIC comparam modelos pagando
  imposto por parâmetro.
- H-L e resíduos são o **diagnóstico**: procure padrões, não perfeição.
- ROC/AUC são coadjuvantes — o veredito da análise vem dos testes do
  próximo capítulo.

---
**Anterior:** [3. Estimação](./03_estimacao.md) |
**Próximo:** [5. Testes de Hipóteses](./05_testes.md)