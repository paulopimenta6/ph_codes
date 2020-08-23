#include <cstdlib>
#include <iostream>

using namespace std;

const double convert_litro_galao=0.264179;
const double km_to_milles=0.621371;

double consumo_milhas(double combustivel_consumido, double caminho_percorrido);
//Funcao que calcula consumo de combustivel por caminho percorrido

int main(){
double combustivel, caminho;
char resposta;

do{
cout << "Informe o quanto de combunstivel foi consumido [em litros]" << endl;
cin >> combustivel;
cout << "Informe o caminho percorrido [em km]"<<endl;
cin >> caminho;

cout.setf(ios::fixed);
cout.setf(ios::showpoint);
cout.precision(3);

cout << "O seu consumo milhas/galao sera: "<< endl << consumo_milhas(combustivel, caminho) << endl;
cout << "Deseja continuar a calcular? [s/S ou n/N] " << endl;
cin >> resposta;
  } while (resposta=='s' || resposta == 'S');

cout << "Seu programa chegou ao fim, obrigado!";
return 0;

          }



double consumo_milhas(double combustivel_consumido, double caminho_percorrido){
//Aqui sera calculado a razao milha por combustivel

double milhas, galao, razao;

galao=convert_litro_galao*combustivel_consumido;
milhas=km_to_milles*caminho_percorrido;

razao=milhas/galao;

return(razao);
                                                                               }
