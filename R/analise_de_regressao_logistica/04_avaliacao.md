# 4. Avaliação do Modelo

## 4.1 Pseudo-R² de McFadden

Na regressão logística **não existe um $R^2$** com interpretação geométrica direta (não há soma de quadrados). A medida mais usada é o **pseudo-$R^2$ de McFadden** (McFadden, 1974):

### Fórmula Correta

$$R^2_{\text{McFadden}} = 1 - \frac{\ln L^*}{\ln L_0}$$

onde:

| Símbolo | Definição |
|:---:|:---|
| $\ln L^*$ | Log-verossimilhança máxima do modelo ajustado (com preditoras) |
| $\ln L_0$ | Log-verossimilhança do modelo nulo (apenas intercepto) |

### Cálculo do Modelo Nulo

Em regressão logística binária, o modelo nulo prevê a mesma probabilidade para todos:

$$\hat{p} = \frac{N_1}{N}$$

Sua log-verossimilhança é:

$$\ln L_0 = N_1 \ln\!\left(\frac{N_1}{N}\right) + N_0 \ln\!\left(\frac{N_0}{N}\right) = N_1 \ln N_1 + N_0 \ln N_0 - N \ln N$$

### Interpretação

Como ambos $\ln L^*$ e $\ln L_0$ são **negativos** (ou zero):
- Modelo completo: $\ln L^* \geq \ln L_0$ (menos negativo, pois é pelo menos tão bom quanto o nulo)
- Portanto: $0 \leq \frac{\ln L^*}{\ln L_0} \leq 1$ e $0 \leq R^2_{\text{McFadden}} \leq 1$

### Tabela de Avaliação

| Valor | Interpretação |
|:---:|:---|
| $< 0{,}20$ | Ajuste fraco |
| $0{,}20 - 0{,}40$ | Bom ajuste |
| $> 0{,}40$ | Ajuste muito bom |

> **Importante:** Na regressão logística, valores relativamente baixos de pseudo-$R^2$ são esperados! Um $R^2_{\text{McFadden}} \approx 0{,}4$ é considerado muito bom e equivale a um $R^2 \approx 0{,}9$ em regressão linear.

---

## 4.2 Acurácia e Taxa de Erro

$$\text{Acurácia} = \frac{\text{Classificações corretas}}{n}$$

$$\text{Taxa de Erro} = 1 - \text{Acurácia} = \frac{\text{Classificações incorretas}}{n}$$

### Observação Importante

- **Taxa de erro aparente:** calculada no conjunto de **treino** — tende a **subestimar** o erro real (overfitting)
- **Taxa de erro real:** calculada no conjunto de **teste** (dados não vistos) — é a medida confiável

---

## 4.3 Matriz de Confusão

Para um **limiar de decisão** $\tau$ (geralmente $\tau = 0{,}5$), a classificação é:

$$\hat{y}_i = \begin{cases} 1 & \text{se } \hat{p}_i \geq \tau \\ 0 & \text{se } \hat{p}_i < \tau \end{cases}$$

A **matriz de confusão** cruza valores reais com preditos:

|  | **Predito: 0** | **Predito: 1** |
|:---|:---:|:---:|
| **Real: 0** | VN (Verdadeiro Negativo) | FP (Falso Positivo) — Erro Tipo I |
| **Real: 1** | FN (Falso Negativo) — Erro Tipo II | VP (Verdadeiro Positivo) |

### Métricas Derivadas

$$\text{Sensibilidade (Recall)} = \frac{VP}{VP+FN} = P(\text{prediz } 1 \mid y=1)$$

$$\text{Especificidade} = \frac{VN}{VN+FP} = P(\text{prediz } 0 \mid y=0)$$

$$\text{Precisão} = \frac{VP}{VP+FP} = P(y=1 \mid \text{prediz } 1)$$

$$\text{F1-Score} = 2 \cdot \frac{\text{Precisão} \times \text{Sensibilidade}}{\text{Precisão} + \text{Sensibilidade}}$$

### Escolha do Limiar

- **Limiar padrão:** $\tau = 0{,}5$ (ponto de corte natural)
- **Contextos com alto custo de falsos negativos** (ex.: diagnóstico de câncer): $\tau < 0{,}5$ para aumentar sensibilidade
- **Contextos com alto custo de falsos positivos** (ex.: spam detection): $\tau > 0{,}5$ para aumentar especificidade

A **curva ROC** ajuda a escolher o limiar ótimo.

---

## 4.4 Curva ROC e AUC

### O que é ROC?

A **Curva ROC** (*Receiver Operating Characteristic*) mostra o tradeoff entre:

- **Eixo Y:** Sensibilidade (TPR = *True Positive Rate*)
- **Eixo X:** 1 − Especificidade (FPR = *False Positive Rate*)

Para **todos os possíveis limiares** $\tau \in [0,1]$.

### AUC — Area Under the ROC Curve

A **AUC** é a integral da curva ROC, resumindo o desempenho global:

| AUC | Interpretação |
|:---:|:---|
| $0{,}5$ | Classificador aleatório (sem poder preditivo) |
| $0{,}70 - 0{,}80$ | Desempenho aceitável |
| $0{,}80 - 0{,}90$ | Bom desempenho |
| $> 0{,}90$ | Desempenho excelente |

### Interpretação Probabilística

AUC = $P(\hat{p}_1 > \hat{p}_0)$ 

Probabilidade de que, dado um par aleatório (um positivo e um negativo), o modelo atribua **maior probabilidade ao positivo**.

---

## 4.5 Comparação com Regressão Linear

| Aspecto | Regressão Linear | Regressão Logística |
|:---|:---:|:---:|
| Variável resposta | Contínua | Binária (0/1) |
| Predições | $(-\infty, +\infty)$ | $[0, 1]$ (probabilidades) |
| Distribuição de $y$ | Normal | Bernoulli |
| Variância | Constante | Varia: $p(1-p)$ |
| Função de ligação | Identidade | Logit |
| $R^2$ | Proporção variância explicada | — Não existe — |
| Pseudo-$R^2$ | — Não aplicável — | McFadden, Nagelkerke, etc. |

---

**Próximo:** [5. Testes de Hipóteses](./05_testes.md)
