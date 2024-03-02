#include <ncurses.h>

int main() {
    // Inicializa a biblioteca ncurses
    initscr();

    // Desativa o buffering de entrada, permitindo a leitura de um caractere por vez
    cbreak();

    // Imprime uma mensagem na tela
    printw("Digite algo e pressione Enter (ou ESC para sair):\n");

    // Loop para capturar e imprimir os caracteres até que Enter seja pressionado
    while (true) {
        int ch = getch();
        if (ch == 27) { // Verifica se o caractere digitado é ESC (27 é o código ASCII para ESC)
            break; // Sai do loop se ESC for pressionado
        } else if (ch == '\n') { // Verifica se Enter foi pressionado
            break; // Sai do loop se Enter for pressionado
        } else {
            // Imprime o caractere digitado
            printw("Você digitou: %c\n", ch);
        }
    }

    // Finaliza a biblioteca ncurses
    endwin();

    return 0;
}
