#include <cstdio>
#include <cstdlib>
#include <iostream>

using namespace std;

int main(int nNumberOfArgs, char* pszArgs[])
{
    int celsius;
    int farenheit;
    const int factor = 180;

    cout << "Enter the temperature in Celsius: ";
    cin >> celsius;

    farenheit = factor * celsius/100 + 32;

    cout << "Farenheit  is: " << farenheit << endl;

    cout << "Press Enter to continue..." << endl;
    cin.get();
    return 0;
}
