# MANUAL DE OPERACAO - Taiwan Economic Analyzer v2.1

## 1. INTRODUCAO

O Taiwan Economic Analyzer e um sistema completo de coleta, processamento,
analise e visualizacao de indicadores economicos de Taiwan. Projetado para
operacao continua em producao.

## 2. INSTALACAO

### 2.1 Requisitos
- Python 3.8+
- 4GB RAM minimo
- 1GB espaco em disco
- Conexao com internet (para coleta de dados reais)

### 2.2 Dependencias
```bash
pip install -r requirements.txt
```

Dependencias principais:
- requests >= 2.31.0
- beautifulsoup4 >= 4.12.0
- pandas >= 2.0.0
- numpy >= 1.24.0
- matplotlib >= 3.7.0
- scipy >= 1.11.0
- scikit-learn >= 1.3.0
- plotly >= 5.15.0
- streamlit >= 1.28.0
- statsmodels >= 0.14.0

## 3. ESTRUTURA DO PROJETO

```
taiwan_economic_analyzer/
├── config.py              # Configuracoes centralizadas
├── scraper.py             # Web scraping (Trading Economics, World Bank, IMF, MOEA)
├── processor.py           # Processamento e limpeza de dados
├── analyzer.py            # Analise estatistica profunda
├── database.py            # Gerenciamento SQLite
├── dashboard_png.py       # Dashboard estatico em PNG
├── app.py                 # Dashboard interativo Streamlit
├── main.py                # Orquestrador principal + daemon de producao
├── requirements.txt       # Dependencias
├── README.md              # Documentacao rapida
├── MANUAL.md              # Este manual
└── data/
    ├── taiwan_economy.db  # Banco de dados SQLite
    └── logs/              # Logs de execucao
```

## 4. MODOS DE EXECUCAO

### 4.1 Pipeline Completo (Unico)
```bash
python main.py --mode full
```
Executa todo o pipeline: coleta -> processamento -> analise -> banco -> dashboard.

### 4.2 Modo Producao Continuo (Daemon)
```bash
python main.py --mode continuous --interval 60
```
Executa o pipeline automaticamente a cada 60 minutos.

#### Controle do Daemon:
```bash
# Iniciar em background
nohup python main.py --mode continuous --interval 60 > daemon.log 2>&1 &

# Forcar execucao imediata
kill -USR1 <PID>

# Parar graciosamente
kill -TERM <PID>

# Verificar status
ps aux | grep "main.py"
```

### 4.3 Apenas Coleta
```bash
python main.py --mode scrape
```

### 4.4 Apenas Processamento
```bash
python main.py --mode process
```

### 4.5 Apenas Analise
```bash
python main.py --mode analyze
```

### 4.6 Apenas Dashboard PNG
```bash
python main.py --mode dashboard
```

## 5. DASHBOARD INTERATIVO (STREAMLIT)

### 5.1 Iniciar
```bash
streamlit run app.py
```

### 5.2 Acesso
Abra o navegador em: http://localhost:8501

### 5.3 Funcionalidades
- **KPIs em tempo real**: Exportacoes, importacoes, saldo, cobertura, PIB, inflacao
- **Series temporais**: Graficos interativos com eventos economicos marcados
- **Analise YoY**: Variação year-over-year com cores indicando positivo/negativo
- **Sazonalidade**: Padroes mensais medios
- **Correlacoes**: Matriz de correlacao interativa
- **Dados MOEA**: Analise por setor (eletronicos, maquinas, quimicos, etc.)
- **Scatter plot**: Relacao exportacoes vs importacoes
- **Volatilidade**: Desvio padrao movel de 12 meses
- **Medias moveis**: MA3 e MA12 para tendencias
- **Tabela de dados**: Download em CSV

## 6. FONTES DE DADOS

### 6.1 Trading Economics (Primaria)
URL: https://tradingeconomics.com/taiwan/
Indicadores: exports, imports, balance, GDP, inflation, unemployment, interest rate

### 6.2 World Bank API
URL: https://api.worldbank.org/v2/country/TWN/
Indicadores: NE.EXP.GNFS.CD, NE.IMP.GNFS.CD, BN.CAB.XOKA.CD, etc.

### 6.3 IMF Data
URL: https://data.imf.org/api/data/DOT/
Indicadores: TXG_FOB_USD, TMG_CIF_USD

### 6.4 MOEA Taiwan (Ministerio de Assuntos Economicos)
URL: https://www.moea.gov.tw/
Dados: Exportacoes por setor (eletronicos, semicondutores, maquinas, etc.)

### 6.5 Dados Simulados (Fallback)
Gerados automaticamente quando todas as fontes reais falham.
Incluem choques economicos realistas (COVID, boom de chips, etc.)

## 7. BANCO DE DADOS SQLITE

### 7.1 Tabelas
- **economic_data**: Dados economicos principais (136 colunas)
- **moea_data**: Dados do Ministerio de Assuntos Economicos de Taiwan
- **monthly_stats**: Estatisticas agregadas por mes
- **trade_partners**: Parceiros comerciais principais
- **analysis_results**: Resultados de analises estatisticas
- **execution_log**: Historico de execucoes do pipeline
- **alerts**: Alertas de producao
- **system_config**: Configuracoes do sistema

### 7.2 Consultas Uteis
```sql
-- Ultimos 12 meses
SELECT * FROM economic_data ORDER BY date DESC LIMIT 12;

-- Media anual de exportacoes
SELECT year, AVG(exports) as avg_exports 
FROM economic_data GROUP BY year ORDER BY year;

-- Alertas ativos
SELECT * FROM alerts WHERE is_resolved = 0 ORDER BY created_at DESC;

-- Historico de execucoes
SELECT * FROM execution_log ORDER BY execution_date DESC LIMIT 10;
```

## 8. ANALISES ESTATISTICAS

### 8.1 Estatisticas Descritivas
- Media, mediana, desvio padrao, min, max
- Assimetria (skewness) e curtose
- Coeficiente de variacao

### 8.2 Testes de Normalidade
- Shapiro-Wilk
- Jarque-Bera
- D'Agostino

### 8.3 Analise de Tendencia
- Regressao linear
- R² e RMSE
- Direcao da tendencia

### 8.4 Sazonalidade
- Estatisticas mensais
- Coeficiente de variacao sazonal
- Teste de Kruskal-Wallis

### 8.5 PCA (Componentes Principais)
- Variancia explicada
- Loadings
- Reducao de dimensionalidade

### 8.6 Estacionariedade
- Teste ADF (Augmented Dickey-Fuller)
- Teste KPSS

### 8.7 Clustering
- K-Means com numero otimo de clusters
- Silhouette Score
- Analise de perfis

### 8.8 Volatilidade
- Desvio padrao movel
- Estatisticas de retornos
- Assimetria e curtose dos retornos

### 8.9 Cointegracao
- Teste de cointegracao entre exports e imports

### 8.10 Forecasting
- Media movel
- Tendencia linear
- Drift
- Previsao combinada

## 9. CONFIGURACAO

### 9.1 Via Arquivo (config.py)
```python
START_YEAR = 2015          # Ano inicial
END_YEAR = 2026            # Ano final
SCHEDULE_INTERVAL_MINUTES = 60  # Intervalo do daemon
DB_PATH = 'data/taiwan_economy.db'
DASHBOARD_PNG_PATH = 'assets/taiwan_dashboard.png'
```

### 9.2 Via Linha de Comando
```bash
python main.py --start-year 2018 --end-year 2026 --interval 30 --db /path/to/db.sqlite
```

### 9.3 Via Variaveis de Ambiente
```bash
export TAIWAN_START_YEAR=2018
export TAIWAN_DB_PATH=/data/taiwan.db
```

## 10. MONITORAMENTO E ALERTAS

### 10.1 Health Checks
O daemon monitora:
- Ultima execucao bem-sucedida
- Numero de falhas consecutivas
- Tempo desde ultima atualizacao

### 10.2 Alertas Automaticos
Gerados quando:
- 3+ falhas consecutivas
- Dados ausentes por mais de 6 horas
- Anomalias detectadas nos indicadores

### 10.3 Logs
```bash
# Logs em tempo real
tail -f logs/taiwan_analyzer.log

# Relatorios de analise
ls logs/analysis_report_*.txt
```

## 11. DEPLOYMENT EM PRODUCAO

### 11.1 Systemd Service (Linux)
Criar arquivo `/etc/systemd/system/taiwan-analyzer.service`:
```ini
[Unit]
Description=Taiwan Economic Analyzer
After=network.target

[Service]
Type=simple
User=taiwan
WorkingDirectory=/opt/taiwan_economic_analyzer
ExecStart=/usr/bin/python3 /opt/taiwan_economic_analyzer/main.py --mode continuous --interval 60
Restart=on-failure
RestartSec=300

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable taiwan-analyzer
sudo systemctl start taiwan-analyzer
sudo systemctl status taiwan-analyzer
```

### 11.2 Docker
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "main.py", "--mode", "continuous", "--interval", "60"]
```

### 11.3 Cron Job
```bash
# Executar a cada hora
0 * * * * cd /opt/taiwan_economic_analyzer && python main.py --mode full >> /var/log/taiwan_cron.log 2>&1
```

## 12. TROUBLESHOOTING

### 12.1 Erro de Conexao
```
Erro: Connection timeout
Solucao: Verificar conexao com internet. O sistema usara dados simulados como fallback.
```

### 12.2 Banco de Dados Corrompido
```bash
# Backup
mv data/taiwan_economy.db data/taiwan_economy.db.bak

# Recriar
python main.py --mode full
```

### 12.3 Memory Error
```
Erro: MemoryError
Solucao: Reduzir o periodo de analise (--start-year 2020)
```

### 12.4 Streamlit nao inicia
```bash
# Verificar porta
lsof -i :8501

# Usar porta diferente
streamlit run app.py --server.port 8502
```

## 13. BACKUP E RECUPERACAO

### 13.1 Backup Automatico
```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y%m%d_%H%M%S)
cp data/taiwan_economy.db backups/taiwan_economy_${DATE}.db
tar czf backups/assets_${DATE}.tar.gz assets/
find backups/ -name "*.db" -mtime +30 -delete
```

### 13.2 Recuperacao
```bash
# Restaurar backup
cp backups/taiwan_economy_20240115_120000.db data/taiwan_economy.db
```

## 14. ATUALIZACAO

### 14.1 Atualizar Codigo
```bash
git pull origin main
pip install -r requirements.txt --upgrade
```

### 14.2 Migracao de Banco
```bash
# Backup antes de atualizar
python -c "from database import DatabaseManager; db = DatabaseManager(); db.connect(); db.backup()"
```

## 15. REFERENCIAS

- Trading Economics: https://tradingeconomics.com/taiwan
- World Bank API: https://data.worldbank.org/
- IMF Data: https://data.imf.org/
- MOEA Taiwan: https://www.moea.gov.tw/
- Streamlit: https://docs.streamlit.io/

## 16. SUPORTE

Para reportar bugs ou solicitar funcionalidades:
1. Verificar logs em `logs/taiwan_analyzer.log`
2. Verificar relatorios em `logs/analysis_report_*.txt`
3. Verificar status do banco: `python -c "from database import DatabaseManager; db = DatabaseManager(); db.connect(); print(db.get_summary())"`

---
**Versao**: 2.1
**Data**: 2025
**Licenca**: MIT
