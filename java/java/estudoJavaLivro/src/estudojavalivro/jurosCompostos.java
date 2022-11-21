/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package estudojavalivro;
import java.io.PrintStream;
import java.util.Scanner;
import java.lang.Math;
/**
 *
 * @author Paulo Pimenta
 */
public class jurosCompostos {
    public static void main(String args[]){
        
        double juros = (0.5/100); //i
        int t;
        
        //M = (C+i)^t
        System.out.print("Digite o valor para o montante desejado...: ");
        Scanner val_montante = new Scanner(System.in);
        double montante = val_montante.nextDouble();
        
        System.out.print("Digite o valor para o deposito desejado...: ");
        Scanner val_deposito = new Scanner(System.in);
        double deposito = val_deposito.nextDouble();

        /* 
        System.out.print("Digite o tempo desejado da aplicação...: ");
        Scanner val_tempo = new Scanner(System.in);
        int t = val_tempo.nextInt();
        */
        
        t = (int) ((Math.log(montante/deposito))/(Math.log(1+juros)));
                
        System.out.printf("O tempo em meses é...: %d\n", t);
        
    } 
    
}
