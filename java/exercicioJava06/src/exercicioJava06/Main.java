package exercicioJava06;

import java.util.Scanner;
import java.util.Locale;

public class Main {

	public static void main(String[] args) {
		Locale.setDefault(Locale.US);
		Scanner reading = new Scanner(System.in);
				
		int cod1, cod2, qt1, qt2;
		double val1, val2;
		double total = 0, total1 = 0, total2 = 0;
		
		System.out.print("Digite o codigo 1: ");
        cod1 = reading.nextInt();
        
        System.out.print("Digite a quantidade do item 1: ");
        qt1 = reading.nextInt();
        
        System.out.print("Digite o valor do item 1: ");
        val1 = reading.nextDouble();
        
        System.out.print("Digite o codigo 2: ");
        cod2 = reading.nextInt();       
        
        System.out.print("Digite a quantidade do item 2: ");
        qt2 = reading.nextInt();
        
        System.out.print("Digite o valor do item 2: ");
        val2 = reading.nextDouble();
        
        if(cod1 > 0) {
        	total1 = qt1*val1;
        }

        if(cod2 > 0) {
        	total2 = qt2*val2;
        }
        
        total = total1 + total2;
        
        System.out.printf("O total da compra foi: %.2f", total);
        reading.close();
	}

}
