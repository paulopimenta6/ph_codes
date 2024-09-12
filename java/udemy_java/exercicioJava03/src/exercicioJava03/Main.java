package exercicioJava03;

import java.util.Locale;
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Locale.setDefault(Locale.US);
		Scanner reading = new Scanner(System.in);
		final double pi = 3.14159; //sera uma constante numerica
		double raio, area;
		
		System.out.print("Informe o valor do raio: ");
		raio = reading.nextDouble();
		
		area = pi*Math.pow(raio,2);
		
		
		System.out.printf("O valor da area e: %.4f", area);
		reading.close();

	}

}
