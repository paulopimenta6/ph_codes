#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <initializer_list>

using namespace std;

int main()
{
    int m[] = {1, 2, 3, 5, 7, 11, 13, 17, 19};
    cout << "The primes less than 20 are: " << endl;
    for (int n : m)
    {
       cout << n << ", ";
    }
    cout << endl;

    return 0;
}
