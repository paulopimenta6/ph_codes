package exerciciojava38;

import java.util.Locale;
import java.util.Scanner;
import entities.Pessoa;

/**
 *
 * @author Paulo_Pimenta
 */
public class ExercicioJava38 {
    
    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        int idade;
        String nome;
        int maisVelho = 0;
        int idxMaisVelho = 0;
        
        System.out.printf("Quantas pessoas voce vai digitar? ");
        int n = sc.nextInt();
        
        Pessoa[] pessoa = new Pessoa[n];
        
        for(int i=0; i<pessoa.length; i++){
            sc.nextLine();
            System.out.printf("Dados da %da pessoa:%n", i+1);
            System.out.print("Nome: ");
            nome = sc.nextLine();
            System.out.print("Idade: ");
            idade = sc.nextInt();
            
            pessoa[i] = new Pessoa(nome, idade);            
        }
                
        for(int i=0; i<pessoa.length; i++){
            if (maisVelho < pessoa[i].getIdade()){
                maisVelho = pessoa[i].getIdade();
                idxMaisVelho = i;
            }            
        }
        
        System.out.printf("O mais velho e: %s%n", pessoa[idxMaisVelho].getNome());
        
    }
    
}
