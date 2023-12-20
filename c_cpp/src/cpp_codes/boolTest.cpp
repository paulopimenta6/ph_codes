#include <cstdio>
#include <cstdlib>
#include <iostream>

using namespace std;

int main()
{
    cout.setf(cout.boolalpha);
    int nArg1;
    int nArg2;
    bool b;

    cout << "Input value 1: ";
    cin >> nArg1;
    cout << "Input value 2: ";
    cin >> nArg2;

    b = (nArg1 == nArg2);

    if(b)
    {
        cout << "The statement " << nArg1 << " is equals " << nArg2 << ". It is " << b << endl;
    }
    else
    {
        cout << "The statement " << nArg1 << " is not equals " << nArg2 << ". It is " << b << endl;
    }

    return 0;

}
