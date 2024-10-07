package maior_numero;

import java.util.Locale;
import java.util.Scanner;

public class Main {
    
    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        int posmaior;
        double maior;
        
        System.out.print("Digite o tamanho do vetor: ");
        int n = sc.nextInt();
        
        int[] vector = new int[n];
        
        for(int i=0; i<vector.length; i++){
            sc.nextLine();
            System.out.printf("Digite [%d] valor: ", i+1);
            vector[i] = sc.nextInt();
        }
        
        for(int i = 0; i < vector.length; i++){
           System.out.printf("[%d] = %d%n", i+1, vector[i]);
        }
        
        posmaior = 0;
        maior = vector[0];
        
        for(int i = 0; i < vector.length; i++){
            if(maior < vector[i]){
                maior = vector[i];
                posmaior = i;
            }
        }
        
        System.out.printf("O maior e: %.2f%n", maior);
        System.out.printf("A posicao de maior valor e: %d%n", posmaior + 1);
        
        sc.close();
    }
    
}