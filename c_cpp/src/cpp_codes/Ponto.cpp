#include "Ponto.h"

Ponto::Ponto() {
    x = 0; 
    y = 0;
}

Ponto::Ponto(int novoX, int novoY){
	x = novoX;
	y = novoY;
}

int Ponto::getX() const{
	return x;
}

int Ponto::getY() const{
	return y;
}