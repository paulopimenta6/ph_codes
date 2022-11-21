/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package estudojavalivro;
import java.util.Scanner;

/**
 *
 * @author Paulo Pimenta
 */
public class somaSerie {
    public static void main(String args[]){
        double soma = 0;
        int i = 1;
        int sinal = 1;
        
        Scanner sc = new Scanner(System.in);
        System.out.print("Digite um valor: ");
        int num = sc.nextInt();
        
        while(i<=num){
            soma = soma + ((double)sinal/(double)i);
            i++;
            sinal=-sinal;             
        }
        
        System.out.printf("O valor da soma da serie e: %.2f \n", soma);
    }
    
}
