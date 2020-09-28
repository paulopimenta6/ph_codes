# meus_codigos
Meus codigos de programacao

Codigos feitos por Paulo Pimenta em

[1] Python2 e Python3 seguindo as orientacoes dos livros:
[1.1] Introducao a programacao com Python - Ed. Novatec
[1.2] Python "escreva seus primeiros programas" - Casa do Codigo

[2] C++11
[2.1] C++ Absoluto - Pearson

[3] C
[3.1] Algoritmos e programacao em linguagem C - Editora Saraiva

[4] Contato por email: paulopimenta315@gmail.com

[5] Fiquem a vontade para copiar, contato e sugestoes 

#####DICAS E APRENDIZADOS#####

[6] Este aquivo tem por objetivo ser um simples tutorial de compilação do GCC que ao longo do uso será sempre atualizado

P1 - Como compilar no GCC usando linhas de comando?

R1 - O comando usado deve ser: gcc <meu_arquivo>.c -Wall -o <nome_do_executavel>

...Lembrando que gcc é o nome do compilador

...-Wall é a flag usada para habilitar comentários de possiveis erros

... -o é a flag que habilita a criação do nome do executável

P2 - Como limpar o buffer de um caracter?

R2 - Há diversos metodos na internet, como usar fflush(stdin), o qual cria um behaviour undefined e é melhor usado em saidas e não entradas

...ou __fpurge(stdin), no entando escolheu-se usar o espaço entre as aspas e o símbolo de porcentagem e simbolo do tipo tal como

...scanf(" %c", &var);

P3 - Como fazer a entrada de dados com string: scanf e %s?

R3 - scanf("%s", variavel) enquanto que se for capturado caracter por caracter sera usado o indicador de tipo %c do seguinte modo
...scanf("%c", &outraVariavel[i]). O indicador de tipo %s sugere pegar uma variavel longa, por ser uma string, tal como "abcdefghij" equanto
...o indicador de tipo %c pega pedado por pedaco e aloca no vetor
