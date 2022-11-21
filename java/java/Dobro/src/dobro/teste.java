/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dobro;

/**
 *
 * @author Paulo Pimenta
 */
public class teste {
    public static void main(String args[]){
        System.out.println(Dobro.getInstancias());                
        System.out.println("================================");
        Dobro dobro = new Dobro();
        int nNovo = dobro.getInstancias();
        System.out.println(nNovo);
        System.out.println("================================");
        Dobro dobro_1 = new Dobro();
        int n_1 = dobro_1.getInstancias();
        System.out.println(n_1);
        System.out.println(Dobro.getInstancias());
    }
    
}
