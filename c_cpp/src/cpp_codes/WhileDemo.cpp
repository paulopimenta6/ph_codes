#include <cstdio>
#include <cstdlib>
#include <iostream>

using namespace std;

int main()
{
    int nLoopCount = 0;


    while (nLoopCount <= 0)
    {
        cout << "Enter loop count: ";
        cin >> nLoopCount;
    }

    while (nLoopCount > 0)
    {
        cout << "Only: " << nLoopCount << " loops top go" << endl;
        nLoopCount--;
    }
}
