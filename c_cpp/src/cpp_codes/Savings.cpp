#include <cstdio>
#include <cstdlib>
#include <iostream>
#include "Savings.h"

using namespace std;

int main()
{
    Savings s;
	s.accountNumber = 123456;
	s.balance = 0.0;
	
	cout << "Depositing 10 to account " << s.accountNumber << endl;
	s.deposit(10);
	cout << "Balance is " << s.balance << endl;
	
	cout << "Press ENTER to continue..." << endl;
	cin.ignore(10, '\n');
	cin.get();
	return 0;	
}