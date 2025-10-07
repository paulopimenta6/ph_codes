#include <cstdlib>
#include <iostream>
#include <string>

const std::string music_path = "/home/paulo/Música/Fernanda_Porto/Fernanda_Porto/";
struct {
    std::string musica01 = "Amor Errado";
    std::string musica02 = "Sambassim";
    std::string musica03 = "So tinha de ser com voce";
} musicas;

int main(){

    std::cout << " ---- Player de Musica do Paulo Pimenta ---- " << std::endl;
    std::cout << "Musica 1 - " << musicas.musica01 << std::endl;
    std::cout << "Musica 2 - " << musicas.musica02 << std::endl;
    std::cout << "Musica 3 - " << musicas.musica03 << std::endl;

    std::cout << "Escolha uma musica [1/2/3] " << std::endl;
    int escolha;
    std::cin >> escolha;

    switch (escolha) {
        case 1:
            std::system(("ffplay -nodisp -autoexit \"" + music_path + "Amor_Errado.m4a\"").c_str());
            break;
        case 2:
            std::system(("ffplay -nodisp -autoexit \"" + music_path + "Sambassim.m4a\"").c_str());
            break;
        case 3:
            std::system(("ffplay -nodisp -autoexit \"" + music_path + "So_Tinha_de_Ser_Com_Voce.m4a\"").c_str());
            break;
        default:
            std::cout << "Escolha invalida!" << std::endl;
            break;
    }

    return 0;
}   