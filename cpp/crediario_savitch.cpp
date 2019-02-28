#include <iostream>
using namespace std;

const double PAYMENT=50.00;

int main()
{
  double principal = 1000.;
  double interest, rate = 0.015;

  int months = 0;
  cout << "months\tinterest\tprincipal" << endl;

  cout.setf(ios::fixed);
  cout.setf(ios::showpoint);
  cout.precision(2);

  while(principal > 0)
  {
    months++;
    interest = principal * rate;
    principal = principal - (PAYMENT - interest);

    if ( principal > 0 )
      cout << months << "\t\t" << interest << "\t\t"
           << principal << endl;
  }
  cout << "number of payments = " << months;
  //undo the action that drove principal negative:
  principal = principal + (PAYMENT - interest);

  //include interest for last month:
  interest = principal * 0.015;
  principal = principal + interest;
  cout << " last months interest = " << interest;
  cout << " last payment = " << principal << endl;

  return 0;
}
