# Taiwan Economic Indicators Project

Projeto em Python + SQLite para coleta, tratamento, análise e visualização dos indicadores econômicos de Taiwan.

## O que ele faz
- Faz scraping de séries econômicas públicas de Taiwan.
- Usa fallback sintético para manter o fluxo vivo quando a rede falhar.
- Faz limpeza, interpolação, winsorização, features temporais e tratamento de outliers.
- Faz EDA, estatística descritiva, normalidade, estacionariedade, tendência, anomalias, clusterização e previsão.
- Persiste tudo em SQLite.
- Gera dashboard interativo com Streamlit.
- Gera dashboard estático em PNG.
- Suporta execução contínua com atualização periódica.

## Fontes principais
- Trading Economics para séries históricas de exportações, importações e balança comercial.
- World Bank Indicators API para indicadores macro anuais.
- Ministry of Finance / Taiwan para snapshot mensal recente de comércio exterior.
- DGBAS / Taiwan para apoio conceitual e fontes públicas de indicadores.

## Estrutura
- `pipeline.py`: orquestra coleta, limpeza, análise e persistência.
- `streamlit_app.py`: dashboard interativo.
- `dashboard_png.py`: versão em PNG.
- `scraper.py`: scraping e fallback.
- `cleaning.py`: tratamento dos dados.
- `analysis.py`: EDA, estatística, séries temporais, previsão, anomalias e clusters.
- `database.py`: SQLite.
- `tests/test_taiwan_project.py`: testes.

## Instalação
```bash
pip install -r requirements.txt
```

## Execução
Atualização única:
```bash
python pipeline.py
```

Modo contínuo:
```bash
python pipeline.py --continuous --interval-minutes 60
```

Sem scraping online, usando fallback:
```bash
python pipeline.py --no-live
```

Abrir dashboard:
```bash
streamlit run streamlit_app.py
```

## Testes
```bash
python -m unittest discover -s tests
```

## Observação
No Streamlit mais recente, `use_container_width` está depreciado. Este projeto já usa `width="stretch"`.
