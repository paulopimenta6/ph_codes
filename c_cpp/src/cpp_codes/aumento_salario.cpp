#include <iostream>
using namespace std;

int main(){

const double porcentagem_aumento = 0.076;
double salario_anterior, salario_atual, aumento, salario_novo;

cout << "---------------------------------------------------------" << endl;
cout << "Digite o salario anteior [dos ultimos 6 meses]: " << endl;
cin >> salario_anterior;
cout << "Digite o salario atual: " << endl;
cin >> salario_atual;

aumento = 6*(salario_anterior*porcentagem_aumento);

cout << "---------------------------------------------------------" << endl;
cout << "O aumento sera' de: R$" << aumento;
salario_novo = salario_atual + aumento;
cout << "\n";
cout << "O seu salario anual novo sera': R$ " << 12*(salario_atual+aumento) << endl;
cout << "O seu novo salario mensal sera' de: R$ " << salario_novo << endl;
cout << "---------------------------------------------------------";

return 0;
}

