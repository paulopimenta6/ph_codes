#include <cstdlib>
#include <iostream>
using namespace std;

double inflacao(double valor_antes, double valor_atual);
//calcula a inflacao

double inflacao_longo_tempo(double inflacao, double valor_atual, int tempo);
//calcula inflacao em longo periodo

int main(){

double valor_antes, valor_atual;
int tempo;
char resposta;

do{

cout << "Informe o valor do item comprado no ano anterior: " << endl;
cin >> valor_antes;
cout << "Informe o valor do item comprado atualmente: " << endl;
cin >> valor_atual;

cout.setf(ios::fixed);
cout.setf(ios::showpoint);
cout.precision(2);

cout << "O valor da inflacao do item e: " << inflacao(valor_antes, valor_atual) << "%" << endl;

cout << "---------------------------------------------------------" << endl;

cout << "Digite um periodo em anos" << endl;
cin >> tempo;

cout << "O valor do item em " << tempo << " anos" << endl;
cout << "anos sera de: R$" << inflacao_longo_tempo(inflacao(valor_antes, valor_atual), valor_atual, tempo) << endl;


cout << "Voce deseja continuar a calcular a inflacao? [s/S ou n/N]" << endl;
cin >> resposta;

    } while (resposta == 's' || resposta == 'S');

cout << "Muito obrigado, voce saiu do programa que calcula a inflacao!" << endl;

            }


double inflacao(double valor_antes, double valor_atual){

double resultado;

resultado=(valor_atual-valor_antes)/100;
return(resultado);

                                                       }

double inflacao_longo_tempo(double inflacao, double valor_atual, int tempo){
int i=1;

while(i<=tempo){

valor_atual=valor_atual*inflacao + valor_atual;
i++;
               }

return(valor_atual);
                                                        }
