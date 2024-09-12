/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package estudojavalivro;
import java.util.Scanner;
import java.util.Arrays;
/**
 *
 * @author Paulo Pimenta
 */
public class pluviometro {
    public static void main(String args[]){
        double chuva_dias[] = new double[5];
        double chuva_dias_ord[] = new double[5];
        double menor;
        double maior;
        Scanner sc = new Scanner(System.in); //prepara o console para receber as variaveis       
        
        for (int i=0; i < chuva_dias.length; i++){
            System.out.print("Digite um valor de temperatura de indice [" + i + "]: ");
            chuva_dias[i] = sc.nextDouble();
        }
        
        chuva_dias_ord = Arrays.copyOf(chuva_dias, chuva_dias.length);
        Arrays.sort(chuva_dias_ord);
        int indexMin = achaMinIndex(chuva_dias);
        int indexMax = achaMaxIndex(chuva_dias);
        double media_Pluv = calcMedia(chuva_dias);
        
        System.out.println("========================================================================");
        System.out.println("========== Indices Pluviometricos ==========");
        for (int i=0; i < chuva_dias.length; i++){
            System.out.printf("Valor de temperatura de indice [%d]: %.2f\n", i,chuva_dias[i]);
        }
        System.out.println("========================================================================");
        System.out.println("========== Indices Pluviometricos Ordenados ==========");
        for (int i=0; i < chuva_dias_ord.length; i++){
            System.out.printf("Valor de temperatura de indice [%d]: %.2f\n", i,chuva_dias_ord[i]);
        }
        
        System.out.println("========================================================================");
        System.out.println("========== Indices Estatisticos Pluviometricos ==========");
        System.out.printf("Minimo - [%d]: %.2f\n", indexMin, chuva_dias[indexMin]);
        System.out.printf("Maximo - [%d]: %.2f\n", indexMax, chuva_dias[indexMax]);
        System.out.printf("Media: %.2f\n", media_Pluv);
        
        
    }

    public static int achaMinIndex(double[] vetorPluv){
        double menor = vetorPluv[0];
        int menor_indice = 0;
        
        for(int i = 1; i < vetorPluv.length; i++){
            if(vetorPluv[i] < menor){
                menor = vetorPluv[i];
                menor_indice = i;
            }
        }        
        
        return menor_indice;
    }

    public static int achaMaxIndex(double[] vetorPluv){
        double maior = vetorPluv[0];
        int maior_indice = 0;
        
        for(int i = 1; i < vetorPluv.length; i++){
            if(vetorPluv[i] > maior){
                maior = vetorPluv[i];
                maior_indice = i;
            }
        }        
        
        return maior_indice;
    }
    
    public static double calcMedia(double[] vetorPluv){
        double tamanho = vetorPluv.length;
        double soma = 0;
        double media;
        
        for(int i = 1; i < vetorPluv.length; i++){
            soma += vetorPluv[i];
        }        
        
        media = (soma/tamanho);
        
        return media;        
    }

    
}
