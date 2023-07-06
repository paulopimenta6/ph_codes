//TemplateClass3.cpp --> livro da Victorine Viviane
//Mostra templates da classe matriz

#include <iostream>
using namespace std;

template <class Tipo>
class Matriz
{
	private:
		Tipo *v;
		int tamanho;
	public:
		Matriz(int);
		Tipo& operator()(int);
		Tipo& operator[](int);
		void Redim(int);
		void RedimPreserve(int);
		~Matriz(){
			delete []v;
		} 
};

//construtor
template <class Tipo> Matriz<Tipo>::Matriz(int n)
{
	v = new Tipo[n];
	tamanho = n;
}

template <class Tipo> Tipo& Matriz<Tipo>::operator()(int i)
{
	return v[i];
}

template <class Tipo> Tipo& Matriz<Tipo>::operator[](int i)
{
	return v[i];
}

//Redimensionar a matriz sem preservar os dados
template <class Tipo> void Matriz<Tipo>::Redim(int n)
{
	delete [] v;
	v = new Tipo[n];
	tamanho = n;
}

//Redimensionar a matriz preservando os dados
template <class Tipo> void Matriz<Tipo>::RedimPreserve(int n)
{
	Tipo *v1 = new Tipo[n];
	int menor = n < tamanho ? n : tamanho;
	cout << "\n menor = " << menor << endl;
	int i; 
	for (i = 0; i < menor; i++)
	{
		v1[i] = v[i];
	}
	delete []v;
	v = v1;
	tamanho = n;
}

/*int main()
{
	int y = 20;
	Matriz<float> notas(y);
	notas(0) = 00.01;
	notas(1) = 00.01;
	notas(2) = 00.02;
	notas(3) = 00.03;
	notas(4) = 00.04;
	cout << "\nnotas[0] = " << notas[0];
	cout << "\nnotas[1] = " << notas[1];
	cout << "\nnotas[2] = " << notas[2];
	cout << "\nnotas[3] = " << notas[3];
	cout << "\nnotas[4] = " << notas[4];
	notas.RedimPreserve(1); 
	cout << "\nnotas[0] = " << notas[0];
	cout << "\nnotas[1] = " << notas[1];
	cout << "\nnotas[3] = " << notas[3];
	
	return 0;
}*/
