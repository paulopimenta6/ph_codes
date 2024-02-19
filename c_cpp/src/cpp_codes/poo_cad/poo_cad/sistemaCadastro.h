#ifndef CADASTRO_H
#define CADASTRO_H

class Cadastro{
    private:
        int isbn;
        int year;
        std::string name;
        int edition;
    public:
        Cadastro();

        void setIsbn(int);
        void setYear(int);
        void setName(std::string);
        void setEdition(int);

        int getIsbn();
        int getYear();
        std::string getName();
        int getEdition();
};
#endif
