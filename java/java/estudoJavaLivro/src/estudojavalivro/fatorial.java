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
public class fatorial {
    
    public static int fatorial(int n){
        if (n == 0){
            return 1;
        }
        
        if (n==1){
            return 1;
        }
        else{
            return n*fatorial(n-1);
        }
    }
    
    public static void main(String args[]){
        int resuFatorial;
        
        Scanner sc = new Scanner(System.in);
        System.out.print("Digite um valor: ");
        int valor = sc.nextInt();
        
        System.out.printf("O resultado do fatorial de %d e: %d\n", valor, fatorial(valor));
        
    }
    
}
