#include <iostream>

using namespace std;

static float numero2 = 6.2;

void funcao1()
{
    float *ponteiro2 = new float;
    *ponteiro2 = numero2;

    cout << "Valor numero2: " << numero2 << endl;
    cout << "--------------------------------------------------------" << endl;
    cout << "Endereco do poteniro na funcao1: " << &ponteiro2 << endl;
    cout << "Valor do ponteiro na funcao1: " << *ponteiro2 << endl;
    cout << "Numero 2: " << numero2 << endl;

    numero2 = 4.2;
    delete ponteiro2;
    cout << "Valor do ponteiro na funcao1: " << *ponteiro2 << endl;
    cout << "--------------------------------------------------------" << endl;
}


int main()
{
    float numero1 = 10.4;
    float *ponteiro;

    ponteiro = new float;
    *ponteiro = numero1;

    cout << "Numero 1: " << numero1 << endl;
    cout << "Endereco do ponteiro: " << &ponteiro << endl;
    cout << "Valor do ponteiro: " << *ponteiro << endl;

    numero2 = 5.8;
    *ponteiro = numero2;

    cout << "Endereco de ponteiro: " << &ponteiro << endl;
    cout << "Valor de ponteiro: " << *ponteiro << endl;

    funcao1();
    cout << "Numero2: " << numero2 << endl;
    delete ponteiro;

    return 0;
}
