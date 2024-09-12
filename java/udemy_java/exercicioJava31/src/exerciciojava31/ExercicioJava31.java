package exerciciojava31;

import java.util.Locale;
import java.util.Scanner;
import util.CurrencyConverter;

public class ExercicioJava31 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        System.out.print("What is the dollar price: ");
        double dollarRate = sc.nextDouble();
        
        System.out.print("How many dollars will be bought: ");
        double dollarValue = sc.nextDouble();
        
        double dollarToReais = CurrencyConverter.dollarConverter(dollarValue, dollarRate);
        
        System.out.println("The amount to be paid in Brazil Reais with IOF tax = " + String.format("%.2f", dollarToReais));
    }
    
}
