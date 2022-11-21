/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package estudojavalivro;

/**
 *
 * @author Paulo Pimenta
 */
public class Aritmetica {
    public static void main(String args[]){
        int a = 5;
        int b = 2;
        System.out.printf("Valores: a = %d, b = %d%n", a, b);
        System.out.printf("b = %d%n", -b);
        System.out.printf("%d + %d = %d%n", a,b,(a+b));
        System.out.printf("%d - %d = %d%n", a,b,(a-b));
        System.out.printf("%d * %d = %d%n", a,b,(a*b));
        System.out.printf("%d / %d = %.2f%n", a,b,(float)(a/b));
        System.out.printf("%d mod %d = %d%n", a,b,(a%b));
        System.out.printf("a++ = %d%n", a++);
        System.out.printf("++b = %d%n", ++(b));
        System.out.printf("Valores: a = %d, b = %d%n", a, b);                
    }
    
}
