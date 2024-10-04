package exerciciojava34;

import java.util.Locale;
import java.util.Scanner;
import entities.Pessoa;

/**
 *
 * @author Paulo_Pimenta
 */
public class ExercicioJava34 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        double soma_altura = 0.0;
        double soma_below_16 = 0.0;
        
        System.out.print("Digite a quantidade de pessoas: ");
        int n = sc.nextInt();
        Pessoa[] pessoa = new Pessoa[n];
        
        System.out.println("");
        for(int i = 0; i < pessoa.length; i++){
            System.out.printf("Digite o %da nome: ", i+1);
            sc.nextLine();
            String name = sc.nextLine();
            
            System.out.print("Digite a idade: ");
            int age = sc.nextInt();
            
            System.out.print("Digite a altura: ");
            double height = sc.nextDouble();                     
            pessoa[i] = new Pessoa(name, age, height);            
        }
        
        for(int i = 0; i < pessoa.length; i++){
            soma_altura += pessoa[i].getHeight();            
        }
        double media_altura = soma_altura/(pessoa.length);
        
        System.out.println("===============================================");
        System.out.printf("Media das alturas: %.2f%n", media_altura);
        
        System.out.println("===============================================");
        for(int i = 0; i < pessoa.length; i++){
            if(pessoa[i].getAge() < 16){
                System.out.printf("%s%n", pessoa[i].getName());
                soma_below_16 += 1;
            }
        }
        double percent_below_16 = ((soma_below_16)/(pessoa.length))*100;
        System.out.printf("Porcentagem com menos de 16 anos: %.2f%%\n", percent_below_16);
        
        sc.close();
        
    }
    
}
