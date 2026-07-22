# Python Projects

Diretório central com projetos, estudos e ferramentas desenvolvidas em Python.

---

## Índice

- [Projetos](#projetos)
- [Como Instalar e Usar Python](#como-instalar-e-usar-python)
- [Licença](#licença)

---

## Projetos

### AI_and_ML
Implementação didática do classificador **Naive Bayes** (Gaussiano e Categórico) do zero com NumPy/SciPy. Inclui pipeline de pré-processamento, métricas de avaliação e dataset Iris. Contém também um exercício de vetor ordenado.

### credit_card_ml_project_with_eda
Pipeline completo de **detecção de fraude em cartões de crédito**. Inclui EDA, treinamento de modelo (XGBoost/HistGradientBoosting), API REST (FastAPI), predição em lote e deploy com Docker.

### introducao_a_ciencia_de_dados_curso_USP
Exercícios do curso introdutório de **Ciência de Dados da USP** — notebooks Jupyter com análises exploratórias e fundamentos de Data Science.

### notebooks
Dataset auxiliar (`acesso.csv`) com padrões de acesso web para exercícios de classificação.

### oop_python
Exemplos práticos de **Programação Orientada a Objetos** em Python: classes, herança, composição, encapsulamento e propriedades — com simulação de contas bancárias e controle remoto.

### python_estudos_atuais
Estudos atuais cobrindo **tratamento de exceções, algoritmos de busca (Gulosa, A*), compressão de dados, jogos, manipulação de arquivos e serialização**.

### python_estudos_passado
Acervo histórico de **estudos iniciais em Python** — mais de 60 scripts abordando fundamentos, matemática, estrutura de dados, regex, SSH, gráficos e OOP.

### python_mem
Ferramenta para **análise de módulos de memória RAM** via SPD EEPROM. Lê e decodifica dados DDR3/DDR4 através do barramento I2C/SMBus do Linux. Inclui CLI, exportação em múltiplos formatos e comparador de módulos.

### python_projetos
Conjunto de seis subprojetos:

| Subprojeto | Descrição |
|---|---|
| `introducao_a_estatistica_para_ciencias_de_dados_caelum` | Estatística: bootstrap, intervalos de confiança, k-fold |
| `machine_learning_com_python` | Classificação com ML (Naive Bayes, árvores) |
| `matematica_com_python` | Álgebra linear e gráficos com NumPy |
| `python_backend` | Algoritmos diversos (fatorial, lambda, matrizes) |
| `python_frontend` | Utilitários (telefone, download, clique) |
| `think_stats` | Análise de dados com ThinkStats (Allen Downey) |

### servidor_MET
Servidor meteorológico **GRIB2** que baixa, processa, mapeia e serve dados de previsão do tempo do modelo **GFS (NOAA)** via API FastAPI. Suporte a METAR, geração de mapas e deployment com Docker.

### taiwan_economic_complete_dashboard
Plataforma completa de **análise econômica de Taiwan**. Coleta dados de Trading Economics, World Bank e IMF, processa, analisa (PCA, clustering, testes de estacionaridade) e exibe em dashboard interativo (Streamlit) ou estático (PNG).

### taiwan_economic_dashboard_web
Dashboard web interativo para **análise de comércio exterior de Taiwan**, construído com Flask + Plotly. Otimizado para Raspberry Pi 4B, com gráficos interativos e atualização automática de dados.

---

## Como Instalar e Usar Python

### 1. Instalação

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv
python3 --version
```

#### Windows
Acesse [python.org/downloads](https://python.org/downloads), baixe o instalador e marque **"Add Python to PATH"** durante a instalação.

#### macOS
```bash
brew install python3
# Ou baixe o instalador em python.org
```

#### Anaconda (recomendado para Data Science)
```bash
# Linux/macOS
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# Após instalar, criar ambiente:
conda create -n meu_ambiente python=3.11
conda activate meu_ambiente
```

### 2. Verificar a instalação
```bash
python --version        # Python 3.x
pip --version           # Gerenciador de pacotes
```

### 3. Gerenciamento de pacotes

```bash
# Instalar pacotes
pip install numpy pandas matplotlib

# Usando requirements.txt
pip install -r requirements.txt

# Listar pacotes instalados
pip list

# Atualizar pip
pip install --upgrade pip
```

### 4. Ambiente virtual (recomendado)

```bash
# Criar ambiente virtual
python3 -m venv .venv

# Ativar
source .venv/bin/activate      # Linux/macOS
.venv\Scripts\activate          # Windows

# Desativar
deactivate
```

### 5. Executar scripts Python

```bash
# Executar script diretamente
python script.py

# Modo interativo
python

# Executar notebook Jupyter
jupyter notebook
# ou
jupyter lab
```

### 6. VS Code — selecionar interpretador

1. Abra a Paleta de Comandos: `Ctrl + Shift + P`
2. Digite `Python: Select Interpreter`
3. Escolha o interpretador desejado (sistema, venv ou Conda)

---

## Licença

Este repositório contém projetos de estudo e ferramentas pessoais. Consulte cada subprojeto para licenças específicas.
