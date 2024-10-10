package exerciciojava39;

import java.util.Locale;
import java.util.Scanner;
import entities.Pessoa;

/**
 *
 * @author Paulo_Pimenta
 */
public class ExercicioJava39 {
    
    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        double nota1, nota2;
        String nome;
                
        System.out.printf("Quantas pessoas voce vai digitar? ");
        int n = sc.nextInt();
        
        Pessoa[] pessoa = new Pessoa[n];
        
        for(int i=0; i<pessoa.length; i++){
            sc.nextLine();
            System.out.printf("Dados da %da pessoa:%n", i+1);
            
            System.out.print("Nome: ");
            nome = sc.nextLine();            
            System.out.print("Nota 1: ");
            nota1 = sc.nextDouble();
            System.out.print("Nota 2: ");
            nota2 = sc.nextDouble();
            
            pessoa[i] = new Pessoa(nome, nota1, nota2);            
        }
        
        System.out.printf("Lista de aprovados: %n");
        for(int i = 0; i < pessoa.length; i++){
            pessoa[i].aprovadoOunao();
        }
    }
    
}
