#include <iostream>
using namespace std;
class Moeda
{
	private:
		float R$;
	public:
		static float US$;
		Moeda(float x): R$(x) {}
		Moeda()
		{
			cout << "Digite R$: ";
		    cin >> R$;			
		}
		static void ValorUS$()
		{
			cout << "Digite US$: ";
			cin >> US$;
		}
		float USdolar()
		{
			return R$/US$;
		}	
};

float Moeda::US$;

int main()
{
	Moeda::ValorUS$();
	Moeda A(3.5), B;
	
	//cout << "Digute o valor em dolar: ";
	//cin >> Moeda::US$;
	
	cout << "A é US$ " << A.USdolar() << endl;
	cout << "B é US$ " << B.USdolar() << endl;
	
	return 0;
}

