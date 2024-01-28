#ifndef CARRO_H
#define CAROO_H

using namespace std;

class Carro{
	private:
		string modelo;
		string cor;
		int ano;
		float preco;
		static int totalCarros;
	public:
		Carro();
		Carro(string, int, float, string);
		~Carro();
		
		string getModelo();
		void setModelo(string);
		string getCor();
		void setCor(string);
		int getAno();
		void setAno(int);
		void setAno(string);
		float getPreco();
		void setPreco(float);
		void setPreco(string);
		void apresentacao();
		
		static int getTotal(){
			return totalCarros;
		}
		
		static void mostrarTotalCarros(){
			cout << "Total de carros: " << Carro::getTotal() << endl;
		}		
};

#endif