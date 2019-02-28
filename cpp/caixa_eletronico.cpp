#include <iostream>
#include <string>

using namespace std;

void Depositar(int); //função que depositará "qtde" de dinheiro no caixa
void Sacar(int); //função usada para sacar o dinheiro do caixa
int ContarNotas(int, int, int, int, int); //contabiliza a situação das notas
void verSaldo();


int n100, n50, n10, n5, n1;

int main ()
{
char op, cont='s';

	cout << "Entre com o numero de notas disponiveis de 100, 50, 10, 5 e 1 real. \n";
	cin >> n100 >> n50 >> n10 >> n5 >> n1;

	//enquanto o usuário quiser efetuar uma operação
	while (cont == 's' || cont == 'S')
	{
		cout << "O que deseja fazer?\n"
			 << "\t1 - Saque\n"
			 << "\t2 - Deposito\n"
			 << "\t3 - Ver Saldo\n\n";

		cout << "Digite o codigo da operacao: ";
		cin >> op;

		int valor;

		if (op == '1')
		{
			cout << "Quanto deseja sacar? ";
			cin >> valor;

			Sacar(valor);
		}
		else if (op == '2')
		{
			cout << "Quanto deseja depositar? ";
			cin >> valor;

			Depositar(valor);
		}
		else if (op == '3')
		{
			verSaldo();
		} else
			cout << "Operacao invalida. ";

		cout << "Deseja efetuar outra operacao? (s/n)\n";
		cin >> cont;
	}


	return 0;
}

void Depositar(int vl)
{
	cout << "Em construção" << endl;

}


void Sacar(int vl)
{
int saldo = ContarNotas(n100, n50, n10, n5, n1);
int tmp;
int n100_, n50_, n10_, n5_;

	//vamos fazer um backup dos dados
	n100_ = n100;
	n50_ = n50;
	n10_ = n10;
	n5_ = n5;

	if (vl > saldo)
	{
		cout << "Nao ha dinheiro suficiente para o saque" << endl;
		return;
	}

	tmp = vl/100;
	//se houverem mais notas de 100 do que o que precisamos para o saque.
	//sacamos algumas dessas notas
	if (tmp < n100)
	{
		vl = vl%100;
		n100 = n100 - tmp;
	} else
	{
		vl = vl - 100*n100;
		n100 = 0;
		cout << "Nao ha mais notas de 100 reais" << endl;
	}

	tmp = vl/50;

	if (tmp < n50)
	{
		vl = vl%50;
		n50 = n50 - tmp;
	} else
	{
		vl = vl - 50*n50;
		n50 = 0;
		cout << "Nao ha mais notas de 50 reais" << endl;
	}

	tmp = vl/10;

	if (tmp < n10)
	{
		vl = vl%10;
		n10 = n10 - tmp;
	} else
	{
		vl = vl - 10*n10;
		n10 = 0;
		cout << "Nao ha mais notas de 10 reais" << endl;
	}

	tmp = vl/5;

	if (tmp < n5)
	{
		vl = vl%5;
		n5 = n5 - tmp;
	} else
	{
		vl = vl - 5*n5;
		n5 = 0;
		cout << "Nao ha mais notas de 5 reais" << endl;
	}

	tmp = vl/1;

	if (tmp < n1)
	{
		vl = vl%1;
		n1 = n1 - tmp;
	} else
	{
		cout << "Não há notas para evetuar o saque. Desculpe" << endl;
		n100 = n100_;
		n50 = n50_;
		n10 = n10_;
		n5 = n5_;
	}

}

void verSaldo()
{
	cout << "Ha " << ContarNotas(n100, n50, n10, n5, n1) << " reais na conta" << endl
		 << n100 << " notas de 100" << endl
		 << n50 << " notas de 50" << endl
		 << n10 << " notas de 10" << endl
		 << n5 << " notas de 5" << endl
		 << n1 << " notas de 1" << endl << endl;
}

int ContarNotas(int _100, int _50, int _10, int _5, int _1)
{
	return _100*100 + _50*50 + _10*10 + _5*5 + _1;
}
