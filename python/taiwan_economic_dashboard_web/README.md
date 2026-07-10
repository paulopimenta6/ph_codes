# Taiwan Economic Dashboard

Dashboard interativo para análise de comércio exterior de Taiwan. Gera gráficos interativos via web (Flask + Plotly) ou estático PNG.

## Requisitos

- Python 3.9+
- ~150MB de espaço em disco
- Conexão com internet (na primeira execução para instalar dependências)
- Funciona em Raspberry Pi 4B (1GB RAM)

## Instalação

```bash
# 1. Instalar dependências
pip install pandas numpy matplotlib requests beautifulsoup4 scipy scikit-learn lxml flask plotly

# 2. Verificar instalação
python3 -c "import flask, plotly; print('OK')"
```

Se estiver no Raspberry Pi OS, pode precisar do `pip3`:
```bash
sudo apt install python3-pip python3-venv
cd /home/nottingham/projetos/servidor_dados
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Uso no Raspberry Pi 4B

### Opção 1: Servidor como serviço (recomendado para SSH)

Instala o dashboard como serviço do sistema. Ele sobe sozinho na inicialização do Pi e continua rodando mesmo depois de você fechar o SSH.

```bash
# Instalar (uma vez, executar dentro do diretório do projeto)
cd /home/nottingham/projetos/servidor_dados
chmod +x install_service.sh
./install_service.sh

# Comandos úteis depois da instalação:
sudo systemctl status taiwan-dashboard   # Ver se está rodando
sudo systemctl stop taiwan-dashboard     # Parar
sudo systemctl start taiwan-dashboard    # Iniciar
sudo journalctl -u taiwan-dashboard -f   # Ver logs ao vivo
```

Acesse `http://<IP_DO_RASPBERRY>:5000` no navegador de qualquer computador na mesma rede.

### Opção 2: Dashboard Web Interativo (manual)

Inicia o servidor manualmente (morre quando você fecha o SSH, a menos que use tmux):

```bash
# Iniciar servidor (modo otimizado para Pi)
python3 app.py --host 0.0.0.0 --port 5000 --pi-mode

# Ou usar o script pronto
./start_pi.sh
```

Para manter rodando após desconectar o SSH, use tmux:
```bash
tmux new -s dashboard
python3 app.py --host 0.0.0.0 --port 5000 --pi-mode
# Ctrl+B, D para desanexar (o servidor continua)
# tmux attach -t dashboard para voltar
```

Acesse `http://<IP_DO_RASPBERRY>:5000` no navegador.

- Todos os gráficos têm zoom, pan e hover com dados
- Botão "Recarregar Dados" para buscar novas informações
- Layout responsivo (funciona no celular)

### Opção 2: HTML Standalone

Gera um arquivo HTML que abre direto no navegador (sem servidor rodando):

```bash
python3 app.py --no-web --output dashboard.html
```

Depois é só abrir `dashboard.html` no navegador.

### Opção 3: Dashboard PNG (original)

```bash
python3 taiwan_trade_production.py --mode dashboard
```

Gera `taiwan_dashboard.png`.

## Estrutura dos Arquivos

```
├── app.py                         # Servidor web Flask (dashboard interativo)
├── taiwan_trade_production.py     # Pipeline original (coleta, análise, PNG)
├── templates/dashboard.html       # Template HTML com Plotly.js
├── start_pi.sh                    # Script de inicialização para Raspberry Pi
├── install_service.sh             # Instala o servidor como serviço do sistema
├── requirements.txt               # Dependências do projeto
├── dashboard_interativo.html      # HTML standalone (gerado pelo app.py --no-web)
├── taiwan_dashboard.png           # Dashboard PNG (gerado pelo pipeline original)
└── taiwan_trade.db                # Banco SQLite com dados processados
```

## APIs do Servidor Web

Com o servidor rodando, essas URLs estão disponíveis:

| Rota | Descrição |
|---|---|
| `/` | Dashboard completo com todos os gráficos |
| `/api/figures` | JSON com dados de todos os 10 gráficos Plotly |
| `/api/data` | JSON com dados brutos (séries temporais) |
| `/api/health` | Status do servidor e metadados |
| `/api/reload` | Força recarga dos dados |

## Fontes de Dados

1. **Trading Economics** (scraping HTML)
2. **World Bank API** (dados anuais)
3. **IMF Data API**
4. **Dados simulados** (fallback automático quando não há internet)

O sistema tenta as fontes reais em ordem. Se todas falharem, gera dados sintéticos realistas com sazonalidade, tendência e choques (COVID, guerra, boom de chips).

## Solução de Problemas no Raspberry Pi

**Erro de memória**: Antes de executar, feche outros programas pesados.
```bash
# Limitar threads das bibliotecas numéricas
export OMP_NUM_THREADS=2
export MKL_NUM_THREADS=2
export OPENBLAS_NUM_THREADS=2
```

**Servidor lento para iniciar**: A primeira execução faz várias tentativas de conexão com APIs externas (pode levar ~40s). Use `--pi-mode` para acelerar.

**Porta 5000 ocupada**: Use outra porta:
```bash
python3 app.py --port 8080
```

**HTML standalone não atualiza**: Regere o arquivo:
```bash
python3 app.py --no-web --reload
```
