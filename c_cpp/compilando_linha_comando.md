#Este aquivo tem por objetivo ser um simples tutorial de compilação do GCC que ao longo do uso será sempre atualizado

#1 - Como compilar no GCC usando linhas de comando?
#R1 - O comando usado deve ser: gcc <meu_arquivo>.c -Wall -o <nome_do_executavel>
#...Lembrando que gcc é o nome do compilador
#...-Wall é a flag usada para habilitar comentários de possiveis erros
#... -o é a flag que habilita a criação do nome do executável

#2 - Como limpar o buffer de um caracter?
#R2 - Há diversos metodos na internet, como usar fflush(stdin), o qual cria um behaviour undefined e é melhor usado em saidas e não entradas
#...ou __fpurge(stdin), no entando escolheu-se usar o espaço entre as aspas e o símbolo de porcentagem e simbolo do tipo tal como
#...scanf(" %c", &var);  
