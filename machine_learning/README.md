# Projeto de Machine Learning

![Logo do Projeto](novoAstronauta1.jpeg)

## Sumário

- [Configuração do ambiente](#Ambiente)
- [Instalação das bibliotecas](#Bibliotecas)
- [Uso](#Uso)
- [Licença](#licença)
- [Autores](#autores)
- [Agradecimentos](#agradecimentos)

## Ambiente

Para começar seguiremos estas etapas:

1. Criação de um ambiente virtual Python diretamente na máquina:

- Será criado um abiente _sandbox_ no qual as bibliotecas serão instaladas.

```bash
python -m venv env
```
Lembrando que em alguns SO pode ser necessário usar _python3_ ao invés de _python_

- Em seguida é preciso ativar o ambiente para que as bibliotecas sejam instaladas corretamente no ambiente criado e não no global. Isso se faz da seguinte forma:

```bash
source env/bin/activate
```

- O prompt do terminal será atualizado e ficará:

```bash
(env) $ which python
env/bin/python
```
- Para instalar um pacote, por exemplo, é preciso dar o comando:

```bash
(env) $ pip install pandas
```

ou de mandeira bem genérica:

```bash
(env) $ pip install <nome_da_lib>
```
- Após os pacotes terem sido instalados aconselha-se criar um arquivo com todas as bibliotecas usadas em suas respectivas versões. 

```bash
(env) $ pip freeze > requisitos.txt
```
e a partir deste arquivo é possível em outro ambiente realizar a instalação das mesmas bibliotecas nas mesmas versões a partir do comando:

```bash
(outra_env) $ pip install -r requisitos.txt
```
2. Criação de um ambiente virtual Python diretamente no Conda:

A ferramenta Conda, que acompanha o Anaconda, permite a criação de ambiente virtuais, além da instalação de pacotes.

- Para criar um ambiente virtual chamado *env* execute o comando:

```bash
$ conda create --name env python=3.11
``` 

- Para ativar o ambiente use o comando:

```bash
$ conda activate env
```

- Para procurar pacotes use o comando:

```bash
(env) $ conda search <nome_da_biblioteca>
```

- Para instalar um pacote no ambiente Conda use o comando:

```bash
(env) $ conda install pandas
```

- Para criar um arquivo contendo os pacotes necessários a um projeto use o comando:

```bash
(env) $ conda env export > requisitos.yml
```

- Para insralar esses requisitos no ambiente Conda usado, use o comando:

```bash
(outra_env) $ conda create -f requisitos.yml
```