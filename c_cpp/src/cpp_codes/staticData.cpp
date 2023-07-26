//StaticData.cpp
//mostra membros de dados static
#include <iostream>

using namespace std;

class Rec
{
	private:
		static int n;
	public:
		Rec(){ n++; }		
		int GetRec() const {return n;}
		~Rec() { n--; }
};

int Rec::n= 0;

int main()
{
	Rec r1, r2, r3;
	
	cout << r1.GetRec() << endl;
	cout << r2.GetRec() << endl;
	cout << r3.GetRec() << endl;
	
	{
		//Rec r4, r5, r6;
		//cout << r1.GetRec() << endl;
	}
	
	cout << r1.GetRec() << endl;
	cout << r2.GetRec() << endl;
	cout << r3.GetRec() << endl; 
	
	return 0;
}
