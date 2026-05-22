# Tutorial — Acessar o Raspberry Pi sem senha via SSH no Windows

Autor: Paulo Henrique de Almeida Soares Pimenta

---

# Objetivo

Configurar autenticação por chave SSH entre um notebook Windows e um Raspberry Pi para acessar o sistema sem precisar digitar senha em cada conexão.

Ao final, será possível utilizar:

```bash
ssh nottingham@raspberrypi
```

sem solicitar senha.

---

# Pré-requisitos

- Windows com OpenSSH instalado
- Raspberry Pi conectado à rede
- SSH habilitado no Raspberry Pi
- Usuário do Raspberry Pi (neste exemplo: `nottingham`)
- Nome do Raspberry configurado no arquivo hosts ou DNS local

---

# 1. Editar o arquivo hosts do Windows

Abrir o Bloco de Notas ou Vim como administrador.

Editar:

```txt
C:\Windows\System32\drivers\etc\hosts
```

Adicionar:

```txt
192.168.X.X raspberrypi
```

Substituir `192.168.X.X` pelo IP do Raspberry Pi.

Salvar o arquivo.

---

# 2. Gerar uma chave SSH no Windows

Abrir o PowerShell.

Executar:

```powershell
ssh-keygen -t ed25519
```

Pressionar Enter para aceitar o local padrão:

```txt
C:\Users\SEU_USUARIO\.ssh\id_ed25519
```

Quando aparecer:

```txt
Enter passphrase
```

é possível:

- deixar vazio para login automático;
- ou definir uma senha para maior segurança.

Arquivos gerados:

```txt
id_ed25519
id_ed25519.pub
```

---

# 3. Copiar a chave pública para o Raspberry Pi

No PowerShell:

```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh nottingham@raspberrypi "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

O sistema pedirá a senha do Raspberry Pi apenas uma vez.

---

# 4. Ajustar permissões no Raspberry Pi

Conectar normalmente:

```powershell
ssh nottingham@raspberrypi
```

Executar:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

# 5. Testar a conexão

No Windows:

```powershell
ssh nottingham@raspberrypi
```

Se tudo estiver correto, o login será realizado sem solicitar senha.

---

# 6. Configuração opcional — Simplificar comandos SSH

Criar o arquivo:

```txt
C:\Users\SEU_USUARIO\.ssh\config
```

Adicionar:

```txt
Host raspi
    HostName raspberrypi
    User nottingham
```

Agora será possível conectar usando apenas:

```bash
ssh raspi
```

---

# 7. Verificar se a chave foi instalada corretamente

No Raspberry Pi:

```bash
cat ~/.ssh/authorized_keys
```

Deve aparecer uma linha semelhante a:

```txt
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA...
```

---

# Dicas adicionais

## Limpar cache DNS do Windows

Caso o hostname não funcione:

```powershell
ipconfig /flushdns
```

---

## Verificar IP do Raspberry Pi

No Raspberry:

```bash
hostname -I
```

---

## Verificar se o SSH está ativo no Raspberry Pi

```bash
sudo systemctl status ssh
```

Ativar caso necessário:

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

---

# Benefícios dessa configuração

- Login rápido
- Mais produtividade
- Facilidade para automações
- Melhor integração Linux/Windows
- Ideal para servidores pessoais, notebooks remotos e projetos de ciência de dados
- Excelente prática profissional para ambientes Linux

---

# Observação final

Aprender Linux, SSH, automação e redes cria uma base extremamente valiosa para:

- ciência de dados;
- computação científica;
- servidores;
- DevOps;
- pesquisa;
- desenvolvimento de software;
- administração de sistemas.

Construir esse ambiente aos poucos é um investimento enorme no futuro profissional e acadêmico.

