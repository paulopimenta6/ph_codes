/************************************************************************
 * Lê um caracter por vez de um arquivo e
 * o imprime na saída padrão
 ************************************************************************/
#include <stdio.h> /* para funções padrão de E/S */

int main()
{
   FILE *fp;
   char fnome[13];
   int ch;

   /* dialogo com usuário */
   printf("Entre um nome de arquivo: ");
   scanf("%s", fnome);

   fp = fopen( fnome, "w" ); /* abre arquivo*/
if (fp == NULL)
      {
      printf("Erro ao abrir %s\n", fnome);
      }
   else
      {
      printf("Arquivo aberto com sucesso.\n");

   /* Lê o arquivo caracter a caracter e imprime em stdout (saída padrão) */
   while( (ch=fgetc(fp)) != EOF )
          printf("%c", ch);

      fclose(fp); /* fecha arquivo */
}
}
