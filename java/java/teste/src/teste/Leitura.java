/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package teste;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.IOException;

/**
 *
 * @author Paulo Pimenta
 */
public class Leitura {
    public String entDados(String rotulo){        
        System.out.print(rotulo); 
        
        InputStreamReader InputTec = new InputStreamReader(System.in);
        BufferedReader buff = new BufferedReader(InputTec);
        String ret = "";
        try{
            ret = buff.readLine();
        }
        catch(IOException ioe){
            System.out.println("Erro de entrada");
        }
        return ret;          
    }
    
}
