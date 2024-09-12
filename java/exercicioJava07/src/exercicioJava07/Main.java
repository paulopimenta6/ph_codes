package exercicioJava07;

import java.util.Locale;
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Locale.setDefault(Locale.US);
		Scanner reading = new Scanner(System.in);
		double A, B, C;
		final double pi = 3.14159;
		
		System.out.print("Digite o valor de A: ");
		A = reading.nextDouble();
		
		System.out.print("Digite o valor de B: ");
		B = reading.nextDouble();
		
		System.out.print("Digite o valor de C: ");
		C = reading.nextDouble();
		
		double areaTriangulo = A*C/2;
		double areaCirculo = pi*Math.pow(C, 2);
		double areaTrapezio = ((A+B)*C)/2;
		double areaQuadrado = (B*B);
		double areaRetangulo = (A*B);
		
		System.out.printf("Area do triangulo: %.3f", areaTriangulo);
		System.out.printf("%nArea do circulo: %.3f", areaCirculo);
		System.out.printf("%nArea do trapezio: %.3f", areaTrapezio);
		System.out.printf("%nArea do quadradp: %.3f", areaQuadrado);
		System.out.printf("%nArea do retangulo: %.3f", areaRetangulo);
		
		reading.close();

	}

}
