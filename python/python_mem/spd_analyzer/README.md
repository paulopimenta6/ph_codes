# SPD Analyzer

Ferramenta profissional para análise de SPD (Serial Presence Detect) de módulos de memória.

Baseada na especificação oficial **JEDEC Standard No. 21-C**, sem dependência de `decode-dimms`.

## Recursos

- **Detecção automática** de módulos via SMBus (endereços 0x50–0x57)
- **Leitura** do SPD de módulos DDR3, DDR4, DDR5 (em desenvolvimento)
- **Decodificação completa** dos 256 bytes do SPD:
  - Tipo, capacidade, organização, largura de barramento
  - Fabricante do módulo e fabricante dos chips DRAM
  - Perfis JEDEC (velocidades e timings)
  - Tensão suportada e tensão nominal
  - Número de série, part number, data de fabricação
  - **Validação de CRC** por região
- **Comparação** entre módulos (capacidade, timings, tensão, perfil JEDEC, rank, CRC)
- **Exportação** em JSON, CSV e HTML
- Interface colorida com `rich`

## Instalação

### Via pip

```bash
pip install spd-analyzer
```

### Via pipx (recomendado)

```bash
pipx install spd-analyzer
```

### Desenvolvimento

```bash
git clone https://github.com/paulopimenta6/ph_codes.git
cd /python/python_mem/spd_analyzer
./scripts/install.sh dev
```

### Dependências do sistema

```bash
./scripts/install.sh deps
```

## Uso

### Detectar módulos

```bash
spd-analyzer scan
```

### Extrair SPD

```bash
spd-analyzer dump
```

Os arquivos serão salvos em `data/dimm0.bin`, `data/dimm1.bin`, etc.

### Decodificar

```bash
spd-analyzer decode
```

Para um arquivo específico:

```bash
spd-analyzer decode -i data/dimm0.bin
```

### Comparar módulos

```bash
spd-analyzer compare
```

### Exportar

```bash
spd-analyzer export json
spd-analyzer export csv
spd-analyzer export html
```

Os arquivos são salvos em `reports/report.json`, `reports/report.csv`, `reports/report.html`.

### Dump hexadecimal

```bash
spd-analyzer hex
```

### Informações do sistema

```bash
spd-analyzer info
```

## Estrutura do projeto

```
spd-analyzer/
├── spd_analyzer/
│   ├── __init__.py
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
├── scripts/
│   ├── dump_spd.sh     # Dump via shell (i2c-tools)
│   └── install.sh      # Instalação
├── tests/
├── data/               # SPD dumps
├── reports/            # Relatórios exportados
├── pyproject.toml
├── requirements.txt
├── README.md
└── LICENSE
```

## Formatos SPD suportados

| Tipo | Suporte |
|------|---------|
| DDR3 | ✓ Completo |
| DDR4 | ✓ Básico |
| DDR5 | △ Planejado |
| DDR2 | △ Planejado |

## Licença

MIT
