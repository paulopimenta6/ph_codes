# 6. Da Teoria ao Código — Hora do Show 💻

> Os capítulos 1–5 deram a teoria; os scripts
> [R](./07_implementacao_r.R) e [Python](./08_implementacao_python.py)
> fazem a viagem inteira de ponta a ponta. Este capítulo é o **mapa do
> tesouro**: como a teoria vira código, o que observar na saída e como
> brincar com os dados sem quebrar nada.

🎯 **Neste capítulo:**

- o roteiro completo de análise dentro dos scripts;
- o **mapa teoria ↔ código** (função por função);
- leitura guiada de uma saída real (dados simulados, semente 42);
- experimentos para treinar seu olhar;
- erros comuns de execução (e como fugir deles).

---

## 6.1 O Roteiro em 14 Passos 🗺️

Ambos os scripts executam a mesma jornada do [Capítulo 1](./01_introducao.md):

```
 1. Criar dados simulados (se não existirem)   → dados.csv
 2. Carregar e validar (colunas, NAs, classes)
 3. Análise exploratória (gráficos)
 4. Dividir treino/teste (70/30, estratificado)
 5. Ajustar o modelo (MV)                        → cap. 3
 6. Coeficientes e OR com IC 95%                 → cap. 2
 7. Efeitos marginais (AME)                      → cap. 2
 8. Pseudo-R², AIC, BIC, deviance                → cap. 4
 9. TRV global                                   → cap. 5
10. Wald individual                              → cap. 5
11. Hosmer-Lemeshow                              → cap. 4
12. Avaliação no teste (auxiliar: acurácia)
13. Curva ROC / AUC (auxiliar)
14. Predição para nova observação (auxiliar)
```

> 💡 **Sacada:** os passos **6–11 são a análise** (o veredito). Os passos
> **12–14 são apoio** — ajudam a contar a história, mas não decidem.

---

## 6.2 Mapa Teoria ↔ Código 🧭

| Conceito | Capítulo | R (função) | Python (função) |
|:---|:---:|:---|:---|
| Dados simulados | — | `criar_dados_simulados()` | `criar_dados_simulados()` |
| Validação dos dados | — | `carregar_dados()` | `carregar_dados()` |
| Exploração | 1 | `analise_exploratoria()` | `analise_exploratoria()` |
| Divisão treino/teste | — | `dividir_dados()` | `train_test_split(...)` |
| Ajuste por MV | 3 | `glm(family = binomial)` | `sm.Logit(...).fit()` |
| Coeficientes + OR + IC | 2, 5 | `tabela_coeficientes()` | `tabela_coeficientes()` |
| Efeitos marginais (AME) | 2 | `efeitos_marginais()` | `efeitos_marginais()` |
| Pseudo-R², AIC, BIC | 4 | `medidas_ajuste()` | `medidas_ajuste()` |
| TRV global | 5 | `teste_trv()` | `teste_trv()` |
| Wald individual | 5 | `teste_wald()` | `teste_wald()` |
| Hosmer-Lemeshow | 4 | `teste_hosmer_lemeshow()` | `teste_hosmer_lemeshow()` |
| Resíduos | 4 | `diagnostico_residuos()` | `diagnostico_residuos()` |
| ROC / AUC | 4 | `plotar_roc()` (`pROC`) | `plotar_roc()` (`sklearn`) |
| Nova observação | — | `predicao_nova_obs()` | `predicao_nova_obs()` |

**Para executar:**

```bash
# R
Rscript 07_implementacao_r.R

# Python
python 08_implementacao_python.py
```

> ⚠️ **Cilada (o R nunca avisa):** no R, as funções `efeitos_marginais`,
> `medidas_ajuste` e `teste_trv` liam `modelo$data` e uma variável `X`
> que não existia — o script quebrava no meio do caminho. A correção usa
> `model.frame(modelo)` (o quadro de dados real usado no ajuste) e os
> nomes dos coeficientes via `coef(modelo)`. Se você recortar funções
> deste script para outro lugar, lembre-se disso!

## 6.3 Leitura Guiada de uma Saída Real 📖

Abaixo, a interpretação de cada bloco da saída (Python, semente 42 —
no R os valores vêm **próximos, mas não idênticos**: as linguagens usam
geradores aleatórios diferentes na hora de criar os dados).

**① Dados:** 350 observações · Classe 1: **102 (29,1%)** · Treino: 245 ·
Teste: 105.
→ 29% de eventos é um bom equilíbrio para análise (nem raro, nem
massivo).

**② Coeficientes e OR (o coração da análise):**

| Variável | Coeficiente | Erro-padrão | OR | IC 95% do OR |
|:---|---:|---:|---:|---:|
| Intercepto | −7,3786 | 1,1603 | — | — |
| x1 | +0,0724 | 0,0127 | 1,075 | [1,048; 1,102] |
| x2 | +0,0660 | 0,0170 | 1,068 | [1,033; 1,104] |

→ A cada **unidade a mais em x1**, os odds multiplicam por **1,075**
(+7,5%). O IC não contém 1 → efeito significativo. O mesmo vale para x2
(+6,8%).

**③ Efeitos marginais:** AME(x1) ≈ 0,0118 e AME(x2) ≈ 0,0107 → na
probabilidade, 1 unidade a mais em x1 move $P(Y=1)$ em ~**1,2 pontos
percentuais** (na média das observações). O OR diz "multiplica"; o AME
diz "quanto na prática".

**④ Medidas de ajuste:** McFadden = 0,1789 (**fraco**), AIC = 248,21,
BIC = 258,71, deviance nula 294,96 (gl 2) → residual 242,21 (gl 242).

**⑤ TRV:** $G$ = 52,75, gl = 2, p = 3,5×10⁻¹² → **rejeitar $H_0$**: o
bloco de preditoras é globalmente significativo.

**⑥ Wald:** x1: $W$ = 32,37 ***, x2: $W$ = 15,05 *** → ambos os
coeficientes significativos individualmente.

**⑦ Hosmer-Lemeshow:** $\hat{C}$ = 9,36, gl = 8, p = 0,3126 → **não
rejeitar $H_0$**: sem evidência de falta de ajuste.

**⑧ Resíduos:** ~6,5% com $|r| > 2$ (Pearson) e ~4,5% (deviance) →
proporção típica; nada alarmante.

**⑨ Apoio preditivo:** acurácia 73,3% no teste · AUC = 0,698
(discriminação "aceitável"). Coerente com a nota fraca de McFadden — a
análise aponta efeitos **significativos, porém modestos**.

**⑩ Nova observação (x1=45, x2=55):** $\hat{\pi}$ = 0,3779 → classifica
como Fracasso (0). (Lembre: prever a classe é uso auxiliar; o que a
análise entrega são os efeitos e seus ICs.)

---

## 6.4 O que o Seu Bento Descobriu ☕ (interpretação narrativa)

1. **x1 e x2 importam** — o TRV e o Wald concordam ($p$ minúsculos).
2. **Os efeitos são positivos** — valores maiores em x1 e x2 aumentam as
   chances do vale-café (OR > 1).
3. **A magnitude é modesta** — cerca de +1 pp por unidade na
   probabilidade (AME), McFadden 0,18.
4. **O modelo se comporta bem** — H-L sem sinal de falta de ajuste,
   resíduos dentro do esperado.

> Conclusão honesta: "há efeito, é positivo, e é pequeno". Análise que
> reporta só "o modelo tem 73% de acurácia" conta meia história.

---

## 6.5 Experimentos para Treinar o Olhar 🧪

| Experimento | O que muda? | O que observar? |
|:---|:---|:---|
| `SEMENTE <- 123` | Os dados (geradores diferentes) | Estimativas balançam? Conclusões mudam de sentido? |
| `n <- 2000` no gerador | Amostra maior | Erros-padrão **diminuem**; p-valores caem |
| `z <- 0.3*x1 + 0.25*x2 - 7` | Efeitos mais fortes | OR maior, AME maior, McFadden sobe |
| `LIMIAR_DECISAO <- 0.3` | Limiar de classificação | Acurácia/AUC variam; a análise **não** |
| Trocar `x2` por outra coluna | Spec errada | H-L e resíduos podem reclamar |
| Rodar R e Python na mesma pasta | Nada — é o mesmo `dados.csv` | Resultados ficam **quase idênticos** |

---

## 6.6 Erros Comuns de Execução 🚑

1. **Pacotes ausentes:** o script R instala `tidyverse`, `caret`, `pROC`,
   `broom` e `gridExtra` sozinho (pode demorar). No Python, instale antes:
   ```bash
   pip install numpy pandas scipy scikit-learn statsmodels matplotlib
   ```
   💡 **Dica venv (WSL/Linux):** crie um ambiente isolado para não poluir
   o Python do sistema:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install numpy pandas scipy scikit-learn statsmodels matplotlib
   ```
2. **`dados.csv` de outra execução:** se o arquivo existir, os scripts o
   reutilizam. Para regenerar com nova semente, apague `dados.csv`.
3. **Colunas erradas:** o script exige as colunas configuradas em
   `VARIAVEL_RESPOSTA` e `VARIAVEIS_PRED` — ajuste as constantes no topo
   do arquivo (configuração centralizada).
4. **Classes desbalanceadas (EPV):** com muito poucos eventos, o aviso
   de convergência aparece e o Wald pode mentir — volte ao Capítulo 1
   (regra dos 10 eventos por parâmetro).

---

## ✅ Para levar

- Teoria e código caminham juntos: cada função dos scripts corresponde
  a uma seção dos capítulos 1–5.
- A saída tem três camadas: **efeitos (OR/AME)**, **significância
  (TRV/Wald/IC)** e **ajuste (McFadden/H-L)** — leia as três.
- Os scripts são brinquedos didáticos: mexa nas constantes e veja a
  teoria acontecer.

---
**Anterior:** [5. Testes de Hipóteses](./05_testes.md) |
**Próximo:** [9. Glossário e Cola Rápida](./09_glossario.md) |
(**Scripts:** [R](./07_implementacao_r.R) \| [Python](./08_implementacao_python.py))