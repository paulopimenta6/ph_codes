/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package estudojavalivro;

/**
 *
 * @author Paulo Pimenta
 */
public class perimetro{ 
        public static void main(String args[]){
            double L1 = 12.5;
            double L2 = 37.8;
            double area;
            double perimetro;
            
            area = (L1*L2);
            perimetro = (2*L1 + 2*L2);
            
            System.out.printf("L1: %.3f e L2: %.3f\n", L1, L2);
            System.out.printf("Area...: %.3f\n", area);
            System.out.println("Perimetro...:" + perimetro);
            
        }

    
}
