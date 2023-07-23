#include <iostream>
#include <iomanip>
using namespace std;

class Venda
{
	private:
		int npecas;
		float preco;
	public:
		Venda() {} //construtor default sem argumentos
		Venda(int np, float p) //construtor com argumentos 
		{
			npecas = np;
			preco = p;
		}
		void GetVenda();
		void PrintVenda() const;
		void Add_Venda(Venda v1, Venda v2);		
};	
		
void Venda::GetVenda()
{
	cout << "Insira No. Pecas: ";
	cin >> npecas;
	cout << endl;
	cout << "Insira Preco: ";
	cin >> preco;
}

void Venda::PrintVenda() const
{
	cout << setiosflags(ios::fixed)
	     << setiosflags(ios::showpoint)
	     << setprecision(2)
	     << setw(10) << npecas;
	cout << setw(10) << preco << endl;     
 }
 
 void Venda::Add_Venda(Venda v1, Venda v2)
{
	 	npecas = v1.npecas + v2.npecas;
	 	preco = v1.preco + v2.preco;
}

int main()
{
	Venda A(58, 127.53), B, Total;
	B.GetVenda();
	Total.Add_Venda(A, B);
	cout << endl;
	cout << "Venda A........."; A.PrintVenda();
	cout << "Venda B........."; B.PrintVenda();
	cout << "Totais.........."; Total.PrintVenda();
	
	return 0;
} 







