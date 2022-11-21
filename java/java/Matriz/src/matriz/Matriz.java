/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package matriz;

/**
 *
 * @author Paulo Pimenta
 */
public class Matriz {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        double m[][] = new double[3][4];
        System.out.println(m.length);
        System.out.println(m[0].length);
        
        for(int l=0; l<m.length; l++){
            for(int c=0; c<m[l].length; c++){
                m[l][c] = l*m[l].length + c;
                System.out.println("m[" + l + "]m[" + c + "] = " + m[l][c]);
            }
        }
    }
    
}
