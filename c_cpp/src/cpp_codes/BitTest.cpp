#include <cstdio>
#include <cstdlib>
#include <iostream>

using namespace std;

int main()
{
    cout.unsetf(cout.dec); //"desSetando o formato decimal
    cout.setf(cout.hex); //configura para o padrao de saida hexadecimal

    int nArg1 = 0x78ABCDEF; //inicializando os numeros no formato hexadecimal
    int nArg2 = 0x12345678;

    //inicio das operacoes com hexadecimal
    cout << "  nArg1 = 0x"  << nArg1 << endl;
    cout << " ~nArg1 = 0x" << ~nArg1 << "\n" << endl;
    cout << " nArg2  = 0x" << nArg2 << endl;
    cout << " ~nArg2 = 0x" << ~nArg2 << "\n" << endl;

    //com os operadores binarios
    cout << "   0x"   << nArg1     << "\n"
         << " & 0x" << nArg2     << "\n"
         << " ---------------- " << "\n"
         << "   0x" << (nArg1 & nArg2) << "\n" << endl;


    cout << " 0x"   << nArg1     << "\n"
         << " 0x" << nArg2     << "\n"
         << " ---------------- " << "\n"
         << " 0x" << (nArg1 | nArg2) << "\n" << endl;


    cout << " 0x" << nArg1     << "\n"
         << " 0x" << nArg2     << "\n"
         << " ---------------- " << "\n"
         << " 0x" << (nArg1 ^ nArg2) << "\n" << endl;


    return 0;
}
