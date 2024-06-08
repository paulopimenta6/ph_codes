#include <stdio.h>
#include <stdlib.h>
int main()
{
        FILE *p;
        char str[80],c[80];

        /* Le um nome para o arquivo a ser aberto: */
        printf("Entre com um nome para o arquivo:\n");
        scanf("%s", str);

        if (!(p = fopen(str,"w")))  /* Caso ocorra algum erro na abertura do arquivo..*/
        {                           /* o programa aborta automaticamente */
                printf("Erro! Impossivel abrir o arquivo!\n");
                exit(1);
        }
        /* Se nao houve erro, imprime no arquivo, fecha ...*/
        fprintf(p,"Este e um arquivo chamado:%s", str);
        fclose(p);

        /* abre novamente para a leitura  */
        p = fopen(str,"r");
        if(!feof(p))
        {
                fscanf(p," %s", c);
                printf(" %s",c);
        }
        fclose(p);
        return 0;
}
