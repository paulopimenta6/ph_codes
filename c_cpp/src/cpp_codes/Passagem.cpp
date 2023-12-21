#include <iostream>

using namespace std;

void por_valor(float parametro1, int parametro2)
{
    parametro1 = parametro1 + 10;
    parametro2 = parametro2 + 5;

    cout << "Valor" << endl;
    cout << "Parametro1: " << parametro1;
    cout << " Parametro2: " << parametro2 << endl;
}

void por_referencia(float &parametro1, int &parametro2)
{
    parametro1 = parametro1 + 10;
    parametro2 = parametro2 + 5;

    cout << "Referencia" << endl;
    cout << "Parametro1: " << parametro1;
    cout << " e Parametro2: " << parametro2 << endl;
}

int main()
{
    float numero_float = 5.3;
    int numero_inteiro = 4;

    cout << "numero_float = " << numero_float;
    cout << " e numero_inteiro = " << numero_inteiro << endl;
    cout << "--------------------------------------------------" << endl;
    por_valor(numero_float, numero_inteiro);
    cout << "numero_float = " << numero_float;
    cout << " e numero_inteiro = " << numero_inteiro << endl;
    cout << "--------------------------------------------------" << endl;
    por_referencia(numero_float, numero_inteiro);
    cout << "numero_float = " << numero_float;
    cout << " e numero_inteiro = " << numero_inteiro << endl;

    return 0;
}
