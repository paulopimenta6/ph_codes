//TemplateFunc.cpp --> do livro da Viviane Victorine
//Mostra o uso de template de funcoes

#include <iostream>
using namespace std;

//Template de troca
template <class T>
void troca (T& x, T& y)
{
	T temp = x;
	x = y;
	y = temp;
}


/*int main()
{
	int i = 2, j = 3;
	troca(i,j);
	cout << "troca(2,3) = " << i << "\t" << j << endl;
	
	double di = 25.63, dj = 74.89;
	troca(di,dj);
	cout << "troca(25.63,74.89) = " << di << "\t" << dj << endl;
	
	return 0;
}*/
