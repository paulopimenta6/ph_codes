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
public class contagem {
    public static void main(String args[]){
        System.out.print("Digite um valor: ");
        Scanner val = new Scanner(System.in);
        int N = val.nextInt();
        
        while(N>=0){
            System.out.println("valor inteiro...:" + N);
            N--;
        }
    }
    
}
