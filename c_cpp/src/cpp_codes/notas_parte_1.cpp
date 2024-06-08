#include <iostream>
using namespace std;

int main (){

    int i, notas[5], max;

    cout << "Forneca 5 notas:" << endl;
    cin >> notas[0];
    max = notas[0];

    for (i = 1; i < 5; i++){

        cin >> notas[i];

        if (notas[i] > max){

            max = notas[i];

                           }


                           }

       cout << "A nota mais e: " << max << endl
            << "As notas e suas diferencas" << endl
            << "em relacao a nota mais alta sao:" << endl;

       for (i = 0; i < 5; i++){

        cout << notas[i] << " e a diferenca " << (max - notas[i]) << endl;

                              }


       return 0;

           }
