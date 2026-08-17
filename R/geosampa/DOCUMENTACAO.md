# 🗺️ O Baú de Tesouros do GeoSampa

> Uma viagem divertida para entender o que é o GeoSampa, o que tem lá dentro
> e como criamos um "garimpeiro robô" que baixa dados de equipamentos públicos
> da cidade de São Paulo — tudo com linguagem simples e exemplos prontos.

---

## 1. Era uma vez... a cidade de São Paulo

São Paulo tem mais de **11 milhões de habitantes**, **310 setores**, **55 mil quadras**
e **2,5 milhões de lotes**. Para cuidar de uma cidade tão gigante, a Prefeitura precisa
saber **onde** estão as coisas: onde tem posto de saúde, escola, biblioteca, praça,
parque, feira livre, hospital... Isso é chamado de **dado geográfico**: um dado que
tem um **endereço no mapa** (coordenadas), além de informações como nome, telefone e
horário de funcionamento.

Mas onde a Prefeitura guarda tudo isso? Num lugar muito especial chamado...

## 2. O GeoSampa: o mapa digital da cidade 🏙️

O **GeoSampa** é o portal de mapas da Prefeitura de São Paulo, disponível em
[geosampa.prefeitura.sp.gov.br](https://geosampa.prefeitura.sp.gov.br). Pense nele
como um **baú de tesouros cartográficos**: lá dentro existem **mais de 300 camadas
de informações** sobre a cidade — saúde, educação, transporte, zoneamento, IPTU,
riscos, vegetação e muito mais.

Imagine cada camada como uma **folha transparente** desenhada em cima do mapa da cidade:

- Uma folha com todos os postos de saúde 🏥
- Outra com as escolas 🏫
- Outra com as praças e parques 🌳
- Outra com as feiras livres 🍅

Junte todas as folhas e você tem a cidade completa em detalhes!

### Como funciona por dentro

O GeoSampa foi construído com tecnologias abertas (GeoServer + OpenLayers) e usa
padrões internacionais chamados **OGC**. O importante para nós são os **serviços web**,
que são como "portas" por onde os dados saem do baú. São duas portas principais:

| Porta | Nome | O que ela entrega? | Analogia |
|-------|------|---------------------|----------|
| 🖼️ | **WMS** (Web Map Service) | Imagens do mapa | Um **espelho**: mostra, mas você não pode tocar |
| 🗄️ | **WFS** (Web Feature Service) | Os dados de verdade (vetores) | Um **baú**: abre e você pega os dados |

- **WMS** serve imagens prontas (mapas). Útil para olhar, mas não dá para cruzar dados.
- **WFS** entrega os **dados brutos** com coordenadas. É por aqui que o nosso
  "garimpeiro robô" entra! 🦾

> ⚠️ Curiosidade: a página visual do GeoSampa tem uma trava de segurança (um desafio
> de JavaScript) que impede robôs de entrarem pela porta da frente. Por isso, a
> maneira correta e **oficial** de baixar dados é usar as portas WMS/WFS — que são
> abertas a qualquer pessoa. É exatamente o que nosso sistema faz.

### O idioma dos mapas (projeção cartográfica) 🌐

Coordenadas no mapa são como um "idioma". O GeoSampa fala vários idiomas, mas o
**oficial** (desde 2014) é o **SIRGAS2000 / UTM 23S**, código **EPSG:31983**.

- **EPSG** é um catálogo mundial que dá números para cada "idioma" de coordenadas.
- UTM 23S é um jeito de "achatar" a região de São Paulo para medir em **metros**.
- Para planilhas, costumamos converter para **WGS84 (EPSG:4326)**, que usa
  **latitude e longitude em graus** — o formato que o Google Maps entende.

Nosso sistema respeita os dois idiomas:
- O arquivo **.geojson** fica no idioma oficial (EPSG:31983), perfeito para GIS.
- O arquivo **.csv** ganha colunas `latitude` e `longitude` em graus (EPSG:4326),
  fácil de abrir em qualquer planilha.

---

## 3. E os "documentos de identidade" dos dados? (Metadados) 📇

Toda camada de dados tem um **metadado** — que significa literalmente **"dados sobre
os dados"**. É o RG da camada: diz quem produziu, do que se trata, desde quando
existe, em que escala, qual a periodicidade de atualização.

O GeoSampa mantém esses documentos num **Catálogo de Metadados Geográficos**
(baseado no software livre **GeoNetwork**), disponível em
[metadados.geosampa.prefeitura.sp.gov.br](https://metadados.geosampa.prefeitura.sp.gov.br).

Quando você pesquisa uma camada, o catálogo devolve um **UUID** (uma "impressão
digital" única) e um registro com **título, resumo e órgão responsável**. Isso é
importante para você saber **em quem confiar** na hora de usar o dado.

---

## 4. Nossa missão: o "Garimpeiro de Equipamentos" 🦾

A Prefeitura disponibiliza camadas de **equipamentos públicos** — todos aqueles
pontos da cidade que prestam serviços: UBS, hospitais, CEUs, escolas, CRAS,
bibliotecas, museus, centros esportivos, feiras livres, mercados, praças, e por
aí vai. São **47 camadas** e mais de **18 mil equipamentos**!

Criamos um sistema em **R** que:

1. 🗂️ **Pergunta ao GeoSampa** quais camadas existem (via GetCapabilities).
2. 🔍 **Acha** as camadas de equipamentos (as que têm o prefixo `equipamento_`).
3. ⬇️ **Baixa** cada uma pelo WFS, em páginas (para não sobrecarregar o servidor).
4. 💾 **Salva** em dois formatos: **GeoJSON** (o mapa) e **CSV** (a tabela).
5. 📇 **Consulta os metadados** das camadas no catálogo.

### Onde mora o código

```
geosampa/
├── R/
│   ├── 00_config.R        → endereços, projeções e pastas
│   ├── gs_camadas.R       → catálogo de camadas (GetCapabilities)
│   ├── gs_baixar.R        → o download de verdade (WFS → GeoJSON + CSV)
│   └── gs_metadados.R     → consulta ao catálogo de metadados
├── scripts/
│   └── baixar_tudo.R      → o botão "baixar tudo"
├── data/                  → os tesouros baixados (GeoJSON + CSV)
├── DOCUMENTACAO.md        → este documento
└── README.md              → guia rápido
```

### As ferramentas do garimpeiro 🧰

| Função | O que faz |
|--------|-----------|
| `gs_camadas_disponiveis()` | Lista todas as camadas que o GeoSampa oferece |
| `gs_catalogo_equipamentos()` | Mostra só as camadas de equipamentos públicos |
| `gs_buscar_camadas("saude")` | Procura camadas por palavra-chave |
| `gs_baixar_camada("...ubs...")` | Baixa uma camada inteira |
| `gs_baixar_servicos("saude")` | Baixa todas as camadas de um tema |
| `gs_baixar_todos_equipamentos()` | Baixa tudo! (o grande garimpo) |
| `gs_metadados("UBS")` | Procura registros de metadados |
| `gs_metadado_registro(uuid)` | Mostra o "RG" completo de uma camada |

---

## 5. Passo a passo para você usar 🚀

### Antes de começar

Rode o R a partir da pasta do projeto e carregue as funções:

```r
# Carrega todas as funções do projeto
lapply(list.files("R", full.names = TRUE, pattern = "\\.R$"), source)
```

### Exemplo 1: ver o que existe

```r
# Todas as camadas de equipamentos e seus temas
gs_catalogo_equipamentos()
```

### Exemplo 2: baixar um tema (saúde, por exemplo)

```r
gs_baixar_servicos("saude")
```

Os arquivos caem em `data/`:

- `data/equipamento_saude_ubs_posto_centro.geojson` (o mapa)
- `data/equipamento_saude_ubs_posto_centro.csv` (a tabela)

### Exemplo 3: baixar UMA camada específica

```r
gs_baixar_camada("equipamento_cultura_bibliotecas")
```

### Exemplo 4: baixar TUDO de uma vez

```r
gs_baixar_todos_equipamentos()
```

Ou, direto pelo terminal:

```bash
Rscript scripts/baixar_tudo.R            # tudo
Rscript scripts/baixar_tudo.R saude      # só saúde
Rscript scripts/baixar_tudo.R educacao esporte   # educação e esporte
```

### Exemplo 5: consultar metadados

```r
reg <- gs_metadados("UBS")
reg$uuid            # a "impressão digital" do registro
gs_metadado_registro(reg$uuid[1])   # o RG completo (título, resumo, órgão)
```

### Exemplo 6: abrir os dados baixados

```r
ubs <- sf::st_read("data/equipamento_saude_ubs_posto_centro.geojson")

# ... ou em forma de tabela (CSV), com latitude/longitude prontas:
tab <- readr::read_csv("data/equipamento_saude_ubs_posto_centro.csv")
head(tab[, c("nm_equipamento", "nm_bairro_equipamento", "latitude", "longitude")])
```

> 💡 **Dica de bairro**: quer filtrar UBS por tipo? Use o filtro do WFS:
> ```r
> gs_baixar_camada("equipamento_saude_ubs_posto_centro",
>                  filtro = "nm_tipo_equipamento LIKE '%Centro%'")
> ```

---

## 6. O que já está no baú 📦

Rodamos o sistema e o baú ficou assim (em `data/`):

| Tema | Camadas | Alguns exemplos |
|------|---------|-----------------|
| 🏥 Saúde | 12 | UBS, hospitais, urgência/emergência, saúde mental, DST/AIDS |
| 🏫 Educação | 7 | CEU, ensino fundamental/médio, educação infantil, ensino técnico |
| 🎭 Cultura | 5 | Bibliotecas, museus, teatros/cinema, espaços culturais |
| ⚽ Esporte | 5 | Centros esportivos, clubes, clubes da comunidade, estádios |
| 🤝 Assistência social | + | CRAS, conselhos tutelares, Bom Prato, casa mediação |
| 🍅 Serviços urbanos | + | Feiras livres, mercados, sacolões, wi-fi livre, shoppings |
| 🛡️ Segurança | + | Polícia civil, polícia militar, bombeiros, guarda civil |
| 🌳 Espaços verdes | + | Praças e largos, parques |

**Números reais do último garimpo:**
- ✅ **47 camadas** baixadas com sucesso
- 📊 **18.512 equipamentos** catalogados
- 💾 **54 MB** de dados (47 GeoJSON + 47 CSV)

> 💡 Nem toda camada chamada de "equipamento" pelo sistema é um ponto de serviço
> no sentido clássico (por exemplo, há camadas de abrangência/cobertura e de
> coordenação regional). Confira o `tema` e o `titulo` no catálogo
> (`gs_catalogo_equipamentos()`) para escolher as que interessam.

---

## 7. Como o download funciona por dentro 🔧

Quando você pede para baixar uma camada, o robô:

1. **Conta** quantos registros existem (uma consulta rápida).
2. **Busca em páginas** de 1.000 registros (para ser gentil com o servidor).
   - ⚠️ Se uma camada não tem chave primária, o GeoServer reclama de paginação.
     Nosso código detecta isso e ordena por um atributo estável (por exemplo,
     `cd_identificador`) — e se ainda assim não der, busca tudo de uma vez.
3. **Junta** todas as páginas num único GeoJSON (na projeção oficial EPSG:31983).
4. **Converte** para CSV adicionando `latitude` e `longitude` em graus (EPSG:4326).

Detalhe importante: o WFS devolve um campo `numberMatched` dizendo quantos
registros existem — é assim que o robô sabe quando parar de buscar.

---

## 8. Respeito e boas práticas 🤝

- Os dados do GeoSampa são **abertos** (o portal usa licença de dados abertos),
  mas é sempre bom citar a fonte: **Prefeitura de São Paulo / Geoinfo (SMUL)**.
- Consulte o **metadado** da camada antes de usá-la em análises sérias — ele
  informa escala, atualização e órgão responsável.
- Não faça download em rajada: nosso sistema já pausa entre páginas. Se for
  baixar muitas camadas de uma vez, dê um tempo entre execuções.

---

## 9. Fontes oficiais 📚

| O quê | Onde |
|-------|------|
| Tutorial do GeoSampa | https://geoinfo-smdu.github.io/tutorial-GeoSampa/ |
| Portal GeoSampa | https://geosampa.prefeitura.sp.gov.br |
| Catálogo de Metadados | https://metadados.geosampa.prefeitura.sp.gov.br |
| Serviço WFS (camadas) | https://wfs.geosampa.prefeitura.sp.gov.br/geoserver/geoportal/wfs |
| Serviço WMS (imagens) | https://wms.geosampa.prefeitura.sp.gov.br/geoserver/geoportal/wms |
| Projeção oficial | SIRGAS2000 / UTM 23S — EPSG:31983 |

---

## 10. Bônus: o módulo de CEP, serviços próximos, mapas e análises 🌟

Além de garimpar os tesouros, o GeoSampa agora sabe responder: *"este CEP bate
com esta coordenada?"*, *"o que tem por perto deste CEP?"* e *"como estão
distribuídos os serviços?"* Tudo isso com funções novas na pasta `R/`.

### Como um CEP vira uma coordenada?

Em **cascata de fontes** (a primeira que der certo vence):

1. **Índice local**: os próprios `data/*.csv` já trazem CEP + latitude/
   longitude dos equipamentos públicos — mais de **7 mil CEPs** de São Paulo.
   Vantagem: offline, instantâneo e gratuito.
2. **viaCEP** (`viacep.com.br`): valida o CEP e devolve o endereço
   (logradouro, bairro, cidade, UF e IBGE). Não exige chave.
3. **Nominatim/OSM**: geocodifica o CEP pelo código postal quando ele não está
   no índice local. A política de uso pede um `User-Agent` identificado e
   **~1 consulta por segundo** — o código já respeita isso.

### As novas ferramentas 🧰

| Função | O que faz |
|--------|-----------|
| `gs_indice_cep()` | Monta o índice local CEP → coordenadas a partir de `data/` |
| `gs_ler_cep(cep)` | Valida o CEP e devolve o endereço via viaCEP |
| `gs_cep_para_coordenadas(cep)` | Lat/long do CEP (índice local → Nominatim) |
| `gs_verificar_cep(cep, lat, lon)` | Confere se a coordenada bate com o CEP (tolerância padrão 300 m) |
| `gs_servicos_proximos(cep\|coordenadas, camadas, raio_m, ...)` | Serviços dentro do raio, mais próximos primeiro |
| `gs_tipos_distancia()` | Documenta as métricas de distância |
| `gs_mapa_servicos(...)` | Mapa estático (ggplot2 → PNG/PDF) ou interativo (leaflet → HTML) |
| `gs_analise_servicos(..., tipo)` | Análises estatísticas e espaciais escolhidas pelo usuário |

### Tipos de distância 📏

| Tipo | Descrição | Quando usar |
|------|-----------|-------------|
| `geodesica` (padrão) | Elipsoidal via `sf::st_distance` em CRS geográfico | Referência, mais precisa |
| `euclidiana` | Metros na projeção UTM/SIRGAS2000 (EPSG:31983) | Rápida, boa até ~20 km |
| `haversine` | Aproximação esférica sobre WGS84 | Leve, sem transformar CRS |
| `manhattan` | \|Δx\| + \|Δy\| em metros projetados | "Caminhabilidade" em quadrículas |
| `rede_viaria` | Rota real de carro via OSRM | Requer pacote `osrm` (opcional) |

> 💡 Para "a pé" ou "de carro" no sentido real (ruas, quarteirões), a métrica
> mais realista é a de **rede viária (OSRM)**, que usa o grafo de ruas. As
> demais são "linha reta" e servem para raios e comparações rápidas.

### Análises estatísticas e espaciais 📊

| Tipo | O que devolve |
|------|---------------|
| `descritivas` | Contagens por tipo/camada, resumo, histograma e boxplot das distâncias |
| `vizinho_mais_proximo` | Distância ao serviço mais próximo (geral e por camada) |
| `voronoi` | Polígonos de Thiessen: áreas de influência de cada serviço |
| `kde` | Mapa de densidade de kernel dos serviços |
| `raios_progressivos` | Oportunidades acumuladas em 500 m, 1 km e 2 km |
| `moran` | Moran's I (autocorrelação espacial) — requer `spdep` |
| `rede_viaria` | Distância de percurso comparada à linha reta — requer `osrm` |

Os tipos `moran` e `rede_viaria` dependem de pacotes opcionais. Se o pacote
não estiver instalado, a função **não quebra**: devolve uma mensagem
orientando a instalação.

### Exemplo completo 🚀

```r
# 1) Conferir se a coordenada bate com o CEP da UBS Água Rasa
gs_verificar_cep("03175-001", -23.553640, -46.580180)

# 2) Achar os serviços de saúde e bombeiros a até 2 km do CEP
proximos <- gs_servicos_proximos(
  cep     = "03175-001",
  raio_m  = 2000,
  camadas = c("equipamento_saude_ubs_posto_centro", "equipamento_bombeiros")
)
head(proximos[, c("camada", "nome", "distancia_m")])

# 3) Gerar mapas (HTML interativo e PNG estático)
gs_mapa_servicos(proximos, interativo = TRUE,  salvar = "mapas/cep_03175001.html")
gs_mapa_servicos(proximos, interativo = FALSE, salvar = "mapas/cep_03175001.png")

# 4) Análises descritivas + oportunidades por raio
analises <- gs_analise_servicos(proximos, tipo = c("descritivas", "raios_progressivos"))
analises$raios_progressivos
```

### Limitações conhecidas ⚠️

- O índice local cobre apenas os CEPs dos equipamentos públicos (≈7 mil) —
  CEPs fora dele precisam de internet (viaCEP + Nominatim).
- Um CEP de faixa de rua pode ter várias coordenadas; a verificação usa a
  ocorrência mais próxima.
- CEP de caixa postal não tem coordenada útil.
- O servidor demo do OSRM tem cobertura e limites próprios.

---

## 11. Ideias de próximos passos 🌟

- 🧭 Cruzar os equipamentos com camadas de distritos/subprefeituras para saber
  **quais regiões têm e quais não têm** determinado serviço.
- 🗺️ Gerar mapas temáticos com `ggplot2` ou `tmap` a partir dos GeoJSON.
- 🧮 Calcular distâncias de cada casa ao serviço mais próximo.
- 🔁 Automatizar o download com agendamento (ex.: `cron`) para manter a base atualizada.

**Boa garimpagem!** 🗺️✨