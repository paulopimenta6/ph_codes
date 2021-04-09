#include <stdio.h>
#include <stdlib.h>

int main(){

    FILE *fp;
    char s[100], c[100], d[100], e[100], f[100];

    printf("Digite um nome: ");
    scanf("%s", s);
    printf("Nome usado: %s", s);

    fp=fopen(s, "w");
    if(fp==NULL){
        printf("\nNao foi possivel abrir o arquivo");
    }
    else{
        printf("\nArquivo %s aberto!", s);
        fprintf(fp, "Isto e um %s", s);
        fclose(fp);
    }
    //reabrindo o arquivo
    if(fp!=NULL){
        fp=fopen(s, "r");
        fscanf(fp, "%s %s %s %s", c, d, e, f);
        printf("\nA primeira fase escrita e: %s %s %s %s", c, d, e, f);
        fclose(fp);
    }
    else{
    printf("\n O arquivo esta com problemas");
    }

    return 0;

}
