# Taiwan Economic Trade Analyzer v2.1

## CORRECOES DA v2.1
- **Bug de ordenacao de datas**: Adicionado `.sort_values('date')` em todas as consolidacoes
- **Scraper Trading Economics**: Parsing robusto com multiplas estrategias (tabelas + JSON embed)
- **Threshold de dados**: Fonte real precisa retornar >5 registros para ser aceita
- **Validacao**: Verificacao de ordenacao monotonica antes de prosseguir

## Estrutura
```
taiwan_trade_analyzer/
├── taiwan_trade_production.py          # v2.1 CORRIGIDO (982 linhas)
├── backup/
│   ├── taiwan_trade_app_v1.py          # v1.0 original
│   └── taiwan_trade_production_v20.py  # v2.0 (com bug)
├── data/
│   ├── taiwan_trade_production.db
│   └── taiwan_trade.db
└── output/
    ├── taiwan_dashboard_production.png
    └── taiwan_dashboard_v1.png
```

## Instalacao
```bash
pip install pandas numpy matplotlib requests beautifulsoup4 scipy scikit-learn
```

## Uso
```bash
python taiwan_trade_production.py --mode full
```

## Fontes de Dados (prioridade)
1. Trading Economics (HTML scraping)
2. World Bank API
3. IMF Data API
4. Dados simulados (fallback)
