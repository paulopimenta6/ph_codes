# Tutorial: Transferindo fotos e vídeos do Xiaomi para um pendrive usando FTP, WSL e `lftp`

## Objetivo

Transferir fotos e vídeos de um Xiaomi para um pendrive utilizando
**WSL**, **FTP** e **lftp**, de forma segura e reproduzível.

------------------------------------------------------------------------

# Arquitetura

``` text
Xiaomi (Servidor FTP)
        │
      Wi‑Fi
        │
        ▼
WSL (Ubuntu + lftp)
        │
        ▼
Pendrive (/mnt/d/Fotos)
```

------------------------------------------------------------------------

# Pré-requisitos

-   Celular e computador na mesma rede Wi‑Fi.
-   Servidor FTP iniciado no Xiaomi.
-   WSL instalado.
-   Ubuntu no WSL.
-   `lftp` instalado.
-   Pendrive conectado.

## Instalação do lftp

``` bash
sudo apt update
sudo apt install lftp
```

------------------------------------------------------------------------

# Iniciando o servidor FTP

No Gerenciador de Arquivos do Xiaomi:

    FTP
    → Iniciar servidor

Será exibido algo semelhante a:

    ftp://192.168.0.5:2121

Anote:

-   IP
-   Porta
-   Usuário
-   Senha

------------------------------------------------------------------------

# Montando o pendrive no WSL

Verifique:

``` bash
ls /mnt
```

Se `/mnt/d` não existir:

``` bash
sudo mkdir -p /mnt/d
sudo mount -t drvfs D: /mnt/d
```

Confirme:

``` bash
ls /mnt
```

------------------------------------------------------------------------

# Acessando a pasta de destino

``` bash
cd /mnt/d/Fotos
```

------------------------------------------------------------------------

# Conectando ao FTP

``` bash
lftp -u USUARIO,SENHA ftp://<ip>:<porta>
```

Se aparecer:

    530 Login incorrect

utilize o usuário e senha exibidos pelo Xiaomi.

------------------------------------------------------------------------

# Confirmando diretórios

Local:

``` bash
lpwd
```

Exemplo:

    /mnt/d/Fotos

Remoto:

``` bash
pwd
```

Depois:

``` bash
cd DCIM
cd Camera
```

------------------------------------------------------------------------

# Sincronizando

``` bash
mirror
```

O `mirror` copia arquivos novos e atualiza arquivos modificados.

Ele **não apaga arquivos** por padrão.

------------------------------------------------------------------------

# Interpretando a saída

Exemplo:

``` text
Total: 1 directory, 2929 files
New: 2190 files
Modified: 739 files
12588160074 bytes transferred
9040 seconds
To be removed: 0 directories, 2139 files
```

## Total

Arquivos existentes no celular.

## New

Arquivos copiados para o pendrive.

## Modified

Arquivos já existentes que foram atualizados.

## To be removed

Arquivos existentes apenas no pendrive.

Essa mensagem **não significa que eles foram apagados**.

------------------------------------------------------------------------

# Conferindo a cópia

Conte os arquivos:

``` bash
find /mnt/d/Fotos -type f | wc -l
```

Abra algumas fotos e vídeos manualmente.

Execute:

``` bash
mirror --dry-run
```

Se aparecer apenas operações como:

``` text
chmod ...
```

é normal. O servidor FTP do Xiaomi não informa todas as permissões
esperadas pelo `lftp`.

------------------------------------------------------------------------

# Removendo os arquivos do celular

Após verificar a integridade dos arquivos:

``` bash
mirror --Remove-source-files
```

Ou apague manualmente pelo celular (recomendado).

------------------------------------------------------------------------

# Problemas encontrados

## `/mnt/d` não existia

Solução:

``` bash
sudo mount -t drvfs D: /mnt/d
```

------------------------------------------------------------------------

## `mget *`

Erro:

``` text
NLST does not support wildcards
```

Solução:

Usar `lftp` e `mirror`.

------------------------------------------------------------------------

## Login incorreto

``` text
530 Login incorrect
```

Solução:

``` bash
lftp -u usuario,senha ftp://IP:PORTA
```

------------------------------------------------------------------------

# Fluxo resumido

``` text
Iniciar FTP
      ↓
Montar pendrive
      ↓
Entrar em /mnt/d/Fotos
      ↓
Conectar com lftp
      ↓
Autenticar
      ↓
cd DCIM/Camera
      ↓
mirror
      ↓
Conferir arquivos
      ↓
Backup adicional (opcional)
      ↓
Remover arquivos do celular
```

------------------------------------------------------------------------

# Boas práticas

-   Verifique alguns arquivos antes de apagar os originais.
-   Faça um segundo backup quando as fotos forem importantes.
-   Mantenha o celular desbloqueado durante a transferência.
-   Prefira `mirror` ao cliente FTP tradicional para grandes quantidades
    de arquivos.
