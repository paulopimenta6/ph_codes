# EDA Summary — Credit Card Fraud Detection


**Resumo executivo**


A análise exploratória revelou:

- **Desbalanceamento forte**: a classe `Class=1` (fraude) é muito rara; métricas como ROC-AUC, Precision/Recall e F1 são prioritárias.
- **Distribuição do valor transacional (`Amount`) fortemente enviesada**: aplicar `log1p` melhora visualização e tratamento.
- **Correlação entre features**: não há uma feature única claramente redundante; a matriz de correlação mostra blocos com correlações moderadas.
- **PCA (2 componentes)**: fornece uma visão rápida da separabilidade; costuma indicar se modelos simples lineares podem separar as classes.

**Decisões de modelagem justificadas pela EDA**

- Usar modelos baseados em árvores (XGBoost / HistGradientBoosting) por sua robustez em dados tabulares e capacidade de lidar com outliers.
- Aplicar validação estratificada e ajustar penalização para classe minoritária (`scale_pos_weight` ou SMOTE se aplicável).
- Usar transformação logarítmica em `Amount` e considerar interações entre `Amount` e componentes PCA/V-features.

