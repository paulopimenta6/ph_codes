![Python3.10](https://img.shields.io/badge/Python-3.10-yellow) ![Anaconda](https://img.shields.io/badge/Anaconda-brightgreen) ![Ubuntu](https://img.shields.io/badge/Ubuntu-Linux-orange)

# Projeto de Machine Learning

<!--![Logo do Projeto](imgs/novoAstronauta1.jpeg)-->

<p align="center">
  <img src="imgs/novoAstronauta1.jpeg" alt="Logo do Projeto" width="600">
</p>

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

<!--![Logo do Python](imgs/python.jpeg)-->

<p align="center">
  <img src="imgs/python.jpeg" alt="Logo do Python" width="200">
</p>

- Instalar o python3_env através do comando (ambientes baseados em Debian):

``` 
    sudo apt install python3-venv
``` 

- Será criado um abiente _sandbox_ no qual as bibliotecas serão instaladas.

```bash
python3 -m venv env
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

<!--![Logo do Anaconda](imgs/Anaconda_Logo.png)-->

<p align="center">
  <img src="imgs/Anaconda_Logo.png" alt="Logo do Anaconda" width="400">
</p>

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

3. Criando um ambiente virtual dentro da máquina Linux (baseada em sistemas Debian)
<!--![Logo do Ubuntu](imgs/ubuntu.jpg)-->

<p align="center">
  <img src="imgs/ubuntu.jpg" alt="Logo do Ubuntu" width="400">
</p>


- Usar a sequência de comandos:

```bash
$ sudo apt install python3-virtualenv
$ virtualenv <nome_do_ambiente>
$ source env/bin/activate
```

4. Saindo de um ambiente virtual 

- Para sair basta usar o comando:
```bash
$ deactivate
```
