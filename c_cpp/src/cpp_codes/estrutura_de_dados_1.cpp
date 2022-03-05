#include <iostream>
#include <cstdlib>
#include <stack>
using namespace std;

int main(){
	
	stack<int> pilha;
	pilha.push(1);
	pilha.push(2);
	pilha.push(3);
	
	//mostra o elemento do topo
	while(!pilha.empty()){
		cout << "primeiro elemento da pilha: " << pilha.top() << endl;
	    cout << "tamanho da pilha: " << pilha.size() << endl;
	    cout << "apagando elemento da pilha..." << endl;
	    pilha.pop();
	}
	if(pilha.empty()){
		cout << "pilha vazia";
	}	
}
