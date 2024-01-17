#include <string>
using namespace std;

class SystemUser
{
    string userName;
    string password;
    char accessLevel;
    
    public:
        SystemUser();
        ~SystemUser();
        void setUserName(string newUserName);
        void setPassword(string newUserPassword);
        void setAccessLevel(char accessLevel);
        string getUserName();
        string getPassword();
        char getAccessLevel();
};