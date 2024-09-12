package exercicioJava04;

import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Scanner reading = new Scanner(System.in);
		
		System.out.print("Digite o valor de A: ");
		int A = reading.nextInt();
		
		System.out.print("Digite o valor de B: ");
		int B = reading.nextInt();
		
		System.out.print("Digite o valor de C: ");
		int C = reading.nextInt();
		
		System.out.print("Digite o valor de D: ");
		int D = reading.nextInt();
		
        int diferenca = (A*B-C*D);
        System.out.printf("O valor da diferenca: %d", diferenca);
        reading.close();
		
	}

}
