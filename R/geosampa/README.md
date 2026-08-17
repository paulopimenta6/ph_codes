# 🗺️ GeoSampa — O Garimpeiro de Tesouros da Cidade

> Imaginou ter uma **pá mágica** que abre o baú de mapas da Prefeitura de São Paulo
> e traz pra você, em segundos, **onde ficam** as UBS, escolas, bibliotecas, feiras,
> praças e muito mais? Pois é exatamente isso que este projeto faz! 🦾✨

## O que é isso? 🧐

O **GeoSampa** é o mapa digital oficial da Prefeitura (aquele site de mapas com
centenas de camadas). O site em si não deixa robôs entrarem, mas as **portas dos
fundos** — os serviços web abertos — entregam os dados de verdade para qualquer
um. A gente entra por essas portas e **garimpa os equipamentos públicos**:

- 🏥 **Saúde**: UBS, hospitais, pronto-socorros
- 🏫 **Educação**: escolas, CEUs, creches
- 🎭 **Cultura**: bibliotecas, museus, teatros
- ⚽ **Esporte**: clubes, centros esportivos, estádios
- 🍅 **Serviços**: feiras livres, mercados, wi-fi livre
- 🛡️ **Segurança**: delegacias, bombeiros, guarda civil
- 🤝 **Assistência**: CRAS, conselhos tutelares, Bom Prato

E cada tesouro sai em **dois formatos**: o **GeoJSON** (o mapa de verdade, em
metros — EPSG:31983) e o **CSV** (a planilha, com `latitude` e `longitude` em graus,
do jeito que o Google Maps entende).

📖 A história completa e cheia de detalhes está em **[DOCUMENTACAO.md](DOCUMENTACAO.md)**.

---

## Preparando a mochila 🎒

Requisitos: **R** (testado na 4.6.1) e alguns pacotes. Só na primeira vez:

```r
install.packages(c("httr", "jsonlite", "sf", "readr", "xml2"))
```

---

## Passo a passo — do zero ao tesouro 🚀

### Passo 1: entre na caverna do projeto 🕳️

No R ou no RStudio, a partir da pasta do projeto:

```r
setwd("/home/paulo/Documentos/meus_codigos/ph_codes/R/geosampa")
```

> 💡 No RStudio é ainda mais fácil: `Session > Set Working Directory > To Project Directory`.

### Passo 2: carregue as ferramentas do garimpeiro 🧰

Use o atalho (ele acha a pasta certa sozinho e carrega tudo **em silêncio** —
nada de aquela chuva de `[[1]]`, `[[2]]`, `[[3]]...` na tela):

```r
source("scripts/carregar_funcoes.R")
```

Deve aparecer: `✅ Funções do GeoSampa carregadas! Boa garimpagem! 🗺️✨`

> 🔁 Preferia o jeito antigo? `invisible(lapply(list.files("R", full.names = TRUE, pattern = "\\.R$"), source))`
> faz a mesma coisa. O `invisible()` só esconde aquele monte de números de `[[ ]]`.

### Passo 3: mãos à obra! 🔥

Veja o que existe, baixe, garimpe tudo:

```r
gs_catalogo_equipamentos()                        # o cardápio completo de camadas
gs_baixar_servicos("saude")                       # baixa TODAS as camadas de saúde
gs_baixar_camada("equipamento_cultura_bibliotecas") # baixa só as bibliotecas
gs_baixar_todos_equipamentos()                    # baixa TUDO (o grande garimpo!)
gs_metadados("UBS")                               # procura o "RG" das camadas
```

Pronto! Os arquivos caem na pasta `data/`:

```
data/
├── equipamento_saude_ubs_posto_centro.geojson   🗺️ o mapa
├── equipamento_saude_ubs_posto_centro.csv       📊 a planilha com lat/long
└── ... (mais de 80 pares de arquivos)
```

---

## O manual das ferramentas 🧰

| Função | O que faz | Exemplo |
|--------|-----------|---------|
| `gs_catalogo_equipamentos()` | Mostra o "cardápio" de equipamentos | `gs_catalogo_equipamentos()` |
| `gs_baixar_servicos(tema)` | Baixa um tema inteiro | `gs_baixar_servicos("educacao")` |
| `gs_baixar_camada(camada)` | Baixa uma camada específica | `gs_baixar_camada("equipamento_feira_livre")` |
| `gs_baixar_todos_equipamentos()` | Baixa **tudo** de uma vez | `gs_baixar_todos_equipamentos()` |
| `gs_buscar_camadas("termo")` | Procura camadas por palavra-chave | `gs_buscar_camadas("ceu")` |
| `gs_metadados("UBS")` | Acha os metadados (RG dos dados) | `gs_metadados("UBS")` |
| `gs_metadado_registro(uuid)` | Mostra o RG completo (título, resumo, órgão) | `gs_metadado_registro("12f1...")` |

### Bônus: abrindo os tesouros baixados 🧑‍🔬

```r
# O mapa (GeoJSON)
ubs <- sf::st_read("data/equipamento_saude_ubs_posto_centro.geojson")

# Ou a planilha, com latitude/longitude prontas
tab <- readr::read_csv("data/equipamento_saude_ubs_posto_centro.csv")
head(tab[, c("nm_equipamento", "nm_bairro_equipamento", "latitude", "longitude")])
```

---

## Sem abrir o R? Sem problema! 💻

Pode usar direto no terminal:

```bash
Rscript scripts/carregar_funcoes.R                          # só carrega as funções
Rscript scripts/baixar_tudo.R                               # baixa TUDO
Rscript scripts/baixar_tudo.R saude                         # baixa só saúde
Rscript scripts/baixar_tudo.R educacao esporte              # educação e esporte
Rscript scripts/baixar_tudo.R --camada equipamento_saude_ubs_posto_centro   # uma camada
```

---

## Estrutura do baú 📦

```
geosampa/
├── R/
│   ├── 00_config.R        → endereços, projeções e pastas
│   ├── gs_camadas.R       → o cardápio de camadas (GetCapabilities)
│   ├── gs_baixar.R        → o garimpo de verdade (WFS → GeoJSON + CSV)
│   └── gs_metadados.R     → os "RGs" das camadas (GeoNetwork)
├── scripts/
│   ├── carregar_funcoes.R → atalho: carrega tudo em silêncio
│   └── baixar_tudo.R      → o botão "baixar tudo" do terminal
├── data/                  → os tesouros baixados (GeoJSON + CSV)
├── DOCUMENTACAO.md        → a história completa, capítulo por capítulo
└── README.md              → este guia rapidinho
```

---

## Fontes oficiais 📚

- Portal GeoSampa: https://geosampa.prefeitura.sp.gov.br
- Tutorial: https://geoinfo-smdu.github.io/tutorial-GeoSampa/
- Metadados: https://metadados.geosampa.prefeitura.sp.gov.br
- WFS (os dados): https://wfs.geosampa.prefeitura.sp.gov.br/geoserver/geoportal/wfs
- Projeção oficial: SIRGAS2000 / UTM 23S — **EPSG:31983**

Dados abertos da **Prefeitura de São Paulo — Geoinfo (SMUL)**.

**Boa garimpagem!** 🗺️✨
