/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package conversor;

/**
 *
 * @author Paulo Pimenta
 */
public class Conversor {
    protected double kProp;
    protected double kLin;
    
    public Conversor (double kProp, double kLin){
        this.kProp = kProp;
        this.kLin = kLin;
    }
     public double getkProp(){
         return kProp;
     }   
     public double getkLin(){
         return kLin;
     }
     public double converter(double valor){
         return valor*kProp + kLin;
     }
     
     @Override
     public String toString(){
         return "Conversor[kProp = " + kProp + ", kLin = " + kLin + "]";
     }
    
}
