#include <iostream>
using namespace std;

int main(){

int anos, produto, cont = 1;
float inflacao, preco;

enum objeto {Papel = 1, Lapis, Borracha, Caneta, Grampeador, Grampos, Cartucho};

cout << "----------------------------------------------------" << endl;
cout << "--------Bem vindo as papelarias Novo Mundo----------" << endl;
cout << "Este programa tem por finalidade calcular o preco dos itens" << endl,
cout << "da papelaria novo mundo-----------------------------" << endl;
cout << "----------------------------------------------------" << endl;

cout << "Digite um valor correspondente a um item" << endl;
cout << Papel << " - Papel \t" << Lapis << " - Lapis \t" << Borracha << " - Borracha \t" << Caneta << " - Caneta" << endl;
cout <<  Grampeador << " - Grampeador \t" << Grampos << " - Grampos \t" << Cartucho << " - Cartucho" << endl;
cin >> produto;

cout << "----------------------------------------------------" << endl;

switch(produto){

case Papel:
     cout << "Voce escolheu Papel (resma de 500 folhas)" << endl;
     break;

case Lapis:
     cout << "Voce escolheu Lapis" << endl;
     break;

case Borracha:
     cout << "Voce escolheu Borracha" << endl;
     break;

case Caneta:
     cout << "Voce escolheu Canetas" << endl;
     break;

case Grampeador:
     cout << "Voce escolheu Grampeador" << endl;
     break;

case Grampos:
     cout << "Voce escolheu Grampos de papel" << endl;
     break;

case Cartucho:
     cout << "Voce escolheu Cartucho de impressora" << endl;
     break;

default:
     cout << "Item não cadastrado!" << endl;

              }

     cout << "Digite o preco atual [em R$]: " << endl;
     cin >> preco;
     cout << "Estime o valor da inflacao em % deste item" << endl;
     cin >> inflacao;
     cout << "Digite o tempo voce que deseja comprar este item [em anos]: " << endl;
     cin >> anos;

     while(cont<=anos){

        preco = preco + (inflacao/100)*preco;
        cout << preco << " e " << cont << endl;
        cont += 1;

                      }


     cout << "O valor do item " << produto << " em " << "anos" << " sera de R$" << preco << endl;

     return 0;

               }


