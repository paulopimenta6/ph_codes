//g++ -std=c++17 player.cpp -o player
#include <iostream>
#include <string>
#include <map>
#include <filesystem>
#include <cstdlib>
#include <vector>
#include <algorithm>
#include <thread>

namespace fs = std::filesystem;
const std::string music_path = "/home/paulo/Música/Best of - Jamiroquai - Greatests hits";

int main(){
    std::map<int, std::string> musicas;
    std::vector<std::string> arquivos;
    int index = 1;
    int escolha = -1;
    
    for(const auto& entry : fs::directory_iterator(music_path)){
        if(entry.is_regular_file()){
            std::string ext = entry.path().extension();
            if(ext == ".m4a" || ext == ".mp3" || ext == ".wav"){                
                arquivos.push_back(entry.path().filename().string());
            }         
        }
    }
    std::sort(arquivos.begin(), arquivos.end());
    for(const auto& arquivo : arquivos){
        musicas[index++] = arquivo;
    }   

    if(musicas.empty()){
        std::cout << "Nenhuma musica encontrada no diretorio: " << music_path << std::endl;
        return 0;
    } 

    while(true){
        std::cout << "\n====================================\n";
        std::cout << "Player de Musica - Paulo Pimenta\n";
        std::cout << "====================================\n";

        for(size_t i = 0; i < arquivos.size(); i++){
            std::string nome = fs::path(arquivos[i]).stem().string();
            if(escolha == -1){
                std::cout << i + 1 << " - " << nome << std::endl; 
            }            
        }

        std::cout << "Escolha uma musica [1 - " << musicas.size() << "] ou 0 para sair: ";
        std::cin >> escolha;

        if(!std::cin){
            std::cin.clear();
            std::cin.ignore(10000, '\n');
            std::cout << "\nEntrada invalida! Tente novamente." << std::endl;
            continue;
        }

        if (escolha == 0){
            std::cout << "Saindo do player de musica! Ate mais!" << std::endl;
            break;
        }

        if(musicas.count(escolha)){
            std::string arquivo = music_path + "/" + musicas[escolha];
            std::string comando = "ffplay -nodisp -autoexit \"" + arquivo + "\" > /dev/null 2>&1 &";
            //std::string duracao = "ffprobe -v error -show_entries format=duration -of csv=p=0 \"" + arquivo + "\"";
            std::cout << "===============================================================" << std::endl;
            std::cout << "Tocando agora: " << fs::path(musicas[escolha]).stem().string() << std::endl;
            //std::cout << "Duracao: " << duracao << std::endl;
            std::system(comando.c_str());
            std::cout << "===============================================================" << std::endl;
            std::this_thread::sleep_for(std::chrono::seconds(20)); // Give ffplay time to start  
            escolha = -1; // Reset choice to show the list again             
        } else {
            std::cout << "Escolha invalida! Tente novamente. " << std::endl;
        }
    }
    return 0;
}