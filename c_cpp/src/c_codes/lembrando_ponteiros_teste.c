#include <stdio.h>

int main()
{
  int a;
  int b;
  int c;
  int *ptr;  // declara um ponteiro para um inteiro
             // um ponteiro para uma variável do tipo inteiro
  a = 90;
  b = 2;
  c = 3;
  ptr = &a;
  printf("Valor de ptr: %p, Conteúdo de ptr: %d\n", ptr, *ptr);
  printf("Endreco de memoria de a: %p e valor de a: %d\n", &a, a);
  printf("Endreco de memoria de b: %p e valor de b: %d\n", &b, b);
  printf("Endreco de memoria de c: %p e valor de c: %d\n", &c, c);
  printf("B: %d, C: %d\n", b, c);

  return 0;

}
