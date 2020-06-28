#include <iostream>
#include <cstdlib>
#include <stdlib.h>
using namespace std;

int total_moedas(int& moedas_25, int& moedas_10, int& moedas_1);
int valor_total(int& moedas_25, int& moedas_10, int& moedas_1);
void inicio(int& qtd_25, int& qtd_10, int& qtd_1, int& moedas, int& vl_total);
void calcmoedas(int qtdMoeda, int& num, int& qtdRestante, int& qtd);
void saque(int& valor_saque);


int main(){
int qtd_25, qtd_10, qtd_1, moedas, num, vl_total, valor_saque;
char opcao;

inicio(qtd_25, qtd_10, qtd_1, moedas, vl_total);

do{

   saque(valor_saque);

   if(valor_saque<vl_total){

   calcmoedas(25, num, valor_saque, qtd_25);
   cout << "moedas de 25 que sobraram " << qtd_25 << endl;

   calcmoedas(10, num, valor_saque, qtd_10);
   cout << "moedas de 10 que sobraram " << qtd_10 << endl;

   calcmoedas(1, num, valor_saque, qtd_1);
   cout << "moedas de 1 que sobraram " << qtd_1 << endl;

   ////////////////////////////////////////////////////////////////////////////

   if(valor_saque==0){

   cout << "Saque pode ser realizado" << endl;
   cout << "Total de moedas restantes: " << total_moedas(qtd_25, qtd_10, qtd_1) << endl;
   cout << "Valor total restante: " << valor_total(qtd_25, qtd_10, qtd_1) << endl;

                                     }

   else{
    cout << "Nao ha moedas suficientes para a operacao..." << endl;
       }

   ////////////////////////////////////////////////////////////////////////////
                           }

   else{

   cout << "Valor insuficiente" << endl;

       }

   cout << "Deseja continuar? [S/s ou N/n]" << endl;
   cin >> opcao;
   system("clear");
   }while(opcao=='S' || opcao=='s');

system("clear");
cout << "Obrigado por ter usando o sistema Banco da Inglaterra" << endl;

return 0;


          }

//#############################FUNCOES#############################//

//////////////////////////////////////////////////////////////////
//FUNCAO 1
int total_moedas(int& moedas_25, int& moedas_10, int& moedas_1){
int total;

total=(moedas_25+moedas_10+moedas_1);
return(total);
                                                               }
//////////////////////////////////////////////////////////////////
//FUNCAO 2
int valor_total(int& moedas_25, int& moedas_10, int& moedas_1){
int soma;

soma=(moedas_25*25 + moedas_10*10 + moedas_1*1);
return(soma);

                                                          }
//////////////////////////////////////////////////////////////////
//FUNCAO 3
void inicio(int& qtd_25, int& qtd_10, int& qtd_1, int& moedas, int& vl_total){

do{

   cout << "Ben-vindo ao Banco da Inglaterra" << endl;
   cout << "Digite o valor das moedas de 25, 10 e 1 Pence" << endl;
   cin >> qtd_25 >> qtd_10 >> qtd_1;

   cout << "*****Lembre-se que o valor nao pode ser menor que zero nem maior que 99 Pence*****" << endl;

   }while( (valor_total(qtd_25, qtd_10, qtd_1) < 0) || (valor_total(qtd_25, qtd_10, qtd_1)) > 99 );

   moedas=total_moedas(qtd_25, qtd_10, qtd_1);
   vl_total=valor_total(qtd_25, qtd_10, qtd_1);
   cout << "A quantidade de moedas e de: " << moedas << endl;
   cout << "O valor total em moedas e de: " << vl_total << endl;

                                                                             }
//////////////////////////////////////////////////////////////////
//FUNCAO 4
void calcmoedas(int qtdMoeda, int& num, int& qtdRestante, int& qtd){

num=qtdRestante/qtdMoeda;

if(num<qtd){
   qtd=qtd-num;
   qtdRestante=qtdRestante%qtdMoeda;
           }
else{
    qtdRestante=qtdRestante-(qtd*qtdMoeda);
    qtd=0;
    }


                                                                   }
//////////////////////////////////////////////////////////////////
//FUNCAO 5
void saque(int& valor_saque){

do{

  cout << "Digite um valor a ser sacado [Lembrando que so pode ser entre 0 a 99 pence]" << endl;
  cin >> valor_saque;

  }while( (valor_saque < 0) || (valor_saque > 99) );

cout << "A solicitacao de saque esta em andamente...." << endl;
cout << "...." << endl;
cout << "...." << endl;
getchar();
//system("clear");

//system("PAUSE"); e no windows, no Linux e system("clear");
//system("CLS"); e no windows, no Linux e getchar();

                       }
//////////////////////////////////////////////////////////////////
//#############################FUNCOES#############################//


