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

    for (int i = nLoopCount; i > 0; i--)
    {
        cout << "Only " << i << " Loopś to go" << endl;
    }

    return 0;
}
