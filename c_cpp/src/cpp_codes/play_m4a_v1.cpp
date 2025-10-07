#include <cstdlib>
#include <iostream>
#include <string> 
#include <map>

const std::string music_path = "/home/paulo/Música/Fernanda_Porto/Fernanda_Porto/";

std::map<int, std::pair<std::string, std::string>> musicas = {
    {1, {"Amor Errado", "Amor_Errado.m4a"}},
    {2, {"Sambassim", "Sambassim.m4a"}},
    {3, {"So tinha de ser com voce", "So_Tinha_De_Ser_Com_Voce.m4a"}}
};

int main(){

    int escolha = -1;
    std::cout << " ---- Player de Musica do Paulo Pimenta ---- " << std::endl;
    
    while (true)
    {
        std::cout << "\nLista de Musica:\n";
        for (const auto& [num, info]: musicas){
            std::cout << "Musica " << num << " - " << info.first << std::endl;
        }
        std::cout << "Escolha uma musica [1 - "<< musicas.size() << "] ou 0 para sair: ";
        
        std::cin >> escolha;

        if(!std::cin){
            std::cin.clear();
            std::cin.ignore(10000, '\n');
            std::cout << "\nEntrada invalida! Tente novamente." << std::endl;
            continue;
        }

        if(escolha == 0){
            std::cout << "Saindo do player de musica! Ate mais!" << std::endl;
            break;
        }

        if(musicas.count(escolha)){
            const auto& [titulo, arquivo] = musicas[escolha];
            std::string caminho = music_path + arquivo;
            std::string comando = "ffplay -nodisp -autoexit \"" + caminho + "\"";

            std::cout << "Tocando agora: " << titulo << std::endl;
            std::system(comando.c_str());
        } else{
            std::cout << "Escolha invalida! Tente novamente." << std::endl;
        }

    }
    
    
    
    

}