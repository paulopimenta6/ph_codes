#include <cstdio>
#include <cstdlib>
#include <iostream>

using namespace std;

class Student
{
	public:
		double addCourse(int hours, double grade)
		{
			double weightedGPA;
			weightedGPA = semesterHours * gpa;
			semesterHours += hours;
			weightedGPA += grade * hours;
			gpa = weightedGPA/semesterHours;
			
			return gpa;
		}
		
		double semesterHours;
		double gpa;
};

int main(int nNumberOfArgs, char* pszArgs[])
{
	Student s;
	s.semesterHours = 3;
	s.gpa = 3.0;
	
	cout << "Before: s = (" << s.semesterHours << ", " << s.gpa << ")" << endl;
	
	cout << "Adding 3 hours with  a grade of 4.0" << endl;
	s.addCourse(3, 4.0);
	
	cout << "After: s = (" << s.semesterHours << ", " << s.gpa << ")";
	
	cin.ignore(10,'\n');
	cin.get();
	return 0;	
}