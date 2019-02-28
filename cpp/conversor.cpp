#include <iostream>
using namespace std;

void input(int& feet, double& inches);
void convert (int& feet, double& inches, double& meters);
void output(int& feet, double& inches, double& meters);

int main()
{
  int feet;
  double inches, meters;
  char ans;

  do
  {
    input(feet, inches);
    cout << "input: " << feet << " " << inches << endl;
    convert(feet, inches, meters);
    cout << "convert: " << feet << " " << inches << endl;
    output(feet, inches, meters);

    cout << "Y or y continues, any other character quits "
         << endl;
    cin >> ans;
  } while('Y' == ans || 'y' == ans);

  return 0;
}

void input(int& feet, double& inches)
{
  cout << "Enter feet as an integer: " << endl;
  cin >> feet;
  cout << "Enter inches as a double: " << endl;
  cin >> inches;
}

const double METERS_PER_FOOT = 0.3048;
const double INCHES_PER_FOOT = 12.0;

void convert(int& feet, double& inches, double& meters)
{
  meters = METERS_PER_FOOT * (feet + inches/INCHES_PER_FOOT);
}

void output(int& feet, double& inches, double& meters)
{
  //inches, meters displayed as a number with two decimal places

  cout.setf(ios::showpoint);
  cout.setf(ios::fixed);
  cout.precision(2);
  cout << "the value of feet, inches: " << feet << "," << inches << endl;
  cout << "converted to meters, centimeters is: " << meters << endl;

}
