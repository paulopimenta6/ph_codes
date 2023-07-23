#include <iostream>
#include <cstdlib>

int main()
{
	int predicao;
	char ans;
	
	std::cout << "Bem-vindo ao programa de previsão de tempo" << std:: end;
	std::cout << "Informe dois inteiros para o mes: " << std::endl;
	std::cin >> mes;
	std::cout << "Informe dois inteiros para o dia: " << std::endl;
	std::cin >> dia;
	srand(mes*dia);
	
	std::cout << "Previsao para hoje: " << std::end;
	
	do
	{
		predicao = rand()%3;
		switch(predicao)
		{
			case 0:
				std::cout << "O dia sera ensolarado!!" << std::endl;
				break;
			case 1:
				std::cout << "O dia sera Nublado" << std::endl;
				break;				
		}
	}
		
}
