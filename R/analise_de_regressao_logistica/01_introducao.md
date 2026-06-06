# 1. Introdução e Motivação

## 1.1 Por que não usar regressão linear?

Quando a variável resposta $y$ é **binária** — assume apenas os valores $0$ (fracasso, ausência, não-evento) e $1$ (sucesso, presença, evento) — a regressão linear ordinária apresenta problemas fundamentais:

| Problema | Descrição |
|:---------|:----------|
| **Previsões fora de [0,1]** | $\hat{y} = \mathbf{x}^\top\pmb{\beta}$ pode assumir qualquer valor real, resultando em "probabilidades" negativas ou maiores que 1 |
| **Heterocedasticidade estrutural** | A variância de $y \sim \text{Bernoulli}(p)$ é $p(1-p)$, que varia com $p$, violando a homocedasticidade |
| **Distribuição dos resíduos** | Os resíduos não seguem distribuição normal, invalidando os testes da regressão linear |

A solução é modelar diretamente a **probabilidade condicional** $P(Y=1 \mid \mathbf{x})$ por meio de uma função que mapeie $(-\infty, +\infty) \to (0, 1)$. A função escolhida é a **sigmoide logística**.

## 1.2 Aplicações típicas

A regressão logística é amplamente utilizada em:

- **Medicina:** diagnóstico (doente/saudável), presença de doença (sim/não)
- **Finanças:** inadimplência (sim/não), fraude (sim/não)
- **Marketing:** conversão de cliente (compra/não compra), *churn* (cancela/permanece)
- **NLP:** detecção de spam (spam/não-spam), sentimento (positivo/negativo)
- **Biologia:** sobrevivência de espécie (sobrevive/extingue)

## 1.3 Fluxo da análise

O pipeline completo de uma análise de regressão logística binária:

```
Dados .csv
   |
   v
1) Exploração — entender distribuições e relações
   |
   v
2) Estimação do modelo — ajustar parâmetros via MV
   |
   v
3) Avaliação do modelo — verificar qualidade (AUC, R², acurácia)
   |
   v
4) Testes de hipóteses — significância global e individual
   |
   v
5) Previsão — fazer classificações em novos dados
```

---

**Próximo:** [2. O Modelo Logístico](./02_modelo_logistico.md)
