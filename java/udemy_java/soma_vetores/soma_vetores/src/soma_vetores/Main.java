package soma_vetores;

import java.util.Locale;
import java.util.Scanner;

public class Main {
    
    private static void somaVetores(int[] A, int[] B, int[] C){
        for(int i = 0; i < A.length; i++){
            C[i] = A[i] + B[i];
        }
    }
    
    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        System.out.print("Digite o tamanho do vetor: ");
        int n = sc.nextInt();
        
        int[] A = new int[n];
        int[] B = new int[n];
        int[] C = new int[n];
        
        for (int i = 0; i < A.length; i++){
            System.out.printf("Digite o valor para A[%d]: ", i+1);
            A[i] = sc.nextInt();
        }
        System.out.printf("==========================================%n");
        for (int i = 0; i < B.length; i++){
            System.out.printf("Digite o valor para B[%d]: ", i+1);
            B[i] = sc.nextInt();
        }
        
        somaVetores(A, B, C);
        
        System.out.printf("==========================================%n");
        for(int i = 0; i < C.length; i++){
            System.out.printf("Vetor Soma C[%d] = %d%n", i+1, C[i]);
        }
        
        sc.close();
    }
    
}