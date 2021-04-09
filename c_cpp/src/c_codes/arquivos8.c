/* strcat.c */
 
#include <stdio.h>
#include <string.h>
 
int main(void)
{
   char sMensagem[100] = "Sr(a). ";
   char sNome[40];
 
   printf("Entre com o seu nome : \n");
   fgets(sNome, 100, stdin);
 
   /* A concatenação ocorre logo após o último caractere da primeira string.
      Seria o equivalente em algoritmo a var_string = var_string + nova_string, 
      embora na linuagem C não pode-se trabalhar com strings desta forma. */
   strcat(sMensagem, sNome);
   strcat(sMensagem, ". Bem vindo ao BR-c.org!!!");
   puts(sMensagem);
   return 0;
}
