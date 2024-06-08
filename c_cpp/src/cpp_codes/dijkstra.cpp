//Este e o problema de dijkistra transformando de um pseudo-codigo em c++

#include <iostream>
using namespace std;

const int tamanho=6;
const int C=0; //Indicando a origem//
void distanciaAcumulada(int DA[], int dimensao);
void matrixDistancias(int D[][tamanho], int dimensao);


int main(){
    bool EXPA[tamanho];
    int ANT[tamanho];
    int DA[tamanho];
    int D[tamanho][tamanho];
 
    cout << "Programa da matriz de Dijkstra" << endl;
    distanciaAcumulada(DA, tamanho);
    matrixDistancias(D, tamanho);

return 0;
          }

void distanciaAcumulada(int DA[], int dimensao){
    DA[C]=0;
    for (int i=1; i<dimensao; i++){
        DA[i] = 10000;
        cout << "Elemento " << i << ": " << DA[i] << endl;
                                 }

                                            }

void matrixDistancias(int D[][tamanho], int dimensao){
    int M[3][6] = { 0, 100, 10, 0, 0, 0, 100, 0, 40, 180, 200, 0, 15, 40, 0, 45, 90, 0 };
    
    for (int i=0; i<(dimensao/2); i++){
        for (int j=0; j<dimensao; j++){
            
            cout << "Elemento" << "D[" << i << "][" << j << "]" << endl;
            D[i][j]=M[i][j];
            cout << D[i][j] << "---" << endl;
                                      }
                                  }    

                                                     }
