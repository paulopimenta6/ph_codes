/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package exemplothis;

/**
 *
 * @author Paulo Pimenta
 */
public class ExemploThis {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        System.out.println("========================");
        Point ponto = new Point(1,2);
        System.out.println(ponto.x);
        System.out.println(ponto.y);
        ponto.comparaValores(1);
        System.out.println(ponto.comparaValores(1));
        System.out.println("========================"); 
        Point novoPontoSemThis = new Point();
        System.out.println(novoPontoSemThis.x);
        System.out.println(novoPontoSemThis.y);
        novoPontoSemThis.comparaValores(9);
        System.out.println(novoPontoSemThis.comparaValores(9));
        System.out.println("========================");
        Point novoPonto = new Point(3,5);
        System.out.println(novoPonto.soma());
    }
     
}
