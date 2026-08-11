# OpenCode + Headroom: O Manual do Explorer Iniciante

> **Bem-vindo(a), Explorer!** 👋
>
> Você está prestes a embarcar em uma jornada para dominar duas ferramentas que
> vão **transformar a forma como você programa com Inteligência Artificial**.
>
> Neste manual, a gente não vai usar nenhum "jargão assustador". A gente vai
> construir o entendimento **do zero**, com analogias, desenhos e muita calma.
> Se um dia eu fui iniciante também, você vai ser, no máximo, por mais algumas
> páginas. 😉

---

## 📖 Como navegar neste manual

| Capítulo | O que você vai aprender | Nível |
|----------|------------------------|-------|
| [0 · Conceitos básicos](#-capítulo-0--os-conceitos-que-todo-mundo-pula) | Tokens, contexto, API, proxy e MCP | 🍼 Bebê Explorer |
| [1 · OpenCode](#-capítulo-1--opencode-o-seu-companheiro-de-código-no-terminal) | O que é e como usar o agente de IA | 🚀 Primeiros passos |
| [2 · Headroom](#-capítulo-2--headroom-o-compactador-mágico-de-contexto) | O que é e como funciona a magia | 🎩 Mágico aprendiz |
| [3 · `headroom wrap opencode`](#-capítulo-3--headroom-wrap-opencode-o-comando-que-une-tudo) | O comando que integra os dois | ⚡ A parte mais legal |
| [4 · Por baixo do capô](#-capítulo-4--por-baixo-do-capô-o-que-acontece-em-segredo) | O que o wrap faz em segredo | 🔬 Curioso |
| [5 · Integração manual](#-capítulo-5--integração-manual-para-os-meticulosos) | Configurar na mão (opencode.json) | 🧰 Artesão |
| [6 · Ferramentas MCP do Headroom](#-capítulo-6--as-ferramentas-mcp-do-headroom) | `compress`, `retrieve` e `stats` | 🧰 Artesão |
| [7 · Comandos do dia a dia](#-capítulo-7--comandos-do-dia-a-dia) | `doctor`, `savings`, `dashboard`, `memory`... | 🗓️ Rotina |
| [8 · Problemas comuns](#-capítulo-8--problemas-comuns-e-soluções) | Troubleshooting amigável | 🚨 Resgate |
| [9 · Glossário lúdico](#-capítulo-9--glossário-lúdico) | Dicionário do Explorer | 📚 Referência |
| [⚡ Cheatsheet final](#-cheatsheet-rápido) | Cola rápida de comandos | 🏁 Conclusão |

**Não precisa ler tudo de uma vez.** Pule entre os capítulos como um explorer de
verdade. Mas se você é 100% iniciante, recomendo começar pelo Capítulo 0 — ele
é a fundação da casa.

---

## 🍼 Capítulo 0 · Os conceitos que todo mundo pula

Antes de falar de qualquer ferramenta, a gente precisa concordar sobre **cinco
palavrinhas**. Elas vão aparecer o tempo todo. Vamos desmistificá-las:

### 0.1 Token: a moedinha da IA 🪙

Uma IA (modelo de linguagem) não lê palavras como a gente. Ela lê **pedacinhos
de texto** chamados **tokens**.

- A frase `"Hello world"` vira algo como: `Hello` e ` world` (2 tokens).
- Regra de bolso: **1 token ≈ ¾ de uma palavra** em inglês (em português, é
  parecido).

**Por que isso importa?** Porque as IAs **cobram por token** e têm um limite de
tokens por conversa. É como uma máquina de fliperama: cada token é uma ficha 🪙.

### 0.2 Janela de contexto: a sua mochila 🎒

Toda conversa com uma IA tem um limite de "coisas que cabem" na memória da
sessão. Isso é a **janela de contexto** (context window).

Imagine uma **mochila de trilha**:

- Você coloca nela: sua pergunta, os arquivos que o agente leu, a saída de
  comandos, resultados de buscas...
- Se a mochila enche, a conversa **quebra** ou o agente começa a **esquecer**
  coisas importantes (ele corta o que estava no fundo).
- Cada modelo tem um tamanho de mochila: `128.000` tokens, `200.000` tokens...

> 🎯 **É aqui que o Headroom entra.** Ele é o "compactador a vácuo" da sua
> mochila: espreme o conteúdo para caber muito mais coisa. Spoiler do tutorial.

### 0.3 API: o telefone que fala com a IA 📞

Uma **API** é um "telefone" padronizado. O seu programa liga para o servidor da
IA e diz: *"oi, quero completar essa conversa com esses tokens"*. O servidor
responde. Cada empresa (OpenAI, Anthropic, Google...) tem o próprio número
(endereço).

### 0.4 Proxy: o porteiro que filtra 🚪

Um **proxy** é um serviço que fica **entre** você e o servidor final. Todo o
"telefone" passa por ele.

```
Você  ──►  PROXY  ──►  IA
              │
              └── pode modificar o que passa (comprimir, registrar, medir)
```

É como um porteiro de prédio que **abre sua correspondência**, remove a
"embalagem desnecessária" e entrega só o essencial para a IA. O endereço
final continua o mesmo.

### 0.5 MCP: tomadas universais para ferramentas 🔌

MCP (**Model Context Protocol**) é um padrão aberto para conectar IAs a
**ferramentas** (buscar arquivos, rodar comandos, acessar bancos...). Pense em
**tomadas elétricas universais**: em vez de cada IA inventar um plug diferente,
todas usam o mesmo padrão.

O Headroom usa o MCP para dar à IA ferramentas como `headroom_retrieve` (buscar
o conteúdo original que foi comprimido). Veremos isso no Capítulo 6.

---

## 🚀 Capítulo 1 · OpenCode: o seu companheiro de código no terminal

### 1.1 O que é o OpenCode?

O **OpenCode** é um **agente de IA de código aberto** que roda **dentro do seu
terminal**. Ele é o "piloto automático" do seu projeto:

- Você conversa com ele em linguagem natural ("corrija esse bug", "explique
  esse arquivo", "escreva testes para isso").
- Ele **lê o código, busca arquivos, edita, roda comandos** e te mostra o que
  fez.
- Tudo acontece no seu próprio computador, com a sua conta/API key.

Versões: terminal (TUI), app desktop, extensão de IDE e até no navegador. Neste
tutorial, o foco é o **terminal**.

```
┌──────────────────────────────────────────────────────────────┐
│  █▀▀█ █▀▀█ █▀▀█ █▀▀▄  (logo do OpenCode)                     │
│  █ ██ █ ██ █ ██ █  █                                        │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ Ask anything... "Explique este repositório"            │  │
│  │                                                        │  │
│  │ Build · Claude Sonnet 4.6 · DeepSeek V4 Flash Free     │  │
│  └────────────────────────────────────────────────────────┘  │
│  tab  agents     ctrl+p  commands                            │
└──────────────────────────────────────────────────────────────┘
```

### 1.2 Instalando o OpenCode

O jeito mais fácil é com o script oficial:

```bash
curl -fsSL https://opencode.ai/install | bash
```

Ou, se você já usa Node.js:

```bash
npm install -g opencode-ai        # ou: bun install -g opencode-ai
```

No macOS/Linux também dá via Homebrew:

```bash
brew install anomalyco/tap/opencode
```

Confirme que instalou:

```bash
opencode --version
# exemplo de saída: 1.18.13
```

### 1.3 Primeiros passos: sua primeira missão 🗺️

1. Entre na pasta de um projeto:
   ```bash
   cd /caminho/para/meu/projeto
   ```

2. Rode o OpenCode:
   ```bash
   opencode
   ```

3. **Conecte um modelo de IA** (a primeira vez):
   - Digite `/connect` e escolha um provedor (OpenAI, Anthropic, etc.).
   - Cole sua API key. Pronto! Você está falando com uma IA dentro do terminal.

4. **Apresente o projeto para a IA**:
   - Digite `/init`. O OpenCode analisa o código e cria um arquivo `AGENTS.md`
     com as "regras da casa" do projeto. **Compromete esse arquivo no Git!** 💡

5. **Pergunte qualquer coisa**:
   ```
   Como a autenticação funciona neste projeto?
   ```
   Use a tecla `@` para buscar arquivos por nome e "colá-los" na conversa:
   ```
   Explique o que faz @packages/functions/src/api/index.ts
   ```

### 1.4 Os dois modos de trabalho: Plan vs Build 📐🏗️

O OpenCode tem dois "chapéus" que você alterna com a tecla **Tab**:

| Modo | O que faz | Quando usar |
|------|-----------|-------------|
| **Plan** 📐 | Só **sugere** um plano, **não mexe em nada** | Quando quer entender/planejar antes |
| **Build** 🏗️ | **Executa**: edita arquivos, roda comandos | Quando aprova o plano e quer ação |

Fluxo de ouro do iniciante: **Planeje → revise → construa.**

```
Tab  →  Plan  (escreve o plano)
        "Faz sentido? Ajusta aqui..."
Tab  →  Build (executa o plano)
```

### 1.5 Comandos que vão salvar sua vida 🆘

| Comando | Efeito |
|---------|--------|
| `/init` | Cria o `AGENTS.md` do projeto |
| `/connect` | Conecta um provedor de IA |
| `/undo` | Desfaz a última mudança (dá pra usar várias vezes) |
| `/redo` | Refaz o que você desfez |
| `/share` | Gera um link para compartilhar a conversa |
| `/help` | Mostra ajuda dentro do TUI |
| `Tab` | Alterna entre Plan e Build |

### 1.6 Modo "uma vez só" (sem abrir a interface) ⚡

Você também pode usar o OpenCode como um comando único, ótimo para scripts:

```bash
opencode run "Corrija o bug de login"
```

### 1.7 Configuração: o `opencode.json`

O OpenCode se configura por arquivos `opencode.json` / `opencode.jsonc`:

- **Global:** `~/.config/opencode/opencode.json`
- **Do projeto:** `opencode.json` na raiz do projeto (vale mais que o global)

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "anthropic/claude-sonnet-4-6",
  "mcp": {
    "headroom": {
      "type": "local",
      "command": ["headroom", "mcp", "serve"],
      "enabled": true
    }
  }
}
```

> ⚠️ **Regra de ouro:** depois de mudar qualquer config, **feche e reabra o
> OpenCode**. Config só é lida na inicialização.

---

## 🎩 Capítulo 2 · Headroom: o compactador mágico de contexto

### 2.1 O problema: sua mochila está cheia de pedra 🪨

Quando um agente trabalha num projeto, ele acumula **muito** conteúdo:

- Saída de `grep` / busca com 100 resultados (90% repetição)
- Logs gigantescos
- Resultados de consultas em banco
- Respostas de APIs
- Arquivos inteiros lidos

**O dado chocante:** as saídas de ferramentas são **70% a 95% "embalagem
desnecessária"** (boilerplate). Você paga tokens por isso, enche a mochila por
isso e, no fim, a IA **descarta** por isso.

É como viajar com uma mochila cheia de pedras só porque cada uma "pode ser
útil". 🏔️

### 2.2 A solução: Headroom 🎩

> **Headroom é a "Camada de Otimização de Contexto" (Context Optimization Layer)
> para aplicações de LLM.**

Traduzindo: ele fica **entre o agente e a IA** e **comprime o contexto** antes
de chegar na IA. O agente não muda nada no código dele — e você economiza
**47% a 92% dos tokens** dependendo do tipo de trabalho.

```
     sem Headroom                          com Headroom
  ┌──────────────┐                       ┌──────────────┐
  │  🪨🪨🪨🪨🪨    │                       │  🧱🧱 (essencial) │
  │  100.000      │                       │   8.000 tokens │
  │  tokens       │                       │  + 🗄️ original  │
  └──────────────┘                       └──────────────┘
```

A frase de efeito do Headroom:

> **"Same answers. Fraction of the tokens."**
> *(Mesmas respostas. Uma fração dos tokens.)*

### 2.3 Como ele funciona? O trio mágico ✨

Internamente, o Headroom tem um pipeline de transformação:

```
 Saída da ferramenta (enorme)
        │
        ▼
 ┌───────────────────┐
 │ ① CacheAligner    │  Estabiliza timestamps, UUIDs, IDs — para o cache
 │                   │  da IA (Anthropic/OpenAI) funcionar de verdade.
 └───────────────────┘
        │
        ▼
 ┌───────────────────┐
 │ ② ContentRouter   │  Detecta o tipo do conteúdo (JSON, código, logs,
 │                   │  texto) e escolhe o compressor certo. Compressão
 │                   │  "AST-aware" para 6 linguagens.
 └───────────────────┘
        │
        ▼
 ┌───────────────────┐
 │ ③ IntelligentContext │  Ajusta o conteúdo ao orçamento de tokens,
 │                   │  com pontuação de importância. O original é
 │                   │  guardado em um armazém para recuperação.
 └───────────────────┘
        │
        ▼
  Payload comprimido → LLM
```

E o mais importante: **nada é jogado fora.** 🗄️

### 2.4 CCR: Compress-Cache-Retrieve (comprimir, guardar, recuperar) 🔁

O Headroom usa o padrão **CCR**:

1. **Comprimir** — espreme o conteúdo que vai para a IA.
2. **Cache** — guarda o original num armazém local (por hash).
3. **Recuperar** — quando a IA precisa do detalhe completo, ela chama a
   ferramenta `headroom_retrieve` e **busca o original**.

Isso é **compressão reversível**: o agente perde a gordura, mas nunca perde
informação. Ele só busca quando precisa.

Você já viu na prática um marcador de compressão. Dentro de conversas com o
Headroom, conteúdos grandes aparecem assim:

```
[134 items compressed to 104. Retrieve more: hash=abc123...]
```

O modelo (IA) lê o resumo e, se precisar do conteúdo inteiro, chama
`headroom_retrieve` com o hash e recebe tudo de volta. Mágico, né? 🪄

### 2.5 E o cache? Bônus de economia 🪙

As IAs cobram **muito menos** por tokens que já estão em cache (a Anthropic, por
exemplo, tem desconto de ~90% na leitura de cache). O `CacheAligner` arruma a
conversa para que o prefixo **bata no cache** — economia dupla:
menos tokens enviados **+** tokens em cache com desconto.

### 2.6 Instalando o Headroom

O Headroom é um pacote Python:

```bash
pip install "headroom-ai[proxy]"     # recomendado (proxy)
# ou, com tudo (memória, code-aware, etc.):
pip install "headroom-ai[all]"
```

Confirme:

```bash
headroom --version
# exemplo de saída: headroom, version 0.33.0
```

> 💡 Tem versão mais nova? Rode `headroom update`.

### 2.7 Seu primeiro "check-up": `headroom doctor` 🩺

```bash
headroom doctor
```

O doctor mostra a saúde do sistema: se o proxy está rodando, se sua ferramenta
está "roteada" pelo Headroom, quanto você já economizou:

```
┏━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ check       ┃ status ┃ summary                                ┃
┡━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
│ proxy       │ ✓ pass │ running at http://127.0.0.1:8787       │
│ version     │ ✓ pass │ proxy matches installed v0.33.0        │
│ savings     │ ✓ pass │ 281,479 tokens / $0.84 saved lifetime  │
└─────────────┴────────┴────────────────────────────────────────┘
```

**Códigos de saída:** `0` = tudo saudável · `1` = avisos · `2` = tem erro.

---

## ⚡ Capítulo 3 · `headroom wrap opencode`: o comando que une tudo

Chegamos ao coração do tutorial! ❤️

### 3.1 O que o comando faz (em 10 segundos)

```bash
headroom wrap opencode
```

Este **um comando** faz tudo isso:

1. 🚪 **Sobe o proxy do Headroom** (porta 8787 por padrão) se não estiver no ar;
2. 🎩 **Configura o OpenCode** para rotear todas as chamadas de IA **através do
   proxy** (compressed);
3. 🔌 **Registra o MCP do Headroom** (a ferramenta `retrieve`, o armazém);
4. 📦 **Injeta um provider `headroom`** no `opencode.json` (com backup);
5. ⚙️ **Define `OPENCODE_CONFIG_CONTENT`** e `HEADROOM_PROXY_URL` no ambiente;
6. 🚀 **Abre o OpenCode** já todo ligado na magia.

É literalmente: **uma linha, tudo pronto.** 🎉

### 3.2 O que você vê na tela

```
Setting up rtk for OpenCode...
MCP retrieve tool: already registered
Serena MCP: uvx not found — install uv/uvx to enable Serena; skipping

╔═══════════════════════════════════════════════╗
║            HEADROOM WRAP: OPENCODE            ║
╚═══════════════════════════════════════════════╝

Launching OPENCODE (API routed through Headroom)...
OPENCODE_CONFIG_CONTENT={provider: headroom}
plugin=headroom-opencode
```

Entendeu cada linha?

| Linha | Significado |
|-------|-------------|
| `Setting up rtk for OpenCode...` | Prepara o filtro de comandos CLI (rtk) |
| `MCP retrieve tool: already registered` | A ferramenta de recuperação já estava configurada |
| `Serena MCP: uvx not found` | Ferramenta opcional (Serena) pulada — sem problema |
| `OPENCODE_CONFIG_CONTENT={provider: headroom}` | O OpenCode vai usar o provider do Headroom |
| `plugin=headroom-opencode` | Plugin de transporte que redireciona o tráfego |

### 3.3 Exemplos de uso 📝

```bash
# Básico: proxy + MCP + opencode
headroom wrap opencode

# Passando um prompt direto (sem abrir a interface interativa)
headroom wrap opencode -- "corrija o bug de login"

# Porta diferente
headroom wrap opencode --port 9999

# Sem configurar a ferramenta de contexto (rtk)
headroom wrap opencode --no-context-tool

# Sem registrar o MCP do headroom
headroom wrap opencode --no-mcp

# Sem o plugin Serena (SERENA = símbolos do código)
headroom wrap opencode --no-serena

# Sem injetar instruções rtk no AGENTS.md do projeto
headroom wrap opencode --no-project-rtk

# Não subir um proxy novo (reutilizar um que já está rodando)
headroom wrap opencode --no-proxy

# Habilitar memória persistente entre sessões
headroom wrap opencode --memory

# Ativar aprendizado em tempo real (aprende com erros do passado)
headroom wrap opencode --learn

# Usar outro backend (ex.: anyllm com provedor groq)
headroom wrap opencode --backend anyllm --anyllm-provider groq

# Usar assinatura do GitHub Copilot para os modelos headroom/*
headroom wrap opencode --copilot-subscription

# Habilitar filtragem de comandos CLI (opt-in)
headroom wrap opencode --rtk

# Verboso (mostra tudo o que está fazendo)
headroom wrap opencode -v
```

### 3.4 Tabela de bandeirinhas (flags) 🚩

| Flag | O que faz | Padrão |
|------|-----------|--------|
| `-p`, `--port <n>` | Porta do proxy | `8787` |
| `--no-proxy` | Não sobe um proxy novo (usa o que já existe) | desligado |
| `--no-mcp` | Não registra o MCP do headroom | desligado |
| `--no-serena` | Não registra o Serena MCP | desligado |
| `--no-context-tool` / `--no-rtk` | Não configura o filtro de contexto CLI | desligado |
| `--no-project-rtk` | Não toca no `AGENTS.md` do projeto | desligado |
| `--rtk` | Liga a filtragem de comandos CLI (opt-in) | desligado |
| `--serena-instructions` | Injeta dicas para preferir as ferramentas do Serena | desligado |
| `--code-graph` | Indexa o grafo de código (codebase-memory-mcp) | desligado |
| `--memory` | Memória persistente entre sessões | desligado |
| `--learn` | Aprendizado em tempo real com tráfego | desligado |
| `--copilot-subscription` | Rota `headroom/*` pela assinatura Copilot | desligado |
| `--backend <nome>` | Backend de API (`anthropic`, `anyllm`, `litellm-vertex`...) | `anthropic` |
| `--anyllm-provider <p>` | Provedor para backend anyllm | — |
| `--region <r>` | Região de nuvem (Bedrock/Vertex) | — |
| `-v`, `--verbose` | Logs detalhados | desligado |

> 💡 **Dica de iniciante:** comece só com `headroom wrap opencode`. As flags são
> para quando você quiser controle fino — e agora você já sabe que elas existem!

### 3.5 E para desfazer? `headroom unwrap opencode` ↩️

Se um dia quiser "desligar" a mágica:

```bash
headroom unwrap opencode
```

Isso **restaura** o `opencode.json` ao estado original (o Headroom guarda um
backup com o sufixo `.headroom-backup` na primeira vez que injeta a config).
Sua vida volta ao normal, sem rastros.

---

## 🔬 Capítulo 4 · Por baixo do capô: o que acontece em segredo

O explorador curioso merece saber **como** o comando trabalha. Aqui vai o
"raio-x" do `headroom wrap opencode`:

### 4.1 O diagrama completo 🗺️

```
 ┌─────────┐    ┌──────────────┐    ┌──────────────────┐    ┌──────────┐
 │  Você   │──▶│   OpenCode    │──▶│ Headroom (proxy)  │──▶│  LLM     │
 │ (TUI)   │   │  (agente)     │   │  127.0.0.1:8787   │   │ (Claude) │
 └─────────┘   └──────────────┘   └──────────────────┘    └──────────┘
                     │                    │
                     │  OPENCODE_         │ guarda originais
                     │  CONFIG_CONTENT    ▼
                     │              ┌─────────────────────┐
                     │              │  🗄️ Armazém local    │
                     └────MCP──────▶│  headroom_retrieve  │
                                    │  (comprimir/obter)  │
                                    └─────────────────────┘
```

### 4.2 As 4 camadas que o wrap configura 🧅

**1) Variável `OPENCODE_CONFIG_CONTENT`** — um JSON injetado no OpenCode que:

- Aponta o provider `anthropic` para o proxy → `http://127.0.0.1:8787/v1`
- Aponta o provider `openai` para o proxy → idem
- Adiciona o provider `headroom` (via `@ai-sdk/openai-compatible`)

**2) O provider `headroom`** — modelos "virtuais" que o OpenCode enxerga:

```json
{
  "provider": {
    "headroom": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Headroom Proxy",
      "options": { "baseURL": "http://127.0.0.1:8787/v1" },
      "models": {
        "claude-sonnet-4-6": { "limit": { "context": 200000, "output": 16384 } },
        "claude-opus-4-6":   { "limit": { "context": 200000, "output": 16384 } },
        "claude-haiku-4-5-20251001": { "limit": { "context": 200000, "output": 8192 } },
        "gpt-4o":  { "limit": { "context": 128000,  "output": 16384 } },
        "gpt-4.1": { "limit": { "context": 1048576, "output": 32768 } }
      }
    }
  }
}
```

Dentro do OpenCode, você escolhe um modelo como `headroom/claude-sonnet-4-6`.

**3) O plugin de transporte `headroom-opencode`** — um plugin JS que patcha o
`fetch`/`http` do OpenCode e redireciona o tráfego de **todos** os providers
pelo proxy. Serve para cobrir até provedores que não foram nomeados (Gemini,
Copilot, gateways custom). Ele lê o endereço do proxy da variável
`HEADROOM_PROXY_URL`.

**4) O MCP server do Headroom** — `headroom mcp serve`, registrado no
`opencode.json`, que expõe as ferramentas de compressão/recuperação.

### 4.3 O que é injetado no seu `opencode.json`

O wrap também **escreve** no arquivo de config do OpenCode um bloco como este:

```jsonc
// --- Headroom proxy provider ---
"provider": {
  "headroom": {
    "npm": "@ai-sdk/openai-compatible",
    "name": "Headroom Proxy",
    "options": { "baseURL": "http://127.0.0.1:8787/v1" },
    "models": { "claude-sonnet-4-6": { "name": "Claude Sonnet 4.6", "limit": { "context": 200000, "output": 16384 } } }
  }
},
// --- end Headroom proxy provider ---
```

E no `opencode.json`, um bloco de MCP:

```jsonc
// --- Headroom MCP server ---
"mcp": {
  "headroom": {
    "type": "local",
    "command": ["headroom", "mcp", "serve"],
    "enabled": true
  }
}
// --- end Headroom MCP server ---
```

Antes da primeira injeção, o arquivo original é copiado para
`opencode.json.headroom-backup` — é por isso que o `unwrap` consegue restaurar
tudo de forma impecável. 🧼

---

## 🧰 Capítulo 5 · Integração manual: para os meticulosos

Você **não precisa** do `wrap` para usar o Headroom com o OpenCode. Se preferir
o controle manual (ótimo para entender o sistema), configure você mesmo:

### 5.1 Passo 1 — Suba o proxy

```bash
headroom proxy
```

Deve ficar rodando em `http://127.0.0.1:8787`. (Pode abrir em outro terminal.)

### 5.2 Passo 2 — Configure o MCP no `opencode.json`

Em `~/.config/opencode/opencode.json` (ou no `opencode.json` do projeto):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "headroom": {
      "type": "local",
      "command": ["headroom", "mcp", "serve"],
      "enabled": true
    }
  }
}
```

### 5.3 Passo 3 — Configure o provider `headroom`

Adicione o provider no seu config (`opencode.json` ou `opencode.jsonc`):

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "headroom": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Headroom Proxy",
      "options": { "baseURL": "http://127.0.0.1:8787/v1" },
      "models": {
        "claude-sonnet-4-6": {
          "name": "Claude Sonnet 4.6",
          "limit": { "context": 200000, "output": 16384 }
        },
        "claude-opus-4-6": {
          "name": "Claude Opus 4.6",
          "limit": { "context": 200000, "output": 16384 }
        },
        "claude-haiku-4-5-20251001": {
          "name": "Claude Haiku 4.5",
          "limit": { "context": 200000, "output": 8192 }
        },
        "gpt-4o": {
          "name": "GPT-4o",
          "limit": { "context": 128000, "output": 16384 }
        },
        "gpt-4.1": {
          "name": "GPT-4.1",
          "limit": { "context": 1048576, "output": 32768 }
        }
      }
    }
  }
}
```

### 5.4 Passo 4 — Use o modelo com prefixo `headroom/`

Dentro do OpenCode, selecione um modelo como:

```
headroom/claude-sonnet-4-6
headroom/gpt-4o
```

Ou exporte as variáveis como fallback:

```bash
export OPENAI_BASE_URL=http://127.0.0.1:8787/v1
export ANTHROPIC_BASE_URL=http://127.0.0.1:8787
```

> ⚠️ Depois de mexer no config: **feche e reabra o OpenCode**. Sempre.

### 5.5 Verificação

```bash
headroom doctor          # tudo ok?
headroom mcp status      # o MCP do headroom está configurado no OpenCode?
```

---

## 🔧 Capítulo 6 · As ferramentas MCP do Headroom

Quando o MCP do Headroom está ativo, o OpenCode ganha **ferramentas** novas.
Elas aparecem com um "namespace" próprio: `mcp__headroom__<ferramenta>`.

| Ferramenta | Para que serve |
|------------|----------------|
| `headroom_compress` | Comprime um conteúdo grande "na hora" (on-demand) |
| `headroom_retrieve` | Busca o **conteúdo original** a partir de um hash |
| `headroom_stats` | Mostra estatísticas de compressão da sessão |

### Como o agente usa na prática 🤖

Quando o proxy comprime uma saída grande, o OpenCode recebe algo como:

```
[204 items compressed to 48. Retrieve more: hash=9f3ab21c...]
```

O agente raciocina com o resumo. Se o detalhe importar (ex.: um erro escondido
no meio do log), ele chama:

```
mcp__headroom__headroom_retrieve(hash="9f3ab21c...")
```

...e recebe o conteúdo completo de volta. Nada se perde. 🗄️✨

> 💡 O "doblê" no nome (`headroom`/`headroom_retrieve`) é normal: é o padrão de
> namespacing do MCP (`mcp__servidor__ferramenta`). Não é bug!

---

## 🗓️ Capítulo 7 · Comandos do dia a dia

O Headroom tem um baú de ferramentas. Aqui estão as que você vai usar mais:

### Saúde e operação 🩺

| Comando | O que faz |
|---------|-----------|
| `headroom doctor` | Check-up completo (proxy, versão, roteamento, economia) |
| `headroom proxy` | Sobe o proxy (ficar rodando num terminal) |
| `headroom wrap <tool>` | Empacota agentes (claude, codex, copilot, aider, opencode...) |
| `headroom unwrap opencode` | Desfaz o wrap do OpenCode |
| `headroom mcp status` | Mostra se o MCP está configurado em cada agente |
| `headroom mcp install` | Instala o MCP em todos os agentes detectados |
| `headroom update` | Atualiza o Headroom |

### Economia e métricas 📊

| Comando | O que faz |
|---------|-----------|
| `headroom savings` | Economia durável ao longo do tempo (7/30 dias, por modelo) |
| `headroom savings --json` | Mesmos dados em JSON (para analisar/plotar) |
| `headroom output-savings` | Estimativa honesta de economia de saída |
| `headroom dashboard` | Abre o dashboard de economia no navegador |
| `headroom agent-savings` | Economia por agente (Codex/Claude/Cursor) |
| `headroom inspect` | Compara o original vs o comprimido das últimas chamadas |
| `headroom audit-reads` | Audita o tráfego de leituras para comprimir |

### Memória 🧠

| Comando | O que faz |
|---------|-----------|
| `headroom memory list` | Lista memórias armazenadas |
| `headroom memory stats` | Estatísticas das memórias |
| `headroom memory show <id>` | Mostra uma memória completa |
| `headroom memory edit <id> --content ...` | Edita uma memória |
| `headroom memory delete <id>` | Apaga uma memória |
| `headroom memory export --output f.json` | Exporta todas |
| `headroom memory import f.json` | Importa de um arquivo |
| `headroom memory prune --older-than 30d` | Limpa memórias antigas |

> Para a memória funcionar no wrap, use `headroom wrap opencode --memory`.

### Caso real desta máquina 📈

Rodando o `headroom savings` aqui nesta máquina (só com OpenCode):

```
lifetime:  281.479 tokens economizados · $0,84 · 534 chamadas
hoje:      56.586 tokens economizados · $0,17
top model: deepseek-v4-flash-free
```

E o `doctor` ainda contou **39,7 milhões de tokens de cache-read** — tokens que
foram servidos do cache com desconto. Economia que não aparece na conta! 🪙🪙🪙

---

## 🚨 Capítulo 8 · Problemas comuns e soluções

| Sintoma | Provável causa | Solução |
|---------|----------------|---------|
| `proxy down` no doctor | Proxy não está rodando | `headroom proxy` (ou use `headroom wrap opencode`, que sobe sozinho) |
| `Model not found` para `headroom/*` | O provider `headroom` não foi injetado | Re-rode `headroom wrap opencode`, ou adicione o provider manualmente (Cap. 5) |
| `Serena MCP: uvx not found` | Serena é opcional e precisa do `uv/uvx` | Ignore, ou `pip install uv` se quiser símbolos de código |
| Comportamento estranho após mudar config | OpenCode não recarrega config em tempo real | Feche e reabra o OpenCode |
| Quer voltar ao normal | — | `headroom unwrap opencode` (restaura do backup `.headroom-backup`) |
| `ConfigInvalidError` ao abrir o OpenCode | JSON malformado | Use `OPENCODE_DISABLE_PROJECT_CONFIG=1` para abrir e corrigir o arquivo |
| Não economiza nada em conversa pura | Conversas sem ferramentas têm pouca gordura | Normal! A economia brilha em trabalhos com muitas ferramentas (busca, logs, DB) |

**Regra de ouro:** quase sempre o `headroom doctor` te diz o que está errado. Rode
ele primeiro. 🩺

---

## 📚 Capítulo 9 · Glossário lúdico

| Termo | "Tradução" do Explorer |
|-------|------------------------|
| **Token** | Moedinha de fliperama que a IA usa (🪙) |
| **Janela de contexto** | A mochila de trilha da conversa (🎒) |
| **Boilerplate** | A "gordura" do conteúdo (repetição inútil) |
| **Proxy** | O porteiro que filtra/compacta o que passa (🚪) |
| **API** | O telefone padrão para falar com a IA (📞) |
| **MCP** | Tomada universal para plugar ferramentas na IA (🔌) |
| **Provider** | A "empresa/endereço" de onde vêm os modelos (🏢) |
| **Compressão** | Esvaziar a mochila, guardando o essencial (🧱) |
| **Cache** | Memória da IA que cobra muito mais barato (⚡) |
| **CCR** | Comprimir → Guardar → Recuperar (🔁) |
| **`headroom_retrieve`** | A ferramenta que busca o original guardado (🗄️) |
| **Hash** | "Carimbo" único que identifica cada conteúdo guardado (🔑) |

---

## 🏁 Cheatsheet rápido

```bash
# ── OpenCode ──────────────────────────────────────────────
curl -fsSL https://opencode.ai/install | bash   # instalar
opencode                                        # abrir no terminal
opencode run "sua tarefa"                       # modo one-shot
/init                                           # criar AGENTS.md do projeto
/connect                                        # conectar provedor
/undo  /redo  /share  /help                     # comandos mágicos
Tab                                             # alternar Plan/Build

# ── Headroom ─────────────────────────────────────────────
pip install "headroom-ai[proxy]"                # instalar
headroom doctor                                 # check-up de saúde
headroom proxy                                  # subir o proxy (porta 8787)
headroom savings                                # ver economia acumulada
headroom dashboard                              # dashboard no navegador
headroom memory list                            # memórias armazenadas
headroom mcp status                             # MCP configurado?

# ── A integração (o coração!) ─────────────────────────────
headroom wrap opencode                          # ⭐ TUDO PRONTO EM 1 LINHA
headroom wrap opencode -- "corrija o bug de login"
headroom wrap opencode --memory                 # + memória persistente
headroom wrap opencode --port 9999              # porta customizada
headroom wrap opencode --no-serena              # sem Serena MCP
headroom unwrap opencode                        # desfazer tudo
```

---

## 🔗 Links e recursos

- **OpenCode** — https://opencode.ai · docs em https://opencode.ai/docs
- **Headroom (GitHub)** — https://github.com/chopratejas/headroom
- **Headroom (site)** — https://headroomlabs.ai
- **Headroom + LiteLLM** — https://docs.litellm.ai/docs/proxy/headroom
- **Schema do OpenCode** — https://opencode.ai/config.json

---

## 🎁 Mensagem final

Você chegou até o fim do manual. 🏆

Se antes a mochila ficava cheia de pedras, agora você sabe que existe um
compactador mágico chamado **Headroom** e um companheiro de trilha chamado
**OpenCode**. E o melhor: a integração é **uma linha**:

```bash
headroom wrap opencode
```

Vá explorar. Rode o `doctor`, olhe o `savings`, teste o `--memory`. Cada erro é
um degrau. E lembre-se:

> **Todo mundo foi iniciante um dia. O que separa o iniciante do expert é a
> curiosidade — e a coragem de rodar o próximo comando.** 🚀

Boa jornada, Explorer! 🎩✨
