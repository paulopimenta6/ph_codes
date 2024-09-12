/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package dobro;

/**
 *
 * @author Paulo Pimenta
 */
public class Dobro {
    private static int instancias = 0;
    public int ultimoValor;
    
    public Dobro(){
        instancias++;
    }
    
    public static int getInstancias(){
        return instancias;
    }
    
    public int dobro(int valor){
        ultimoValor = valor;
        return 2*valor;
    }
            
}
