#include <iostream>
#include <cstdlib>
using namespace std;

class DayOfYear
{
public:
    void input();
    void output();
    void set(int newMonth, int newDay);
    //pre-condicao: newmonth e newday formam a data possivel

    void set(int newMonth);
    //pre-condicao: 1<=newMonth<=12
    //pos-condicao: A data e fixada para o primeiro dia do mes dado

    int getMonthNumber(); //Retorna 1 para janeiro, 2 para fevereiro, 3 para marco e etc
    int getDay();

 private:
    int month;
    int day;
};

int main()
{
    DayOfYear today, bachBirthday;
    cout << "Informe a data de hoje: \n";
    today.input(); //funcao chamada pela classe que vai pegar a data de hoje
    cout << "A data de hoje e: "
    today.output(); //funcao chamada pela classe que vai mostrar a data de hoje
    cout << endl;

    bachBirthday.set(3, 21); //configurando a data de aniversario de Bach
}

