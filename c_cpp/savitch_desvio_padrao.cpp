#include <iostream>
#include <cmath>
using namespace std;
//returns the arithmetic mean of the four arguments.
double stdDev(double s1, double s2, double s3, double s4);
//returns the standard deviation of the four arguments.
double  average(double s1, double s2, double s3, double s4);

int main()

{
  double s1, s2, s3, s4;
  double stdDeviation, avg;
  char ans;

  do{
    cout << "Enter four values, separated by white space and"
         << "terminated with <CR> \n"
         << "I will compute the average and standard "
         << "deviation.\n";
    cin >> s1 >> s2 >> s3 >> s4;
    avg = average(s1, s2, s3, s4);
    stdDeviation = stdDev(s1, s2, s3, s4);

    cout << "The Average is: " << avg << endl;
    cout << "The Standard Deviation is: "
         << stdDeviation << endl;
    cout << "Y/y continues, any other quits.\n";
	cin >> ans;
  } while(ans == 'y' || ans == 'Y');

  return 0;
}

double average(double s1, double s2, double s3, double s4){
double resultado;

resultado=(s1+s2+s3+s4)/4;

return(resultado);
}

double  stdDev(double s1, double s2, double s3, double s4)
{
  double a = average(s1, s2, s3, s4);
  return sqrt(average((s1-a) * (s1-a), (s2-a) * (s2-a),
                      (s3-a) * (s3-a), (s4-a) * (s4-a)));
}

