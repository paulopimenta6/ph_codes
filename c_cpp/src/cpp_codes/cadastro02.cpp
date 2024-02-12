#include <iostream>
#include "parametros.h"

using namespace std;

struct Pessoa
{
    string nome;
    int idade;
    char sexo;
};

int main()
{
    int x;
    Pessoa pessoa[N];

    for (x=0; x<N; x++){
        cout << "Digite Nome: ";
        cin >> pessoa[x].nome;
        cout << "Digite idade: ";
        cin >> pessoa[x].idade;
        cout << "Digite o sexo (m/M para masculino e f/F para feminino): ";
        cin >> pessoa[x].sexo;
    }

    for (x=0; x<N; x++){
        cout << pessoa[x].nome << " - " << pessoa[x].idade << " - " << pessoa[x].sexo << endl;
    }

    return 0;
}

