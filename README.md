## Programacao em C/C++, Python e Shell

Codigos feitos por Paulo Pimenta
Contato por email: *paulopimenta315@gmail.com* <br />
Fiquem a vontade para copiar, contato e sugestoes 

## Referencias: 

<p>

### Python:

*Python 2 e Python 3 seguindo as orientacoes dos livros:* <br />
* Introducao a programacao com Python - Novatec <br />
* Python "escreva seus primeiros programas" - Casa do Codigo <br />
* Introdução à Computação Usando Python - Um Foco no Desenvolvimento de Aplicações - LTC <br /> 

### C++11:

* C++ Absoluto - Pearson

### C:

* Algoritmos e programacao em linguagem C - Editora Saraiva
* Introducao a Programacao com a Linguagem C - NOVATEC
* Programacao em Baixo Nivel - NOVATEC

</p>

## Organizacao

<p>

Os codigos estao armazenados em diretorios especificos da linguagem (exceto o script de compilacao C/C++ feito em Shell que esta no diretorio c_cpp). <br />

* O diretorio para os codigos em C/C++ e o ~/c_cpp/src/. O script **make.sh** faz a compilacao e joga os binarios criados no diretorio ~/bin/ <br />
* O diretorio para os codigos Python e o de mesmo nome havendo codigos tanto em Python 2 quanto em Python 3 <br />

</p>

## Dicas de programcao em C/C++

<p>

*Esta secao tem por objetivo ser um simples tutorial de compilação do GCC que ao longo do uso será sempre atualizado*

* Como compilar no GCC usando linhas de comando?

O comando usado deve ser: *gcc <meu_arquivo>.c -Wall -lm -o <nome_do_executavel>* Lembrando que gcc é o nome do compilador. **-Wall** é a flag usada para habilitar comentários de possiveis erros, **-o** e a flag que habilita a criação do nome do executável e **-lm** e uma flag usada para compilar codigos que usam elementos da biblioteca *math.h*  

* Como limpar o buffer de um caracter?

Há diversos metodos na internet, como usar fflush(stdin), o qual cria um behaviour undefined e é melhor usado em saidas e não entradas ou \__fpurge(stdin), no entando escolheu-se usar o espaço entre as aspas e o símbolo de porcentagem e simbolo do tipo tal como scanf(" %c", &var)

* Como fazer a entrada de dados com string: scanf e %s?

scanf("%s", variavel) para toda uma string enquanto que se for capturado caracter por caracter sera usado o indicador de tipo %c do seguinte modo: scanf("%c", &outraVariavel\[i]). O indicador de tipo %s sugere pegar uma variavel longa, por ser uma string, tal como "abcdefghij", equanto o indicador de tipo %c pega pedado por pedaco e aloca no vetor

</p>

### Estudo de simulacao numerica usando o modelo WRF (World Research in Forecasting)
