/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package saidaformatada;

import java.util.Scanner;

/**
 *
 * @author Paulo Pimenta
 */
public class SaidaFormatada {

    public static void main(String[] args) {
        // TODO code application logic here
        Scanner sc = new Scanner(System.in);
        System.out.print("No final? ");
        int limite = sc.nextInt();
        int soma = 0;
        for (int i=1; i<=limite; i++){
            System.out.printf("%da. soma parcial = %d%n", i, soma);
            soma+=i;
        }
        System.out.printf("Soma total[0..%d] = %d%n", limite, soma);
        }
        
    }
