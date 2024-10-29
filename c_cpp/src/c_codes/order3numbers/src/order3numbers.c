#include "../include/order3numbers.h" // Inclui o cabeçalho para garantir que a declaração da função esteja em sincronia

void order(int *v1, int *v2, int *v3) {
    int temp;

    // Verifica e troca os valores para ordenar em ordem crescente
    if (*v1 > *v2) {
        temp = *v1;
        *v1 = *v2;
        *v2 = temp;
    }

    if (*v1 > *v3) {
        temp = *v1;
        *v1 = *v3;
        *v3 = temp;
    }

    if (*v2 > *v3) {
        temp = *v2;
        *v2 = *v3;
        *v3 = temp;
    }
}
