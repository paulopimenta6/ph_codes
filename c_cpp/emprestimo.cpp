#include <iostream>
using namespace std;

int main(){

int tempo_duracao;
double qt_consu, juros, valor_nominal, parcelas;

cout << "Digite a quantia desejada pelo correntista [sem desconto direto]:" << endl;
cin >> qt_consu;

cout << "Digite a taxa de juros [a.a]" << endl;
cin >> juros;

cout << "Digite a duracao do emprestimo [em meses]:" << endl;
cin >> tempo_duracao;

valor_nominal = qt_consu/(1-(juros*tempo_duracao/12));
parcelas = valor_nominal/tempo_duracao;

cout << "----------------------------------------------------------------------------" << endl;
cout << "O valor que o correntista necessita como emprestimo e' de: R$" << valor_nominal << endl;
cout << "Os valores a serem pagos mensalmente e' de: R$: " << parcelas << endl;
cout << "----------------------------------------------------------------------------" << endl;

return 0;
}
