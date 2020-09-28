#include <iostream>
using namespace std;

void input(double & meters);
//Precondition: function is called
//Postcondition:
//Prompt given to the user for input of a number of meters as
//a double. input of a double for meters has been accepted

void convert(int& feet, double& inches, double meters);
//Preconditions:
// REQUIRED CONSTANTS: INCHES_PER_FOOT, METERS_PER_FOOT
//Postconditions:
//feet is assigned the integer part of meters (after
//conversion to feet units) inches is assigned the
//fractional part of feet(after conversion to inch units

void output(int feet, double inches, double meters);
//input: the formal argument for meters fits into a double
//output:
//"the value of meters, centimeters is: " <meters>
//" converted to English measure is "
//<feet> "feet, " <inches> " inches "
//where meters is displayed as a number with two decimal places

int main()
{
  int feet;
  double inches, meters;
  char ans;
  do
  {
    input(meters);
    convert(feet, inches, meters);
    output(feet, inches, meters);
    cout << "Y or y continues, any other character quits "
         << endl;
    cin >> ans;
  } while('Y' == ans || 'y' == ans);
  return 0;
}
void input(double& meters)
{
  cout << "Enter a number of meters as a double \n";
  cin >> meters;
}

const double METERS_PER_FOOT = 0.3048;
const double INCHES_PER_FOOT = 12.0;

void convert(int &feet, double& inches, double meters)
{
  double dfeet;
  dfeet = meters / METERS_PER_FOOT;
  feet = static_cast<int>(dfeet); //forma antiga int(dfeet); //posso usar um static_cast<int>(dfeet)
  inches = (dfeet - feet)*INCHES_PER_FOOT;
}

void output(int feet, double inches, double meters)
{
  //meters is displayed as a double with two decimal places
  //feet is displayed as int, inches as double with two
  //decimal places

  cout.setf(ios::showpoint);
  cout.setf(ios::fixed);
  cout.precision(2);
  cout << "The value of meters, centimeters " << endl
       << meters << " meters" << endl
       << "converted to English measure is " << endl
       << feet << " feet, " << inches << " inches"
       << endl;
}
