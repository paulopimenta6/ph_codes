# NLP com spaCy e NLTK

Este projeto documenta estudos práticos de Processamento de Linguagem Natural (NLP) utilizando as bibliotecas **spaCy 3.x** e **NLTK**, com suporte aos idiomas português (`pt_core_news_sm`) e inglês (`en_core_web_sm`).

## Tecnologias

- **spaCy 3.8.14** — pipeline de NLP industrial
- **NLTK 3.10.0** — toolkit clássico para PLN
- Modelos: `en_core_web_sm` (inglês) e `pt_core_news_sm` (português)

## Tópicos abordados

### 1. Carregamento de modelos

Carregamento dos modelos treinados do spaCy para processar textos em português e inglês:

```python
nlp_pt = spacy.load('pt_core_news_sm')
nlp_en = spacy.load('en_core_web_sm')
```

### 2. Part-of-Speech (POS) Tagging

Identificação da classe gramatical de cada token (substantivo, verbo, adjetivo, etc.) em ambos os idiomas.

### 3. Análise morfológica detalhada

Para cada token, são extraídos:
- **Lemma** — forma canônica da palavra
- **POS** — classe gramatical simplificada
- **TAG** — etiqueta gramatical detalhada
- **Dep** — função sintática (dependência)
- **Shape** — padrão de maiúsculas/minúsculas
- **is_alpha** — se é alfabético
- **is_stop** — se é stop word

### 4. Componentes do pipeline spaCy

Comparação dos pipes disponíveis em cada modelo:

| Inglês | Português |
|--------|-----------|
| tok2vec | tok2vec |
| tagger | morphologizer |
| parser | parser |
| attribute_ruler | lemmatizer |
| lemmatizer | attribute_ruler |
| ner | ner |

### 5. Lematização

Redução de palavras à sua forma base (ex.: "correndo" → "correr", "gatos" → "gato").

### 6. Stemming (NLTK)

Utilização dos algoritmos **Porter Stemmer** e **Snowball Stemmer** para redução de radicais em inglês e português.

### 7. Reconhecimento de Entidades Nomeadas (NER)

Identificação de entidades como:
- `PERSON`, `ORG`, `GPE` (local), `DATE`, `TIME`, `MONEY`, `PERCENT`, `NORP`

### 8. Stop words

Lista de stop words do inglês do spaCy e verificação de tokens individuais.

### 9. Dependência sintática

Navegação pela árvore de dependências:
- **Ancestors** — palavras das quais o token depende
- **Children** — filhos sintáticos
- **Head** — palavra principal

### 10. Visualização com displaCy

Renderização interativa da árvore de dependências:

```python
displacy.render(doc, style="dep", jupyter=True)
displacy.serve(doc, style="dep", port=5000)
```

## Como executar

```bash
# Criar ambiente virtual
python -m venv .venv

# Ativar (Linux/macOS)
source .venv/bin/activate

# Instalar dependências
pip install -r requirements.txt

# Baixar modelos spaCy (se necessário)
python -m spacy download en_core_web_sm
python -m spacy download pt_core_news_sm

# Abrir o notebook
jupyter notebook nltk.ipynb
```

## Arquivos

```
nltk/
├── nltk.ipynb    # Notebook principal com os experimentos
├── README.md     # Esta documentação
└── .gitignore
```

## Pré-requisitos

- Python 3.11+
- Dependências listadas em `requirements.txt` (na pasta `python/nltk/`)
