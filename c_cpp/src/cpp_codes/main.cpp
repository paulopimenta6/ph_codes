#include <iostream>
#include "Ponto.h"

using namespace std;

int main(){
	Ponto ponto1;
	Ponto ponto2(3,4);
	
	cout << "Coordenadas do ponto1: X: " << ponto1.getX() << " Y: " << ponto1.getY() << endl;
	cout << "Coordenadas do ponto2: X: " << ponto2.getX() << " Y: " << ponto2.getY() << endl;
	
	return 0;
}