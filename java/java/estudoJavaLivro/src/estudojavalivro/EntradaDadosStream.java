/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package estudojavalivro;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 *
 * @author Paulo Pimenta
 */
public class EntradaDadosStream {
    public static void main(String arg[]){
        
        
        System.out.print("Entre com um valor: ");
        InputStreamReader c = new InputStreamReader(System.in);
        BufferedReader cd = new BufferedReader(c);
        String s = "";
        try{
            s = cd.readLine();
        }
        catch(IOException e){
            System.out.println("Erro de entrada");            
        }
    
        try{
            int w = Integer.parseInt(s);
            System.out.println(w);
        }
        catch(NumberFormatException nfe){
            System.out.println("Erro no input");
        }
    }
}

    

