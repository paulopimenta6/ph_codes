#include <iostream>
#include "carro.h"
#include "parametros.h"

using namespace std;

int Carro::totalCarros = 0;

int main(){
	Carro *carros[N];
	Carro carro_estatico1;
	Carro carro_estatico2;
	
	carro_estatico1.apresentacao();
	
	carro_estatico2.setModelo("Brasilia");
	carro_estatico2.setCor("Amarelo");
	carro_estatico2.setAno("1997");
	carro_estatico2.setPreco("6500");
	
	cout << "Carro estatico 2: " << carro_estatico2.getModelo() << endl;
	carro_estatico2.apresentacao();
	
	Carro::mostrarTotalCarros();
	
	carros[0] = new Carro("Duster", 2016, 25000, "prata");
    carros[1] = new Carro("BMW", 2015, 27000, "branco");		
	
	carros[0]->apresentacao();
	carros[1]->apresentacao();
	
	Carro::mostrarTotalCarros();
	
	delete carros[0];
	delete carros[1];
	
	cout << "Total de carros: " << Carro::getTotal() << endl;
	
	carros[0] = new Carro();
	carros[0]->setModelo("Fuscao");
	carros[0]->setAno(1985);
	
	carros[1]= new Carro("Ford Ka", 2014, 2700, "preto");	
    carros[2]= new Carro("Fiesta", 2010, 2700, "preto");
	
	Carro::mostrarTotalCarros();
	
	carros[0]->apresentacao();
	carros[1]->apresentacao();
    carros[2]->apresentacao();	
			
	delete carros[0];
	delete carros[1];
	delete carros[2];		
			
	return 0;
}