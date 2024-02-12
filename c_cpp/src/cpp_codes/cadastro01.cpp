#include <iostream>
#include "parametros.h"

using namespace std;

int main()
{
    int idade[N];
    string nome[N];
    char sexo[N];
    int x;

    for (x=0; x<N; x++){
        cout << "Digite Nome: ";
        cin >> nome[x];
        cout << "Digite idade: ";
        cin >> idade[x];
        cout << "Digite o sexo (m/M para masculino e f/F para feminino): ";
        cin >> sexo[x];
    }

    for (x=0; x<N; x++){
        cout << nome[x] << " - " << idade[x] << " - " << sexo[x] << endl;
    }

    return 0;
}
