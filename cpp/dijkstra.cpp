//Este e o problema de dijkistra transformando de um pseudo-codigo em c++

#include <iostream>
using namespace std;

int D[100][100], DA[100], ANT[100];
bool EXPA[100];
int N, ORIGEM, DESTINO, I, C, NOVADA, MIN;
int p, q;

int main()
{
    cout << "Digite o tamanho da matriz de Dijkstra: " << endl;
    cin >> N;

    cout << "Leitura dos elementos da matriz de Dikstra: " << endl;
    cout << "Matriz: " << N << "x" << N << endl;
    for (p=0; p<=N; p++){
        for (q=0; q<=N; q++){
            cout << "Preencha o elemento ["<< p << "]" << "x" <<"[" << q << "]: " << endl;
            cin >> D[p][q];
        }
    }

return 0;
}



