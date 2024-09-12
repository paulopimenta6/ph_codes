package exercicioJava02;

import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Scanner reading = new Scanner(System.in);
		int num1, num2, soma;
		char ans = 's';
		do{		
			System.out.printf("Informe o primeiro valor: ");
			num1 = reading.nextInt();
			
			System.out.printf("Informe o segundo valor: ");
			num2 = reading.nextInt();
			
			soma = num1 + num2;
			
			System.out.printf("Entrada:\t Saida: %n%d \t\t Soma: %d %n%d %n", num1, soma, num2);
			System.out.printf("Deseja continuar? ");
			ans = reading.next().charAt(0);
		}while(ans == 's' || ans =='S');
		
		reading.close();
		System.out.println("--------Programa Encerrado--------");
	}

}
