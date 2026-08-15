# GeoSampa — Baixador de Equipamentos Públicos 🗺️

Sistema em **R** que baixa dados do portal **GeoSampa** (Prefeitura de São Paulo)
sobre **localidades que prestam serviços**: UBS, hospitais, escolas, CEUs, CRAS,
bibliotecas, museus, centros esportivos, feiras livres, praças e mais.

A documentação completa e lúdica está em **[DOCUMENTACAO.md](DOCUMENTACAO.md)**.

## Como funciona

O site interativo do GeoSampa bloqueia robôs, mas os **serviços web oficiais** (WFS)
são abertos. O sistema usa o WFS para baixar camadas vetoriais em **GeoJSON**
(projeção oficial SIRGAS2000/UTM 23S — EPSG:31983) e gera também **CSV** com
colunas `latitude`/`longitude` (WGS84). Metadados são consultados no catálogo GeoNetwork.

## Requisitos

- R (testado na 4.6.1) com pacotes: `httr`, `jsonlite`, `sf`, `readr`, `xml2`

```r
install.packages(c("httr", "jsonlite", "sf", "readr", "xml2"))
```

## Uso rápido

Carregue as funções a partir da raiz do projeto:

```r
lapply(list.files("R", full.names = TRUE, pattern = "\\.R$"), source)

gs_catalogo_equipamentos()              # ver camadas de equipamentos
gs_baixar_servicos("saude")             # baixar um tema
gs_baixar_camada("equipamento_cultura_bibliotecas")  # uma camada
gs_baixar_todos_equipamentos()          # baixar tudo
gs_metadados("UBS")                     # consultar metadados
```

Ou pelo terminal:

```bash
Rscript scripts/baixar_tudo.R                 # tudo
Rscript scripts/baixar_tudo.R saude           # só saúde
Rscript scripts/baixar_tudo.R --camada equipamento_saude_ubs_posto_centro
```

## Saída

Os arquivos vão para `data/`:

- `data/<camada>.geojson` — mapa vetorial (EPSG:31983)
- `data/<camada>.csv` — tabela com latitude/longitude em graus

## Estrutura

```
R/00_config.R        endereços, projeções e pastas
R/gs_camadas.R       catálogo de camadas (GetCapabilities)
R/gs_baixar.R        download WFS → GeoJSON + CSV
R/gs_metadados.R     consulta ao catálogo de metadados
scripts/baixar_tudo.R   baixador executável
data/                dados baixados
DOCUMENTACAO.md      documentação em linguagem acessível
```

## Fontes

- GeoSampa: https://geosampa.prefeitura.sp.gov.br
- Tutorial: https://geoinfo-smdu.github.io/tutorial-GeoSampa/
- Metadados: https://metadados.geosampa.prefeitura.sp.gov.br
- WFS: https://wfs.geosampa.prefeitura.sp.gov.br/geoserver/geoportal/wfs

Dados abertos da Prefeitura de São Paulo — Geoinfo (SMUL).