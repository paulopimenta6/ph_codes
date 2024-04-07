## Dicas de programcao em C/C++

*Esta seção tem por objetivo ser um simples tutorial de compilação do GCC que ao longo do uso será sempre atualizado*

* Como compilar no GCC usando linhas de comando?

O comando usado deve ser: *gcc <meu_arquivo>.c -Wall -lm -o <nome_do_executavel>* Lembrando que gcc é o nome do compilador. **-Wall** é a flag usada para habilitar comentários de possiveis erros, **-o** e a flag que habilita a criação do nome do executável e **-lm** e uma flag usada para compilar codigos que usam elementos da biblioteca *math.h*  

* Como limpar o buffer de um caracter?

Há diversos metodos na internet, como usar fflush(stdin), o qual cria um behaviour undefined e é melhor usado em saidas e não entradas ou \__fpurge(stdin), no entando escolheu-se usar o espaço entre as aspas e o símbolo de porcentagem e simbolo do tipo tal como scanf(" %c", &var)

* Como fazer a entrada de dados com string: scanf e %s?

scanf("%s", variavel) para toda uma string enquanto que se for capturado caracter por caracter sera usado o indicador de tipo %c do seguinte modo: scanf("%c", &outraVariavel\[i]). O indicador de tipo %s sugere pegar uma variavel longa, por ser uma string, tal como "abcdefghij", equanto o indicador de tipo %c pega pedado por pedaco e aloca no vetor


### Dicas com ponteiros

Os ponteiros sao importantes recursos em C/C++ o qual otimizam o uso de recursos e tornam mais eficazes um programa. Aqui vao algumas dicas de como usar um ponteiro.

- Declarando um ponteiro inteiro: 
```c 
    int *ptr //Declarando um ponteiro chamado ptr de tipo inteiro
    ptr=&Var //O ponteiro prt vai receber o endereco de memoria da variavel Var 
    int *ptr=&Var //Outra maneira de se declarar um ponteiro e ainda receber seu endereco de memoria 
    int *ptr=NULL //Declarndo um ponteiro vazio 
```

Para imprimir um ponteiro e preciso ter em mente os seguintes casos:

* O identificador de um ponteiro e %p, ou seja, para imprimir o valor do ponteiro que ele aponta ou o seu proprio endereco de memoria
* Imprimindo o endereco que um ponteiro aponta: printf("O valor do ponteiro pont apontado em x e: %p \n", ptr);
* Imprimindo o endereco de memoria do proprio ponteiro: printf("O endereço do ponteiro pont e: %p \n", &ptr); 
* Imprimindo o valor acessado pelo ponteiro através do ponteiro: printf("O valor de x acessado pelo ponteiro pont e: %d \n", \*ptr);