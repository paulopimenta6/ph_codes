# Taiwan Economic Analyzer v2.1

Sistema completo de coleta, processamento, analise e visualizacao de indicadores economicos de Taiwan.

## Funcionalidades

- **Web Scraping**: Coleta dados de Trading Economics, World Bank e IMF
- **Processamento**: Limpeza, tratamento de missing, outliers e engenharia de features
- **Analise Estatistica**: EDA completa, series temporais, clustering, PCA, testes de estacionariedade
- **Dashboard Interativo**: Streamlit com visualizacoes em tempo real
- **Dashboard Estatico**: PNG de alta resolucao com matplotlib
- **Banco de Dados**: SQLite com schema completo
- **Modo Continuo**: Daemon que coleta e processa dados automaticamente

## Instalacao

```bash
cd taiwan_economic_analyzer
pip install -r requirements.txt
```

## Uso

### Pipeline Completo (Unico)
```bash
python main.py --mode full
```

### Modo Continuo (Daemon)
```bash
python main.py --mode continuous --interval 60
```

### Dashboard Interativo
```bash
streamlit run app.py
```

### Apenas Analise
```bash
python main.py --mode analyze
```

## Estrutura do Projeto

```
taiwan_economic_analyzer/
├── config.py           # Configuracoes centralizadas
├── scraper.py          # Web scraping multi-fonte
├── processor.py        # Processamento e limpeza
├── analyzer.py         # Analise estatistica profunda
├── database.py         # Gerenciamento SQLite
├── dashboard_png.py    # Dashboard estatico
├── app.py              # Dashboard Streamlit
├── main.py             # Orquestrador principal
├── requirements.txt    # Dependencias
└── data/
    ├── taiwan_economy.db
    └── logs/
```

## Indicadores Monitorados

- Exportacoes e Importacoes
- Saldo Comercial (Balance)
- Crescimento do PIB
- Inflacao (CPI)
- Desemprego
- Producao Industrial
- Taxa de Juros
- Taxa de Cambio

## Fontes de Dados

1. Trading Economics (primaria)
2. World Bank API
3. IMF Data
4. Dados Simulados (fallback)

## Licenca

MIT License
