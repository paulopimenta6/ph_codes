#include <iostream>
#include "sistemaCadastro.h"
#include "parametros.h"

using namespace std;

Cadastro *book[N];

void menuInicial();
void initBooks();
void addBook();
void showBook();


int main(){
    flagBook = true;
    int opt;
    initBooks();

    cin >> opt;
    switch(opt){
        case 1:
            cout << "Option 1 choose" << endl;
            addBook();
            showBook();
            break;
        case 2:
            cout << "Option 2 choose" << endl;
            break;
        case 3:
            cout << "Option 3 choose" << endl;
            break;
        case 4:
            cout << "Option 4 choose" << endl;
            break;
        case 5:
            cout << "Option 5 choose" << endl;
            showBook();
            break;
        case 6:
            cout << "Option 6 choose" << endl;
            break;
        default:
            cout << "Option wrong. Try again" << endl;
            break;
}

    return 0;

}

void menuInicial(){
    cout<<"LIBRARY MANAGEMENT SYSTEM\n\n";
    cout<<"[1]ADD BOOK\n";
    cout<<"[2]DELETE BOOK\n";
    cout<<"[3]EDIT BOOK\n";
    cout<<"[4]SEARCH BOOK\n";
    cout<<"[5]VIEW ALL BOOKS\n";
    cout<<"[6]QUIT\n\n";
}

void initBooks(){
    int i;

    for(i = 0; i < N; i++){
        book[i] = new Cadastro();
    }
}

void addBook(){
    int isbn;

    cout << "Press ISBN number: ";
    cin >> isbn;
    book[0]->setIsbn(isbn);
}

void showBook(){
    cout << "Book[s] is/are:" << endl;
    cout << book[0]->getIsbn();
}
