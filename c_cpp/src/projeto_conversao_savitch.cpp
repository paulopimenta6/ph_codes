//Task: Convert between meters and feet/inches at user's
//option Within conversion, allow repeated calculation
//after end of either conversion, allow choice of another
//conversion.
//Input: At program request, user selects direction of
//conversion. Input is either feet/inches(with decimal
//fraction for inches) OR meters with 2 place decimal
//fraction that represents the centimeters.

//Output: Depends on user selection: either meters or
//feet and inches.
//Method: Suggested by problem statement: use if-else
//selection based on the user input to choose between
//functions written for problems 4 and 5 above.
//Required: functions for input, computation, and output.
//Include a loop to repeat the calculation at the user's
//option.
#include <iostream>
using namespace std;

void inputM(double& meters);
//Precondition: function is called
//Postcondition:
//Prompt given to the user for input of a number of meters
//as a double

void inputE(int& feet, double& inches);
//Precondition: function is called
//Postcondition:
//Prompt given to the user for input in the format FF II,
//where FF is an int number of feet and II is a double number
//of inches feet and inches are returned as entered by the
//user.

void convertEtoM(int feet, double inches,
                     double& meters);
//Preconditions:
//REQUIRED CONSTANTS: INCHES_PER_FOOT, METERS_PER_FOOT
//inches < 12, feet within range of values for an int
//Postconditions:
//meters assigned 0.3048 * (feet + inches/12)
//Observe that the requirement to produce centimeters is met
//by the value of the first two decimal places of meters.

void convertMtoE (int& feet, double& inches,
                     double meters);
//Preconditions:
// REQUIRED CONSTANTS: INCHES_PER_FOOT, METERS_PER_FOOT
//Postconditions:
//the variable feet is assigned the integer part of
//meters/METERS_PER_FOOT
//the variable inches is assigned the fractional part of
//feet after conversion to inch units.

void output(int feet, double inches, double meters);
//input: the formal argument for meters fits into a double
//output:
//"the value of feet, inches" <feet, inches>
//" corresponds to meters, centimeters is " <meters>
//where meters is displayed as a number with two decimal
//places

void EnglishToMetric();
// requests English measure, converts to metric, outputs both

void MetricToEnglish();
// request metric measure, converts to English, outputs both

int main()
{
  char ans;
  do
  {
    int which;
    cout << "Enter 1 for English to Metric or " << endl
         << "Enter 2 for Metric to English conversion"
         << endl;
    cin >> which;
   if(1 == which)
     EnglishToMetric();
  else
     MetricToEnglish();

  cout << "Y or y allows another choice of conversion. "
       << "any other quits" << endl;
  cin >> ans;
  } while('y' == ans || 'Y' == ans);
  return 0;
}

void MetricToEnglish()
{
  int feet;
  double inches, meters;
  char ans;
  do
  {
    inputM(meters);
    convertMtoE(feet, inches, meters);
    output(feet, inches, meters);
    cout << "Y or y continues, any other character quits "
         << endl;
    cin >> ans;
  }while('Y' == ans || 'y' == ans);
}

void EnglishToMetric()
{
  int feet;
  double inches, meters;
  char ans;
  do
  {
    inputE(feet, inches);
    convertEtoM(feet, inches, meters);
    output(feet, inches, meters);
    cout << "Y or y continues, any other character quits "
         << endl;
    cin >> ans;
  }while('Y' == ans || 'y' == ans);
}

void inputE(int& feet, double& inches)
{
  cout << "Enter feet as an integer: " << flush;
  cin >> feet;
  cout << "Enter inches as a double: " << flush;
  cin >> inches;
}

void inputM(double& meters)
{
  cout << "Enter a number of meters as a double " << endl;
  cin >> meters;
}

const double METERS_PER_FOOT = 0.3048;
const double INCHES_PER_FOOT = 12.0;

// convert English measure to Metric
void convertEtoM(int feet, double inches, double& meters)
{
  meters = METERS_PER_FOOT * (feet + inches/INCHES_PER_FOOT);
}

// convert Metric to English measure
void convertMtoE(int &feet, double& inches, double meters)
{
  double dfeet;
  dfeet = meters / METERS_PER_FOOT;
  feet = static_cast<int>(dfeet);
  inches = (dfeet - feet)*INCHES_PER_FOOT;
}

void output(int feet, double inches, double meters)
{
  // meters is displayed as a double with two decimal places
  // feet is displayed as int, inches as double with two
  //decimal places
  cout.setf(ios::showpoint);
  cout.setf(ios::fixed);
  cout.precision(2);
  cout << meters << " meters "
       << "corresponds to "
       << feet << " feet, " << inches << " inches"
       << endl;
}
