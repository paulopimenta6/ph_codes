---
title: "Inteligência Artificial Local com Ollama"
---

# "Inteligência Artificial Local com Ollama"
#### "Um guia prático e completo para rodar modelos de IA no seu próprio computador — do zero ao servidor de IA."

![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux-lightgrey)
![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)
![Windows11](https://img.shields.io/badge/Windows-11-blue)
![Ollama](https://img.shields.io/badge/Ollama-0.21.0-green)
![Python](https://img.shields.io/badge/Python-3.8%2B-yellow?logo=python&logoColor=white)

---

## Índice

- [O que é o Ollama?](#o-que-é-o-ollama)
- [Por que rodar IA localmente?](#por-que-rodar-ia-localmente)
- [Hardware recomendado](#hardware-recomendado)
- [Instalação do Ollama](#instalação-do-ollama)
- [Instalando modelos](#instalando-modelos)
- [Usando os modelos](#usando-os-modelos)
- [Integrando no VS Code com Continue](#integrando-no-vs-code-com-continue)
- [Criando um servidor de IA](#criando-um-servidor-de-ia)
- [Referências](#referências)

---

## O que é o Ollama?

O **Ollama** é uma plataforma de código aberto que permite baixar, gerenciar e executar modelos de linguagem (LLMs) localmente, diretamente no seu computador — sem precisar de internet após o download e sem enviar seus dados para nenhum servidor externo.

Pense no Ollama como um gerenciador de modelos de IA, similar ao que o `pip` é para pacotes Python.

### Principais modelos disponíveis

| Modelo | Tamanho | Especialidade | Indicado para |
|---|---|---|---|
| `tinyllama` | 637 MB | Uso geral leve | Hardware limitado |
| `qwen2.5-coder:0.5b` | 400 MB | Código | Hardware limitado |
| `qwen2.5-coder:1.5b` | 1.0 GB | Código e dados | Hardware intermediário |
| `qwen2.5-coder:7b` | 4.7 GB | Código avançado | Hardware potente |
| `llama3.2:1b` | 1.3 GB | Uso geral | Hardware intermediário |
| `llama3.2:latest` | 2.0 GB | Uso geral | Hardware intermediário |
| `phi3:mini` | 2.3 GB | Raciocínio | Hardware intermediário |
| `deepseek-coder:6.7b` | 3.8 GB | Código avançado | Hardware potente |
| `mistral:7b` | 4.1 GB | Uso geral avançado | Hardware potente |

> Consulte a lista completa em [ollama.com/library](https://ollama.com/library)

---

## Por que rodar IA localmente?

| Vantagem | Descrição |
|---|---|
|  **Privacidade total** | Seus dados não saem do computador |
|  **Custo zero** | Sem assinaturas ou limites de uso |
|  **Funciona offline** | Não depende de internet |
| ️ **Controle total** | Você escolhe e gerencia os modelos |

---

## Hardware recomendado

A escolha do modelo depende diretamente do seu hardware. Os componentes mais importantes são:

- **GPU (Placa de vídeo)**: componente mais crítico. GPUs NVIDIA com suporte a CUDA oferecem a melhor performance
- **RAM**: quanto mais, maiores os modelos que você consegue executar
- **CPU**: usada quando não há GPU compatível — mais lenta, mas funcional

### Tabela de recomendações

| Configuração | RAM | VRAM | Modelos recomendados |
|---|---|---|---|
| Hardware muito limitado | 8 GB | Sem GPU dedicada | `tinyllama`, `qwen2.5-coder:0.5b` |
| Hardware intermediário | 16 GB | 2–4 GB | `qwen2.5-coder:1.5b`, `llama3.2:1b` |
| Hardware bom | 16 GB | 6–8 GB | `qwen2.5-coder:7b`, `deepseek-coder:6.7b` |
| Hardware avançado | 32 GB+ | 12 GB+ | `llama3.1:70b`, `deepseek-coder-v2` |

### Exemplos reais de configuração

**Notebook antigo (ex: HP Pavilion 2013, AMD A10, GPU integrada)**
- Execução apenas na CPU — lenta (2 a 5 tokens/segundo)
- Modelos recomendados: `qwen2.5-coder:0.5b` e `tinyllama`

**Notebook moderno (ex: Dell i7, NVIDIA MX350 2GB VRAM)**
- Suporte a CUDA — Ollama usa a GPU automaticamente
- Velocidade: 10 a 20 tokens/segundo
- Modelos recomendados: `qwen2.5-coder:1.5b`, `llama3.2:latest`

---

## Instalação do Ollama

### Windows

1. Acesse [ollama.com/download](https://ollama.com/download)
2. Clique em **Download for Windows**
3. Execute o instalador `.exe`
4. Verifique a instalação no PowerShell:

```powershell
ollama --version
```

5. Confirme que o serviço está ativo:

```powershell
curl http://localhost:11434
# Resposta esperada: Ollama is running
```

### Linux (Ubuntu 22.04 LTS)

```bash
# Instalar via script oficial
curl -fsSL https://ollama.com/install.sh | sh

# Verificar a instalação
ollama --version

# Verificar se o serviço está ativo
systemctl status ollama
```

> **Nota**: em instalações via Snap ou Flatpak, o diretório dos modelos pode estar em caminho diferente do padrão `~/.ollama/models`.

---

## Instalando modelos

```bash
# Baixar um modelo
ollama pull tinyllama
ollama pull qwen2.5-coder:0.5b
ollama pull llama3.2:latest

# Listar modelos instalados
ollama list

# Remover um modelo (libera espaço em disco)
ollama rm tinyllama

# Ver detalhes de um modelo
ollama show qwen2.5-coder:0.5b
```

> O comando `ollama rm` remove completamente os arquivos do modelo. Não é necessário remover diretórios manualmente.

### Verificar espaço em disco

```bash
# Linux
df -h

# Windows (PowerShell)
Get-PSDrive -PSProvider FileSystem
```

---

## Usando os modelos

### Via linha de comando

```bash
# Conversa interativa
ollama run tinyllama

# Pergunta direta
ollama run qwen2.5-coder:0.5b "Como fazer um loop em Python?"
```

Para encerrar o modo interativo: `/bye` ou `Ctrl+D`

### Via Python

**Instalação da biblioteca:**

```bash
pip install ollama
```

**Exemplo básico:**

```python
import ollama

response = ollama.chat(
    model='qwen2.5-coder:0.5b',
    messages=[
        {'role': 'user', 'content': 'Explique o que é regressão linear.'}
    ]
)

print(response['message']['content'])
```

**Chat com histórico:**

```python
import ollama

historico = []

print("Chat iniciado! Digite 'sair' para encerrar.\n")

while True:
    pergunta = input("Você: ")

    if pergunta.lower() == 'sair':
        break

    historico.append({'role': 'user', 'content': pergunta})

    response = ollama.chat(
        model='qwen2.5-coder:0.5b',
        messages=historico
    )

    resposta = response['message']['content']
    historico.append({'role': 'assistant', 'content': resposta})

    print(f"\nModelo: {resposta}\n")
```

**Com streaming** (recomendado para hardware mais lento):

```python
import ollama

for chunk in ollama.chat(
    model='qwen2.5-coder:0.5b',
    messages=[{'role': 'user', 'content': 'O que é machine learning?'}],
    stream=True
):
    print(chunk['message']['content'], end='', flush=True)
```

**Exemplo para ciência de dados:**

```python
import ollama

pergunta = """
Em Python, usando pandas e matplotlib, como faço para:
1. Carregar um CSV
2. Calcular estatísticas descritivas
3. Plotar um histograma
"""

for chunk in ollama.chat(
    model='qwen2.5-coder:0.5b',
    messages=[{'role': 'user', 'content': pergunta}],
    stream=True
):
    print(chunk['message']['content'], end='', flush=True)
```

### Via API REST

```bash
curl http://localhost:11434/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5-coder:0.5b",
    "messages": [
      {"role": "user", "content": "O que é uma função recursiva?"}
    ],
    "stream": false
  }'
```

---

## Integrando no VS Code com Continue

O **Continue** é um plugin gratuito e de código aberto que integra modelos de IA diretamente no VS Code (e família JetBrains), sem enviar seu código para servidores externos.

### Instalação

1. Abra o VS Code e pressione `Ctrl+Shift+X`
2. Pesquise por **"Continue"**
3. Clique em **Install**

### Configuração

Abra o arquivo de configuração no terminal do VS Code:

```bash
# Windows
code $env:USERPROFILE\.continue\config.yaml

# Linux
code ~/.continue/config.yaml
```

**Configuração com um modelo:**

```yaml
name: Local Config
version: 1.0.0
schema: v1

models:
  - name: Qwen 2.5 Coder 0.5b
    provider: ollama
    model: qwen2.5-coder:0.5b
    apiBase: http://localhost:11434

allowAnonymousTelemetry: false
```

**Configuração com múltiplos modelos:**

```yaml
name: Local Config
version: 1.0.0
schema: v1

models:
  - name: Qwen 2.5 Coder 0.5b
    provider: ollama
    model: qwen2.5-coder:0.5b
    apiBase: http://localhost:11434

  - name: TinyLlama
    provider: ollama
    model: tinyllama:latest
    apiBase: http://localhost:11434

allowAnonymousTelemetry: false
```

> **Atenção**: em versões recentes do Continue (1.2+), o campo `tabAutocompleteModel` pode não ser suportado no `config.yaml`. Configure o autocomplete pelo painel da extensão.

### Atalhos essenciais

| Atalho | Ação |
|---|---|
| `Ctrl+Alt+I` | Abre o painel de chat |
| `Ctrl+Shift+L` | Envia código selecionado para o chat |
| `Ctrl+I` | Edita código inline com IA |
| `Tab` | Aceita sugestão de autocomplete |
| `Esc` | Rejeita sugestão de autocomplete |

### Referências de contexto no chat

| Comando | O que referencia |
|---|---|
| `@arquivo.py` | Um arquivo específico |
| `@codebase` | Todo o projeto |
| `@terminal` | Saída do terminal integrado |
| `@problems` | Erros e avisos do VS Code |

---

## Criando um servidor de IA

Por padrão, o Ollama só aceita conexões locais (`localhost`). É possível configurá-lo para compartilhar o modelo com outros dispositivos da rede.

### Linux

```bash
# Editar o serviço
sudo systemctl edit ollama.service

# Adicionar a variável de ambiente
[Service]
Environment="OLLAMA_HOST=0.0.0.0"

# Reiniciar o serviço
sudo systemctl daemon-reload
sudo systemctl restart ollama

# Verificar se está funcionando
curl http://192.168.1.100:11434
```

### Windows (PowerShell como administrador)

```powershell
[System.Environment]::SetEnvironmentVariable("OLLAMA_HOST", "0.0.0.0", "Machine")

Stop-Service ollama
Start-Service ollama
```

### Acessando o servidor de outro dispositivo

**Python:**

```python
import ollama

client = ollama.Client(host='http://192.168.1.100:11434')

response = client.chat(
    model='qwen2.5-coder:0.5b',
    messages=[{'role': 'user', 'content': 'Olá!'}]
)

print(response['message']['content'])
```

**Continue (config.yaml em outro computador):**

```yaml
models:
  - name: Modelo no Servidor
    provider: ollama
    model: qwen2.5-coder:0.5b
    apiBase: http://192.168.1.100:11434
```

### Servidor na Jetson Nano

O Ollama oficial não suporta a arquitetura ARM da Jetson Nano. A alternativa recomendada é o **llama.cpp**:

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
make LLAMA_CUBLAS=1

./server \
  -m models/tinyllama.gguf \
  --host 0.0.0.0 \
  --port 11434
```

Modelos viáveis na Jetson Nano (4 GB RAM):

| Modelo | Viabilidade |
|---|---|
| `tinyllama` | Roda bem |
| `qwen2.5-coder:0.5b` | Roda bem |
| `llama3.2:1b` | Aceitável |
| `phi3:mini` | Lento |
| `llama3.2:3b` | Muito pesado |

### Boas práticas de segurança

- Use apenas em **rede local confiável**
- Configure um **firewall** para limitar o acesso
- Para acesso remoto seguro, use **VPN** ou **túnel SSH**
- Monitore o consumo de recursos com múltiplos clientes simultâneos

---

## Referências

- [Ollama — Site oficial](https://ollama.com)
- [Ollama — GitHub](https://github.com/ollama/ollama)
- [Ollama — Biblioteca de modelos](https://ollama.com/library)
- [Continue — Site oficial](https://continue.dev)
- [Continue — GitHub](https://github.com/continuedev/continue)
- [llama.cpp — GitHub](https://github.com/ggerganov/llama.cpp)
- [Biblioteca Python do Ollama](https://github.com/ollama/ollama-python)

---

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma *issue* ou enviar um *pull request* com correções, sugestões ou novos exemplos.

---

## Licença

Este projeto está sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## Estatísticas

<p align="center">
  <img src="https://komarev.com/ghpvc/?username=paulopimenta6&style=flat-square&color=blue" alt="Visitas no perfil" />
</p>