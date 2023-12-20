#include <cstdio>
#include <cstdlib>
#include <iostream>

using namespace std;

int main()
{
    int nArg1;
    int nArg2;

    cout << "Enter nArg1: ";
    cin >> nArg1;
    cout << "Enter nArg2: ";
    cin >> nArg2;

    cout << endl;

    if (nArg1 > nArg2)
    {
        cout << "Argument nArg1: " << nArg1 << " is greater than nArg2: " << nArg2 << endl;
    }
    else
    {
        cout << "Argument nArg1: " << nArg1 << " is not greater than nArg2: " << nArg2 << endl;
    }

    return 0;
}
