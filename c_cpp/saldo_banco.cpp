#include <iostream>
using namespace std;

struct Data
{
    int mes;
    int dia;
    int ano;
};

struct contaCD
{
    double balanco_inicial;
    double taxa_de_interesse;
    double balanco_vecimento;
    int mes_vecimento;
    Data vencimento;
};

void pegaCDData(contaCD& AConta);

void pegaData(Data& AData);

int main()
{
    double taxaFracao, interesse;

    contaCD conta;
    cout << "Informe os dados da sua conta no dia em que a conta foi aberta:" << endl;
    pegaCDData(conta);

    taxaFracao = conta.taxa_de_interesse/100.0;
    interesse = conta.balanco_inicial*(taxaFracao*(conta.mes_vecimento/12.0));
    conta.balanco_vecimento = conta.balanco_inicial + interesse;

    cout.setf(ios::fixed);
    cout.setf(ios::showpoint);
    cout.precision(2);

    cout << "Na data de vencimento do CDB "
         << conta.vencimento.dia << "-" << conta.vencimento.mes
         << "-" << conta.vencimento.ano << endl
         << "O saldo era de: R$" << conta.balanco_vecimento << endl;

    return 0;
}

void pegaCDData(contaCD& AConta)
{
    cout << "Informe o saldo inicial da conta em R$: ";
    cin >> AConta.balanco_inicial;
    cout << "Informe a taxa de juros da conta: ";
    cin >> AConta.taxa_de_interesse;
    cout << "Informe o numero de meses ate o vencimento: ";
    cin >> AConta.mes_vecimento;
    cout << "Informe a data de vencimento: " << endl;
    pegaData(AConta.vencimento);
}

void pegaData(Data& AData)
{
    cout << "Informe o mes: ";
    cin >> AData.mes;
    cout << "Informe o dia: ";
    cin >> AData.dia;
    cout << "informe o ano: ";
    cin >> AData.ano;
}
