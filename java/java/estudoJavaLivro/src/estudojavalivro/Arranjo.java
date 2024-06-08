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
public class Arranjo {
    public static void main(String args[]){
        int a[] = new int[10];
        int soma = 0;
        
        Scanner sc = new Scanner(System.in);
        for(int i = 0; i<a.length; i++){
            System.out.print("a[" + i + "]: ");
            a[i] = sc.nextInt();
        }       
        for(int i = 0; i<a.length; i++){
            System.out.println("a[" + i + "] = " + a[i]);
            soma += a[i];
        }
        
        System.out.println("Soma = " + soma);
        sc.close();
    }
    
}
