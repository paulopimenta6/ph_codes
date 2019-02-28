#include <iostream>
#include <cstdlib>
#include <cmath>

using namespace std;

const double constante_gravitacao=6.673*pow(10,-8); //constante da graviatcao universal

double forca_atracao_gravitacional(double massa_1, double massa_2, double distancia);

int main(){

double massa_1, massa_2, distancia;
char resposta;

do{

cout << "Digite o valor da massa do primeiro corpo [em kg]: " << endl;
cin >> massa_1; //transformando de kg para g
massa_1=massa_1*1000;

cout << "Digite o valor da massa do segundo corpo [em kg]: " << endl;
cin >> massa_2; //transformando de kg para g
massa_2=massa_2*1000;

cout << "Digite a magnitude da distancia entre os corpos: " << endl;
cin >> distancia; //transformando de m para cm
distancia=distancia*100;

cout.setf(ios::fixed);
cout.setf(ios::showpoint);
cout.precision(8);

cout << "A magnitude da forca de atracao gravitacional sera de: " << forca_atracao_gravitacional(massa_1, massa_2, distancia) << " Newtons" << endl;

cout << "Deseja continuar a calcular a forca de atracao gavitacional? [S/s N/n]" << endl;
cin >> resposta;

  }while (resposta == 'S' || resposta == 's');

cout << "Obrigado por usar o software!" << endl;

          }

double forca_atracao_gravitacional(double massa_1, double massa_2, double distancia){
double forca_gravitacional;

forca_gravitacional=constante_gravitacao*(massa_1*massa_2)/pow(distancia, 2);
return(forca_gravitacional);

                                                                                    }
