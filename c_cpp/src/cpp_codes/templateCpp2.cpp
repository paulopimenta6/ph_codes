//TemplFunc.cpp --> livro da Viviane Victorine
//MOstra o uso de templartes de funcoes

#include <iostream>
#include <cstring>
using namespace std;

//template de troca
template <class T>
void troca(T& x, T&y)
{
	T temp = x;
	x = y;
	y = temp;
}

//especializacao para funcoes de troca
//aqui a funcoes pode usar um ponteiro de char
void troca(char *x, char *y)
{
	int tx = strlen(x), ty = strlen(y);
	int maior = tx > ty ? tx : ty;
	
	int i;
	for (i = 0; i < maior; i++)
	{
		troca(*x, *y);
		x++;
		y++;
	}
}

class String
{
	private:
		char str[80];
	public:
		String() //construtor default
		{
			str[0] = '\0';	
		}
		String(char *s)
		{
			strcpy(str, s);
		}
		friend ostream& operator << (ostream& os, String& s);		
};

ostream& operator << (ostream& os, String& s)
{
	os << s.str;
	return os;
}

/*int main()
{
    int i = 2, j = 3;
    troca(i, j);
    cout << "troca(2,3) = " << i << "\t" << j << endl;

    double di = 25.63, dj = 74.89;
    troca(di, dj);
    cout << "troca(25.63,74.89) = " << di << "\t" << dj << endl;

    char nome[30] = "Paulo", sobrenome[30] = "Pimenta";
    troca(nome, sobrenome); // Use a e b em vez de a e b
    cout << "nome = " << nome << endl;
    cout << "sobrenome = " << sobrenome << endl;

    String novoNome("Nicolle"), novoSobrenome("Dias");
    troca(novoNome, novoSobrenome);
    cout << "Novo nome = " << novoNome << endl;
    cout << "Novo sobrenome = " << novoSobrenome << endl;

    return 0;
}*/








