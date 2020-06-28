#include <iostream>
using namespace std;

int main(){
//declaracao de variaveis de entrada

float qtd_adoc_mata_rato, peso_rato, peso_pessoa, peso_final, fator_rato_adoc, fator_pessoa_adoc, fator_pessoa_adoc_final;
const double frac = 0.001;

cout << "Digite a quantidade de adocante necessaria para matar um rato [em mg]: \n";
cin >> qtd_adoc_mata_rato;

cout << "Digite o peso do rato [em g]: \n";
cin >> peso_rato;

cout << "Digite o seu peso [em kg]: \n";
cin >> peso_pessoa;

cout << "Digite o peso que voce deseja ter apos a dieta [em kg]: \n";
cin >> peso_final;

fator_rato_adoc = peso_rato/qtd_adoc_mata_rato;
fator_pessoa_adoc = peso_pessoa/(frac*qtd_adoc_mata_rato);
fator_pessoa_adoc_final = peso_final/(frac*qtd_adoc_mata_rato);

cout << "--------------------------------------------------------- \n";
cout << "A quantidade de adocante para matar um rato e': " << qtd_adoc_mata_rato;
cout << "\n";
cout << "O peso do rato e': " << peso_rato;
cout << "\n";
cout << "O fator peso/adocante do rato e':" << fator_rato_adoc;
cout << "\n";
cout << "--------------------------------------------------------- \n";
cout << "O seu peso e':" << peso_pessoa;
cout << "\n";
cout << "O seu fator peso/adocante [com peso atual] e':" << fator_pessoa_adoc << "\n";
cout << "O seu fator peso/adocante [com peso desejado] e':" << fator_pessoa_adoc_final << "\n";
cout << "--------------------------------------------------------- \n";

return 0;

}

