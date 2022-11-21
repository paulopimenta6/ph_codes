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
public class saidaFormatada {
    public static void main(String args[]){
        Scanner sc = new Scanner(System.in);
        System.out.println("No final? ");
        int limite = sc.nextInt();
        int soma = 0;
        for(int i = 1; i<=limite; i++){
            System.out.printf("%dA soma parcial = %d%n", i, soma);
            soma += i;
        }
    }
    
}
