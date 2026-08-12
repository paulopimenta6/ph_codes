# 9. Glossário e Cola Rápida 📚

> O dicionário de bolso para quando a memória falhar no meio da leitura.
> Cada termo com a tradução "em uma frase" e, ao final, a colinha de
> fórmulas para revisar antes de fechar o notebook.

---

## 9.1 Do A ao Z 🧠

| Termo | Em uma frase |
|:---|:---|
| **AIC / BIC** | "Notas" para comparar modelos **nos mesmos dados**: ajuste menos imposto por parâmetro (o BIC cobra mais caro). |
| **AME** | Efeito marginal médio: média dos efeitos na probabilidade sobre as observações; o que 1 unidade a mais em $x_j$ move, na prática, em pontos percentuais. |
| **AUC** | Área sob a curva ROC; 0,5 = cara ou coroa, 1 = discriminador perfeito. |
| **Acurácia** | Fração de classificações corretas para um limiar; pode enganar com classes desbalanceadas. |
| **Bernoulli** | Distribuição da resposta binária: $Y \sim \text{Bernoulli}(\pi)$. |
| **Deviance** | Medida de falta de ajuste (o "resíduo com esteroides" da logística); reduzir deviance = estatística do TRV. |
| **EPV** | *Events per variable*: mínimo de ~10 eventos por parâmetro. |
| **Efeito marginal** | Variação em $P(Y=1)$ para +1 unidade em $x_j$: $\pi(1-\pi)\beta_j$. |
| **Especificidade** | Fração de não-eventos corretamente identificados: VN/(VN+FP). |
| **Heterocedasticidade** | Variância que muda com o nível; na resposta binária, $\text{Var} = \pi(1-\pi)$. |
| **Hosmer-Lemeshow** | Teste de qualidade do ajuste: frequências observadas vs. esperadas em 10 grupos de risco. |
| **IC (intervalo de confiança)** | Faixa plausível para o parâmetro; se o IC do OR exclui 1, efeito significativo. |
| **IRLS** | *Iteratively Reweighted Least Squares*: o Newton-Raphson da logística — sequência de mínimos quadrados ponderados. |
| **Leverage ($h_{ii}$)** | "Alavanca": quanto cada observação segura o modelo; base do resíduo studentizado. |
| **Logit** | Log-odds: $\ln[\pi/(1-\pi)]$; a escala onde o modelo é linear. |
| **McFadden (pseudo-R²)** | Quanto o modelo *completo* reduz a log-verossimilhança do *nulo*: $1 - \ell(\hat{\beta})/\ell_0$. |
| **MEM** | Efeito marginal na média: calculado em $\pi(\bar{x})$ — o ponto médio das preditoras —, **não** com a média das probabilidades previstas. |
| **MV (MLE)** | Máxima verossimilhança: escolhe o $\beta$ que torna os dados o menos surpreendentes. |
| **Odds** | Razão de chances: $\pi/(1-\pi)$; "3 para 1" não é probabilidade 3. |
| **OR (Odds Ratio)** | $e^{\beta_j}$: fator multiplicativo dos odds quando $x_j$ cresce 1 unidade. |
| **pp** | Pontos percentuais: diferença entre probabilidades (1 pp = 1% de *probabilidade*; não confunda com "% de mudança" dos odds). |
| **Precisão** | Dentre os previstos como evento, quantos realmente são: VP/(VP+FP). |
| **ROC** | Curva sensibilidade × (1 − especificidade) para todos os limiares. |
| **Sensibilidade** | Fração de eventos corretamente identificados: VP/(VP+FN). |
| **Sigmoide** | $\sigma(z) = 1/(1+e^{-z})$: a "porta" que comprime $\mathbb{R}$ em $(0,1)$. |
| **TRV (LR test)** | Razão de verossimilhanças: $G = 2[\ell(\hat{\beta}) - \ell_0] \sim \chi^2_{(p)}$ sob $H_0$. |
| **Wald** | Teste individual: $W_j = (\hat{\beta}_j/SE)^2 \sim \chi^2_{(1)}$ (ou $z = \hat{\beta}_j/SE$). |

---

## 9.2 Cola Rápida de Fórmulas 🧮

| O quê | Fórmula |
|:---|:---|
| Sigmoide | $\pi(\mathbf{x}) = \dfrac{1}{1 + e^{-z}}$, com $z = \mathbf{x}^\top\boldsymbol{\beta}$ |
| Logit | $\text{logit}(\pi) = \ln\dfrac{\pi}{1-\pi} = z$ |
| Odds | $\dfrac{\pi}{1-\pi}$ |
| OR (1 unidade) | $OR_j = e^{\beta_j}$; para $\Delta$ unidades: $e^{\beta_j \Delta}$ |
| Efeito marginal | $\dfrac{\partial \pi}{\partial x_j} = \pi(1-\pi)\beta_j$ |
| MEM | $\pi(\bar{\mathbf{x}})(1-\pi(\bar{\mathbf{x}}))\beta_j$ |
| AME | $\frac{1}{n}\sum_i \pi_i(1-\pi_i)\beta_j$ |
| Log-verossimilhança | $\ell(\boldsymbol{\beta}) = \sum_i [y_i z_i - \ln(1+e^{z_i})]$ |
| IRLS | $\boldsymbol{\beta}^{(t+1)} = (\mathbf{X}^\top \mathbf{W}\mathbf{X})^{-1}\mathbf{X}^\top \mathbf{W}\mathbf{z}^{(t)}$ |
| Cov (assintótica) | $\widehat{\text{Cov}}(\hat{\boldsymbol{\beta}}) = (\mathbf{X}^\top\hat{\mathbf{W}}\mathbf{X})^{-1}$ |
| McFadden | $R^2_{\text{McF}} = 1 - \ell(\hat{\beta})/\ell_0$ |
| Deviance | $D = -2[\ell(\hat{\beta}) - \ell_{\text{sat}}]$ (binário não agrupado: $\ell_{\text{sat}}=0$) |
| AIC / BIC | $-2\ell + 2k$ / $-2\ell + k\ln n$ |
| TRV global | $G = 2[\ell(\hat{\beta}) - \ell_0] \sim \chi^2_{(p)}$ |
| Wald | $W_j = (\hat{\beta}_j/SE_j)^2 \sim \chi^2_{(1)}$ |
| IC do OR | $\exp(\hat{\beta}_j \pm z_{\alpha/2}\,SE_j)$ |
| Pearson | $r_i = (y_i - \hat{\pi}_i)/\sqrt{\hat{\pi}_i(1-\hat{\pi}_i)}$ |
| Studentizado | $r_{si} = r_i/\sqrt{1-h_{ii}}$ ($h_{ii}$ = leverage) |

---

## 9.3 Sinais de Alerta 🚩

- IC do OR contém **1** → efeito não significativo.
- Valor-p < 0,05 no **Hosmer-Lemeshow** → possível falta de ajuste.
- McFadden **< 0,20** → efeitos presentes, mas modestos (não é "modelo
  ruim", é "efeito pequeno").
- **Separar observações** → quebra a independência (Cap. 1, suposição 2).
- Poucos eventos por variável → Wald e p-valores perdem confiabilidade.

---

## 9.4 Onde está tudo? 🧭

| Capítulo | Assunto |
|:---:|:---|
| [1](./01_introducao.md) | Por que linear falha · suposições · fluxo |
| [2](./02_modelo_logistico.md) | Sigmoide · logit · OR · efeitos marginais |
| [3](./03_estimacao.md) | MV · IRLS · propriedades assintóticas |
| [4](./04_avaliacao.md) | McFadden · deviance · AIC/BIC · H-L · resíduos |
| [5](./05_testes.md) | TRV · Wald · ICs |
| [6](./06_da_teoria_ao_codigo.md) | Teoria ↔ código · saída guiada · experimentos |
| [7](./07_implementacao_r.R) | Script completo em R |
| [8](./08_implementacao_python.py) | Script completo em Python |

---
**Anterior:** [6. Da Teoria ao Código](./06_da_teoria_ao_codigo.md) |
**Início:** [00. README (mapa do tutorial)](./00_README.md)