#include <iostream>
#include <cmath>

using namespace std;

double meteorologia(double vento, double temperatura);
void bloco_principal();


int main(){

bloco_principal();

return 0;

          }


double meteorologia(double vento, double temperatura){
double resultado;

resultado=(13.12) + 0.6215*temperatura - 11.37*pow(vento, 0.16) + 0.3965*temperatura*pow(vento, 0.016);

return(resultado);


                                                     }

void bloco_principal(){

double vento, temperatura;
char resposta;

do{

  cout << "Informe a velocidade do vento [em m/s]: " << endl;
  cin >> vento;

  do{
     cout << "Informe a temperatura [em graus celsius]: " << endl;
     cout << "IMPORTANTE: Lembre-se que a temperatura deve ser menor que 10C" << endl;
     cin >> temperatura;
     }while(temperatura>10);

  cout << "O fator de frio do vento e: W = " << meteorologia(vento, temperatura) << endl;

  cout << "Deseja continuar? [s/S ou n/N]" << endl;
  cin >> resposta;

  }while(resposta=='s' || resposta == 'S');

  cout << "Obrigado por usar o software!" << endl;


                         }
