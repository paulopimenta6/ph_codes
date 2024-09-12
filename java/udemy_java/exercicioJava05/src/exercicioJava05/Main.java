package exercicioJava05;

import java.util.Locale;
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Locale.setDefault(Locale.US);
		Scanner reading = new Scanner(System.in);
		
		System.out.print("Digite o numero do funcionario: ");
        int num = reading.nextInt();
        
        System.out.print("Digite o numero de horas trabalhadas pelo funcionario: ");
        int horasTrab = reading.nextInt();
        
        System.out.print("Digite o numero de horas trabalhadas pelo funcionario: ");
        double valorHoras = reading.nextDouble();
        
        double salario = valorHoras*horasTrab;
        
        System.out.printf("Numero do funcionario: %d\nValor do salario %.2f\n", num, salario);
        reading.close();
        
	}

}
