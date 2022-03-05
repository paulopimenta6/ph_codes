#include <iostream>
#include <cstdlib>
#include <stack>
#include <list>
using namespace std;

int main(){
	
	list<string> pilha;
	pilha.push_back("c++");
	pilha.push_back("c");
	pilha.push_back("python");
	pilha.push_back("perl");
	
	//mostra o elemento do topo
	while(!pilha.empty()){
		cout << "primeiro elemento da pilha: " << pilha.front() << endl;
		//cout << "primeiro elemento da pilha: " << pilha.back() << endl;
	    cout << "tamanho da pilha: " << pilha.size() << endl;
	    cout << "apagando elemento da pilha..." << endl;
	    pilha.pop_front();
	}
	if(pilha.empty()){
		cout << "pilha vazia";
	}	
}
