
#include <stdio.h>
#include "../include/order3numbers.h" //Inclui o cabeçalho onde a função order é declarada

int main() {
    int value1, value2, value3;

    printf("Digite o primeiro valor: ");
    scanf("%d", &value1);

    printf("Digite o segundo valor: ");
    scanf("%d", &value2);

    printf("Digite o terceiro valor: ");
    scanf("%d", &value3);

    // Chama a função order para ordenar os valores
    order(&value1, &value2, &value3);

    printf("Os valores ordenados são: %d %d %d\n", value1, value2, value3);

    return 0;
}
