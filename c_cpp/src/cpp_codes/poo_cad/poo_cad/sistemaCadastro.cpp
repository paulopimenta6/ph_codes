#include <iostream>
#include <limits>
#include "sistemaCadastro.h"

Cadastro::Cadastro(){}

//setters
void Cadastro::setIsbn(int a){
    this->isbn = a;
}

void Cadastro::setYear(int b){
    this->year = b;
}

void Cadastro::setName(std::string c){
    this->name = c;
}

void Cadastro::setEdition(int d){
    this->edition = d;
}

//getters
int Cadastro::getIsbn(){
    return this->isbn;
}

int Cadastro::getYear(){
    return this->year;
}

std::string Cadastro::getName(){
    return this->name;
}

int Cadastro::getEdition(){
    return this->edition;
}


