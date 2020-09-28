# Programacao em C/C++, Python e Shell

Codigos feitos por Paulo Pimenta
Contato por email: *paulopimenta315@gmail.com* <br />
Fiquem a vontade para copiar, contato e sugestoes 

## Referencias: 

<p>

### Python:

* Python2 e Python3 seguindo as orientacoes dos livros: <br />
* Introducao a programacao com Python - Ed. Novatec <br />
* Python "escreva seus primeiros programas" - Casa do Codigo <br />
* Introdução à Computação Usando Python - Um Foco no Desenvolvimento de Aplicações - LTC <br /> 

### C++11:

* C++ Absoluto - Pearson

### C:

* Algoritmos e programacao em linguagem C - Editora Saraiva

</p>

## DICAS DE PROGRAMACAO EM C

<p>

*Este aquivo tem por objetivo ser um simples tutorial de compilação do GCC que ao longo do uso será sempre atualizado*

* Como compilar no GCC usando linhas de comando?

O comando usado deve ser: *gcc <meu_arquivo>.c -Wall -o <nome_do_executavel>* Lembrando que gcc é o nome do compilador. <br />
**-Wall** é a flag usada para habilitar comentários de possiveis erros **-o** é a flag que habilita a criação do nome do executável

* Como limpar o buffer de um caracter?

Há diversos metodos na internet, como usar fflush(stdin), o qual cria um behaviour undefined e é melhor usado em saidas e não entradas <br />
ou \__fpurge(stdin), no entando escolheu-se usar o espaço entre as aspas e o símbolo de porcentagem e simbolo do tipo tal como <br />
scanf(" %c", &var)

* Como fazer a entrada de dados com string: scanf e %s?

scanf("%s", variavel) enquanto que se for capturado caracter por caracter sera usado o indicador de tipo %c do seguinte modo <br />
scanf("%c", &outraVariavel[i]). O indicador de tipo %s sugere pegar uma variavel longa, por ser uma string, tal como "abcdefghij" equanto <br />
o indicador de tipo %c pega pedado por pedaco e aloca no vetor

</p>
