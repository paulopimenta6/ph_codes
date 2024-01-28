#include <iostream>
#include <limits>
#include "cadastro.h"

using namespace std;

Pessoa::Pessoa(){
}

void Pessoa::cadastrar(){
	int inputSexo;
	cout << "Digite o nome: ";
	cin >> nome;
	
	//validar idade --> nao aceitar numeros negativos
	
	do{
		cout << "Digite a idade: ";
		cin >> idade;
		if(cin.fail()){
			cout << "Digite um numero inteiro" << endl;
			cin.clear();
			cin.ignore(std::numeric_limits<streamsize>::max(), '\n');
			idade = -1; //forcando o laco de repeticao para situacoes de erro na entrada de dados  
		} 
	}while(idade < 0);
	
	cout << "Selecione o sexo: 1 - Masculino e 2 - Feminino" << endl;
	cin >> inputSexo;
	
	switch(inputSexo){
		case 1:
			sexo = 'M';
		break;
		case 2:
			sexo = 'F';
		break;
		default:
			sexo = 'M';
		break;		
	}
}

	void Pessoa::mostrar(){
		if (sexo == 'F' && idade > 30){
			cout << nome << " nao e elegante perguntar a idade de uma mulher. " << endl;
		} else{
			cout << nome << "-" << idade << " anos-" << sexo << endl;
		}
	} 	
	
	
	
	
	
	
	
	