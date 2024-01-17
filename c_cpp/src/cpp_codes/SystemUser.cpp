#include "SystemUser.h"
using namespace std;

SystemUser::SystemUser()
{
    userName="";
    password="";
    accessLevel="X";
}

SystemUser::~SystemUser()
{
    userName="";
    password="";
    accessLevel="X";
}

void SystemUser::setUserName(string newUserName)
{
    userName = newUserName;
}

void SystemUser::setPassword(string newPassword)
{
    userPassword = newPassword;
}

void SystemUser::setAccessLevel(string newAccessLevel)
{
    userAccessLevel = newAccesslevel;
}

void SystemUser::getUserName()
{
    return userName;
}

void SystemUser::getPassword()
{
    return userPassword;
}

void SystemUser::getAccessLevel()
{
    return userAccessLevel;
}
