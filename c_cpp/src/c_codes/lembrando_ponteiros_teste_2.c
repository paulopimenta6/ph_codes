#include <stdio.h>
int main()
{
  int x;
  int *ptr;
  x = 5;
  ptr = &x;
  printf("O valor do endereco de memoria armazenado por ptr é: %p\n", ptr);
  printf("O valor da variável ptr é: %d\n", *ptr);  // derreferenciando um ponteiro
  
  printf("O valor do endereco de memoria armazenado por x é: %p\n", &x);
  printf("O valor da variável x é: %d\n", x);    
  
  *ptr = 10;  // usando derreferencia no "lado esquerdo" de uma atribuição

  printf("O (novo) valor do endereco de memoria armazenado por ptr é: %p\n", ptr);
  printf("Agora, ptr vale: %d\n", *ptr);

  printf("O valor do endereco de memoria armazenado por x é: %p\n", &x);
  printf("O valor da variável x é: %d\n", x);    

  return 0;
}
