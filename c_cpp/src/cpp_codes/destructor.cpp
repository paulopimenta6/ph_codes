// spec1_destructors.cpp
#include <cstring> // Adicione esta linha para incluir o cabeçalho para strcpy
#include <string>  // strlen()
#include <iostream>

using namespace std;

class String
{
public:
    String(const char* ch); // Declare the constructor
    ~String();              // Declare the destructor

private:
    char* _text{nullptr};
};

// Define o construtor
String::String(const char* ch)
{
    size_t sizeOfText = strlen(ch) + 1; // +1 para considerar o caractere nulo de término

    // Aloca dinamicamente a quantidade correta de memória.
    _text = new char[sizeOfText];

    // Se a alocação for bem-sucedida, copie a string de inicialização.
    if (_text)
    { 
        strcpy(_text, ch); // Correção: Remova o argumento sizeOfText daqui
        std::cout << ch << std::endl;
    }
}

// Define o destrutor.
String::~String()
{
    // Desaloca a memória que foi reservada anteriormente para a string.
    delete[] _text;
}

int main()
{
    String str("We love C++");
    // Adicione qualquer código adicional ou lógica que você deseja aqui.
    // O objeto 'str' será automaticamente destruído quando sair deste escopo.
    return 0;
}
