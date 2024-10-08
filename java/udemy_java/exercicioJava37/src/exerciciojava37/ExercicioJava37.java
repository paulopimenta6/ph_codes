package exerciciojava37;

import java.util.Locale;
import java.util.Scanner;


/**
 *
 * @author Paulo_Pimenta
 */
public class ExercicioJava37 {
    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        System.out.print("Digite o tamanho que o vetor deve ter: ");
        int N = sc.nextInt();
        
        int[] vector = new int[N];
        
        for(int i = 0; i < vector.length; i++){
            System.out.printf("Digite o valor de vector[%d]: ", i);
            vector[i] = sc.nextInt();
        }
        
        int qtdPares = 0, somaPares = 0;
        
        for(int i = 0; i < vector.length; i++){
            if(vector[i]%2 == 0){
                qtdPares += 1;
                somaPares += vector[i];
            }            
        }
        
        if(qtdPares>0 && somaPares>0){
            double mediaPares = (double) somaPares/qtdPares;
            System.out.printf("A media dos valores pares e: %.2f%n", mediaPares);
        }else{
                System.out.printf("Nao ha nenhum numero par %n");
            }
        
        sc.close();
    }
    
}
