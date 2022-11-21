/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package entradadados;

import java.util.Scanner;

/**
 *
 * @author Paulo Pimenta
 */
public class EntradaDados {

    /**
     * @param args the command line arguments
     */
    
    public static void main(String[] args) {
        // TODO code application logic here
        int valor;
        
        System.out.println("Ola!");
        System.out.print("Digite um int: ");
        Scanner s = new Scanner(System.in);
        valor = s.nextInt();
        System.out.println("Valor = " + valor);
        s.close();
    }
    
}
