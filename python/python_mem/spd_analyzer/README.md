# SPD Analyzer

Ferramenta de linha de comando para ler, decodificar, comparar e exportar dados SPD (Serial Presence Detect) de módulos de memória DDR3 e DDR4 via SMBus.

Baseada na especificação **JEDEC Standard No. 21-C**.

## Requisitos

- Python >= 3.10
- Para leitura via hardware: `i2c-tools` e módulo `i2c-dev` carregado
- Apenas para decodificação de arquivos já extraídos: nenhuma dependência de sistema

## Instalação

```bash
# via pip
pip install spd-analyzer

# via pipx (recomendado, isolado)
pipx install spd-analyzer

# modo desenvolvimento (editable)
git clone https://github.com/paulopimenta6/ph_codes.git
cd ph_codes/python/python_mem/spd_analyzer
./scripts/install.sh dev

# dependências de sistema (para leitura de hardware Linux)
./scripts/install.sh deps
```

Dependências Python opcionais:

| Grupo   | Instalação                     | Necessário para          |
|---------|--------------------------------|--------------------------|
| smbus   | `pip install spd-analyzer[smbus]` | scan e dump via SMBus |
| dev     | `pip install spd-analyzer[dev]`   | rodar testes           |

## Uso rápido (sem hardware)

O repositório já contém dados de exemplo em `data/`. Para decodificar:

```bash
spd-analyzer decode
```

## Comandos

| Comando                                   | Descrição                                |
|-------------------------------------------|------------------------------------------|
| `spd-analyzer scan`                       | Detecta módulos nos barramentos SMBus    |
| `spd-analyzer dump`                       | Lê o SPD dos módulos e salva em `data/`  |
| `spd-analyzer decode`                     | Decodifica arquivos em `data/`           |
| `spd-analyzer decode -i arquivo.bin`      | Decodifica um arquivo específico         |
| `spd-analyzer decode -i pasta/`           | Decodifica todos os arquivos de uma pasta|
| `spd-analyzer compare`                    | Compara dois ou mais módulos             |
| `spd-analyzer export json`                | Exporta para `reports/report.json`       |
| `spd-analyzer export csv`                 | Exporta para `reports/report.csv`        |
| `spd-analyzer export html`                | Exporta para `reports/report.html`       |
| `spd-analyzer hex`                        | Exibe dump hexadecimal raw               |
| `spd-analyzer info`                       | Exibe informações do sistema e versão    |
| `spd-analyzer --help`                     | Ajuda completa                           |

## Fluxo típico

### Com hardware (Linux)

```bash
sudo modprobe i2c-dev              # carrega o módulo i2c
spd-analyzer scan                  # detecta módulos
spd-analyzer dump                  # extrai dados SPD
spd-analyzer decode                # decodifica e exibe
spd-analyzer compare               # compara módulos
spd-analyzer export html           # gera relatório HTML
```

### Sem hardware

Use os dados de exemplo ou gere dados sintéticos:

```bash
spd-analyzer decode -i data/       # decodifica exemplos
python scripts/generate_test_spd.py tests/data/   # gera SPD sintético
spd-analyzer decode -i tests/data/                # decodifica os gerados
```

## Dados suportados

O leitor aceita dois formatos:

1. **Binário raw** (`.bin`) — 256 bytes crus do SPD
2. **Texto i2cdump** — saída textual do `i2cdump` (convertido automaticamente)

## Scripts auxiliares

| Script                          | Função                                    |
|---------------------------------|-------------------------------------------|
| `scripts/dump_spd.sh`           | Extrai SPD via i2c-tools (shell)          |
| `scripts/convert_text_dumps.py` | Converte dumps em texto para binário      |
| `scripts/generate_test_spd.py`  | Gera dados SPD sintéticos para testes     |

## Testes

```bash
pip install -e ".[dev]"
python -m pytest
```

## Estrutura do projeto

```
spd-analyzer/
├── spd_analyzer/       # Código principal
│   ├── cli.py          # Interface de linha de comando
│   ├── reader.py       # Leitura via SMBus e arquivos
│   ├── parser.py       # Parser binário do SPD
│   ├── decoder.py      # Decodificação para objetos
│   ├── jedec.py        # Banco de dados JEDEC
│   ├── timings.py      # Cálculo de timings
│   ├── validators.py   # Validação CRC
│   ├── report.py       # Relatório no terminal (rich)
│   ├── html.py         # Exportação HTML
│   ├── json_export.py  # Exportação JSON
│   ├── csv_export.py   # Exportação CSV
│   ├── compare.py      # Comparação entre módulos
│   └── utils.py        # Utilitários
├── scripts/            # Scripts auxiliares
├── tests/              # Testes automatizados
├── data/               # Dumps SPD de exemplo
├── reports/            # Relatórios exportados
├── pyproject.toml
├── requirements.txt
└── README.md
```

## Formatos SPD suportados

| Tipo | Suporte |
|------|---------|
| DDR3 | Completo |
| DDR4 | Básico |
| DDR5 | Planejado |
| DDR2 | Planejado |

## Licença

MIT
