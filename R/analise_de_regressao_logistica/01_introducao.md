# 1. Introdução — O Caso do Vale-Café ☕

> **A história que nos acompanha:** o Seu Bento, dono de uma cafeteria,
> quer saber **por que** alguns clientes ganham o "vale-café" mensal
> (evento = $1$) e outros não (evento = $0$). Ele tem dados de idade,
> tempo de casa e consumo de cada cliente. Ele não quer *adivinhar quem
> vai ganhar*: quer **entender o que influencia** o sorteio. Essa é a
> diferença entre *predição* e *análise* — e este tutorial é sobre a
> segunda.

Quando a resposta de interesse é **sim/não** (comprou ou não, doente ou
saudável, aprovou ou reprovou), a regressão linear — tão querida nas
aulas de estatística — quebra as três pernas de uma vez. Vamos ver por
quê, e qual é a saída elegante: a **regressão logística**.

🎯 **Neste capítulo você vai aprender:**

- por que a regressão linear não funciona com resposta binária;
- o que significa "analisar" (e não "predizer") com regressão logística;
- as suposições do modelo e quando ele pode ser usado;
- o fluxo completo de uma análise.

---

## 1.1 Por que não usar regressão linear? 🚫

Quando a variável resposta $Y$ é **binária** — assume apenas os valores
$0$ (fracasso, ausência) e $1$ (sucesso, presença) — a regressão linear
ordinária (OLS) apresenta **três problemas fundamentais**:

| # | Problema | Descrição |
|:---:|:---|:---|
| 1️⃣ | **Previsões fora de [0,1]** | $\hat{y} = \mathbf{x}^\top\boldsymbol{\beta}$ pode assumir qualquer valor real. O modelo "vaza" probabilidade: pode prever $-0{,}3$ ou $1{,}4$ — impossível para uma probabilidade |
| 2️⃣ | **Heterocedasticidade estrutural** | $Y \mid \mathbf{x} \sim \text{Bernoulli}(p(\mathbf{x}))$, logo $\text{Var}(Y \mid \mathbf{x}) = p(\mathbf{x})(1-p(\mathbf{x}))$ depende de $\mathbf{x}$. A variância muda com o nível de $p$ — o modelo vive "tremendo" |
| 3️⃣ | **Resíduos longe da normalidade** | O resíduo $\varepsilon_i = y_i - \hat{y}_i$ assume só **dois valores** para cada $\mathbf{x}_i$. Sem normalidade, os testes $t$ e $F$ viram papel decorativo |

💡 **Sacada:** o problema de fundo é que $Y$ não vive em uma reta — ela
vive entre duas "paredes" (0 e 1). A solução é modelar a
**probabilidade condicional** $\pi(\mathbf{x}) = P(Y=1 \mid \mathbf{x})$
por uma função que mapeie $\mathbb{R} \to (0,1)$: a **sigmoide
logística** (a tal "porta que abre devagar", que conheceremos no
[Capítulo 2](./02_modelo_logistico.md)).

---

## 1.2 O que significa "analisar"? 🔍

Diferentemente de problemas de **predição** (classificar novos casos,
campeonato de acurácia), a **análise** de regressão logística responde
a quatro perguntas:

1. **Quais variáveis exercem efeito significativo** sobre a ocorrência
   do evento? *(Teste de Wald e TRV — Capítulo 5)*
2. **Qual a magnitude e direção** desse efeito? *(Odds Ratio e efeitos
   marginais — Capítulo 2)*
3. **O modelo se ajusta adequadamente** aos dados? *(Pseudo-R²,
   Hosmer-Lemeshow, resíduos — Capítulo 4)*
4. **Qual a incerteza** das estimativas? *(Intervalos de confiança e
   erros-padrão — Capítulos 2 e 5)*

⚠️ **Cilada:** se alguém te pedir apenas "a acurácia do modelo", você
está sendo arrastado para o território da predição. A acurácia serve de
apoio; o veredito da análise vem dos testes e dos intervalos.

---

## 1.3 Suposições do Modelo 📜

A regressão logística binária é parcimoniosa nas exigências — mas não
dispensa o contrato de locação:

1. **Resposta binária:** $Y_i \in \{0,1\}$.
2. **Independência:** as observações são independentes entre si.
3. **Linearidade no logit:** $\text{logit}(\pi_i) = \mathbf{x}_i^\top\boldsymbol{\beta}$
   é linear nos parâmetros.
4. **Ausência de multicolinearidade severa:** as preditoras não são
   cópias umas das outras.
5. **Tamanho da amostra:** mínimo de **10 eventos por parâmetro**
   (regra *events per variable*, EPV — "um chefe para cada 10
   funcionários").

> ✅ **Boa notícia:** diferente da regressão linear, a logística **não**
> exige normalidade dos resíduos, homocedasticidade, nem linearidade na
> escala original. A resposta é binária e o tratamento é outro.

---

## 1.4 Aplicações Típicas em Análise 🗺️

| Área | Pergunta analítica |
|:---|:---|
| 🏥 **Medicina** | Qual o efeito de um tratamento sobre a probabilidade de cura, ajustando por confundidores? |
| 💼 **Economia** | Qual o impacto de cada ano de escolaridade na probabilidade de estar empregado? |
| 🦠 **Epidemiologia** | Qual o odds ratio de exposição a um fator de risco, controlando por covariáveis? |
| 🏛️ **Ciências sociais** | Variáveis demográficas afetam a probabilidade de um comportamento? |

---

## 1.5 Fluxo da Análise 🧭

O roteiro da jornada — cada etapa vira um capítulo:

```
                    Dados
                      │
                      ▼
        ┌── 1. Análise exploratória
        ┌── 2. Especificação do modelo
        ┌── 3. Estimação (MV)                       [Capítulo 3]
        ┌── 4. Interpretação: coeficientes / OR     [Capítulo 2]
        ┌── 5. Testes de hipóteses (Wald, TRV)      [Capítulo 5]
        ┌── 6. Avaliação do ajuste (R², AIC, dev.])  [Capítulo 4]
        ┌── 7. Diagnóstico (resíduos, H-L)          [Capítulo 4]
        └── 8. Conclusões analíticas
```

---

## 🧪 Teste seu radar (respostas no fim)

1. Você prevê "1,4 cliente feliz em 10" com regressão linear. O que há de
   errado? *(Dica: probabilidade tem barreiras.)*
2. A regressão logística exige resíduos normais? *(Sim / Não)*
3. Quantos eventos por parâmetro a regra EPV recomenda, no mínimo?

**Respostas:** 1) A previsão saiu do intervalo $[0,1]$ — probabilidade
não pode passar de 1. 2) **Não** — essa é uma libertação do modelo. 3)
**10** eventos por parâmetro.

---

## ✅ Para levar

- Resposta binária + regressão linear = três problemas (intervalo,
  variância e resíduos).
- A logística modela $P(Y=1 \mid \mathbf{x})$ com a **sigmoide**, que
  vive entre 0 e 1.
- **Análise** responde "qual o efeito e quão confiável" — predição
  responde "qual a classe". Este tutorial é sobre análise.

---
**Próximo:** [2. O Modelo Logístico — a porta que abre devagar](./02_modelo_logistico.md)