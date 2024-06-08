/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package olajava;

/**
 *
 * @author Paulo Pimenta
 */
public class OlaJava {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        int i;
        String[] frase = new String[6];
        
        frase[5] = ";-)";
        frase[0] = "Caro amigo, ";
        frase[2] = "a programar em Java.";
        frase[4] = "Java na UTFPR";
        frase[1] = "convido voce a aprender";
        frase[3] = "Faca especializacao";
        
        for(i = 0; i < frase.length; i++){
            System.out.println(frase[i]);
        }        
    }    
}
