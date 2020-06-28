#include <iostream>
using namespace std;

int main(){

float valor_total, taxa_juros, juros, parcelas, abatimento;
int cont = 1;

cout.setf(ios::fixed);
cout.setf(ios::showpoint);
cout.precision(2);

cout << "-----------------------------------------" << endl;
cout << "Digite o valor da sua divida total: " << endl;
cin >> valor_total;
cout << "Digite o valor da taxa de juros [ao mes]: " << endl;
cin >> taxa_juros;
cout << "Digite o valor das parcelas a serem pagas: " << endl;
cin >> parcelas;
cout << "-----------------------------------------" << endl;

cout << "\n";

cout << "mes \t\t juros \t\t abatimento \t\t valor_total \t\t mes" << endl;

while (valor_total > 0){

juros = (taxa_juros/100)*valor_total;
abatimento = (parcelas - juros);
valor_total = (valor_total - abatimento);

if (valor_total > 0){

    cout << cont << "\t\t" << juros << "\t\t" << abatimento << "\t\t" << valor_total << endl;
    cont += 1;
                    }

                       }

cout << "----------------------------------------------------------------------------" << endl;
valor_total = valor_total + abatimento + juros;
cout << "O valor total aqui e: " << valor_total << endl;
cout << "O valor do jutos e: " << juros << endl;
cout << "A ultima prestacao foi de: R$ " << valor_total << " no mes: " << cont << endl;
cout << "----------------------------------------------------------------------------" << endl;

return 0;

          }





