/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package estudojavalivro;

/**
 *
 * @author Paulo Pimenta
 */
public class Biwise {
    public static void main(String args[]){
        byte a = 0x1F;
        byte b = 0x10;
        
        System.out.println("Valores a = " + a + ", b = " + b);
        
        System.out.println("a & b = " + (a & b));
        System.out.println("a | b = " + (a | b));
        System.out.println("a ^ b = " + (a ^ b));
        System.out.println("~ b = " + (~ b));
        System.out.println("a << 2 = " + (a << 2));
        System.out.println("-a >> 4 = " + (a >> 4));
        System.out.println("-a >> 4 = " + (a >>> 4));
    }
    
}
