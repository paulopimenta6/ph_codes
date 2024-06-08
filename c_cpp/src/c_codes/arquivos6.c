#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE * finput;

    int b;
    char a[10];
    char c[10];

    finput = fopen("input.txt", "r");

    //for (i = 0; i < 3; i++)
    if(finput!=NULL){
        fscanf(finput, "%s %d %s\n", a, &b, c);
        printf("%s %d %s\n", a, b, c);
    }

    fclose(finput);
    return 0;
}
