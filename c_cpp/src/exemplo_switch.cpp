#include <iostream>
#include <cstdlib>
using namespace std;

int main(){
int operacao, a, b, c;

cout << "Informe um valor: " << endl;
cin >> a;

cout << "Informe um segundo valor: " << endl;
cin >> b;

cout << "Informe uma operacao: " << endl;
cout << "1 - Soma \t 2 - Subtracao \t 3 - Multiplicacao \t 4 - divisao" << endl;
cin >> operacao;

switch (operacao){

case 1:
    c=a+b;
    cout << a<<"+"<<b<<"="<<c;
    break;

case 2:
    c=a-b;
    cout << a<<"-"<<b<<"="<<c;
    break;

case 3:
    c=a*b;
    cout << a<<"+"<<b<<"="<<c;
    break;

case 4:
    if (b==0){

    cout << "Nao se pode dividir por 0";
    break;

             }
    else{

    c=a/b;
    cout << a<<"/"<<b<<"="<<c;
    break;

        }


                }

return 0;

           }
