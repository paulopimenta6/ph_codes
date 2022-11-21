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
public class OrdemArray {
    
    public static void iniciaArray(int n){
        int i = 0;
        int array[];
        int arrayOrd[] = new int[n];        
        Scanner sc = new Scanner(System.in);
        
        while(i<n){
            System.out.printf("Digite o elemento [%d]: ", i);
            arrayOrd[i] = sc.nextInt();
            i = i + 1;            
        }
        array = Arrays.copyOf(arrayOrd,arrayOrd.length);
        Arrays.sort(array);        
        boolean resu = Arrays.equals(array, arrayOrd);
        
        System.out.println("-------------------------------------------------");
        System.out.println("Array Ordenado");
        i = 0;
        while (i < array.length){
            System.out.printf(" [%d]: %d\n", i, array[i]);
            i = i + 1;
        }
        System.out.println("++++++++++++++++++++++++++++++++++++++++++++++++++");
        System.out.println("Array Original");
        i = 0;
        while (i < array.length){
            System.out.printf(" [%d]: %d\n", i, arrayOrd[i]);
            i = i + 1;
        }        
        
        if(resu){
            System.out.println("Os arrays sao iguais!");
        }
        else{
            System.out.println("Os arrays nao sao iguais!");
        }
        
    }    
    public static void main(String args[]){
        Scanner sc = new Scanner(System.in);
        System.out.print("Digite um valor para o tamanho do vetor: ");
        int tamanho = sc.nextInt();        
        
        iniciaArray(tamanho);
        
    }
    
}
