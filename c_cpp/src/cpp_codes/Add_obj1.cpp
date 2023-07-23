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
		//void Add_Venda(Venda v1, Venda v2);		
		Venda Add_Venda(Venda& x) const;
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
 
/*void Venda::Add_Venda(Venda v1, Venda v2)
{
	 	npecas = v1.npecas + v2.npecas;
	 	preco = v1.preco + v2.preco;
}
*/

Venda Venda::Add_Venda(Venda& x) const
{
	 	Venda temp;
	 	temp.npecas = npecas + x.npecas;
	 	temp.preco = preco + x.preco;
	 	return temp;
}

int main()
{
	Venda A(58, 127.53), B, Total;
	B.GetVenda();
	Total = A.Add_Venda(B);
	cout << endl;
	cout << "Venda A........."; A.PrintVenda();
	cout << "Venda B........."; B.PrintVenda();
	cout << "Totais.........."; Total.PrintVenda();
	
	return 0;
} 







