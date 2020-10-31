#include <iostream>
#include <cmath>
using namespace std;

double desvio_padrao(double s1, double s2, double s3, double s4);
double media(double s1, double s2, double s3, double s4);

int main(){
double s1, s2, s3, s4;
char resposta;

do{

cout << "Insira os quatro valores (separados por espaço):" << endl;
cin >> s1 >> s2 >> s3 >> s4;

cout << "O resultado da media e desvio padrao sera: " << media (s1, s2, s3, s4) << " " << desvio_padrao(s1, s2, s3, s4) << endl;
cout << "Deseja continuar a fazer mais calculos?: [s/S ou n/N]" << endl;
cin >> resposta;

  }while(resposta == 's' || resposta =='S');

cout << "Obrigado por calcular!";

return 0;
           }

double media(double s1, double s2, double s3, double s4){
double resultado;

resultado=(s1+s2+s3+s4)/4;
return(resultado);

                             }

double desvio_padrao(double s1, double s2, double s3, double s4){
double resultado;

resultado=sqrt( ( pow(s1-media(s1, s2, s3, s4),2) + pow(s2-media(s1, s2, s3, s4),2) + pow(s3-media(s1, s2, s3, s4),2) + pow(s4-media(s1, s2, s3, s4),2) ) ) /4;
return(resultado);

                                    };

