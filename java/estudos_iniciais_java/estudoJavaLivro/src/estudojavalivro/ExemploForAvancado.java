/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package estudojavalivro;

/**
 *
 * @author Paulo Pimenta
 */
public class ExemploForAvancado {
    public static void main(String args[]){
        double arranjo[] = {1.1964, 6.1995, 6.1935, 7.1931, 12.1968};
        int tamanho = arranjo.length;
        
        System.out.print("For comum: [ ");
        for(int i = 0; i< tamanho; i++){
            System.out.print(arranjo[i] + " ");
        }
        System.out.println("] Fim");
        
        System.out.println("--------------------------");
        System.out.print("For avançado [ ");
        for(double elemento: arranjo){
            System.out.print(elemento + " ");
        }
        System.out.println(" ] Fim");
    }
    
}
