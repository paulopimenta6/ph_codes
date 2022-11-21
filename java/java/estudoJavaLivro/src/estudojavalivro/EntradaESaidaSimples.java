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
public class EntradaESaidaSimples {
    public static void main(String args[]){
        System.out.println("Olá!");
        System.out.print("Digite um numero inteiro: ");
        Scanner sc = new Scanner(System.in);
        int num = sc.nextInt();
        System.out.printf("Valor = %d\n", num);
        sc.close();
    }
    
}
