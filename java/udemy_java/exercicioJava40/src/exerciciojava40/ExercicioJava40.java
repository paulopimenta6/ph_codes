package exerciciojava40;

import java.util.Locale;
import java.util.Scanner;
import entities.Pessoa;

/**
 *
 * @author Paulo_Pimenta
 */
public class ExercicioJava40 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        double altura;
        String genero;
        int masculino = 0; 
        int feminino = 0;
        double maior = 0.0;
        double somaAlturaM = 0.0;
        double somaAlturaF = 0.0;
        
        System.out.printf("Quantas pessoas voce vai digitar? ");
        int n = sc.nextInt();
        
        Pessoa[] pessoa = new Pessoa[n];
        
        for(int i=0; i<pessoa.length; i++){
            System.out.printf("Dados da %da pessoa:%n", i+1);
            
            System.out.print("Altura: ");
            altura = sc.nextDouble();            
            sc.nextLine();
            System.out.print("Genero: ");
            genero = sc.nextLine();            
            
            pessoa[i] = new Pessoa(altura, genero);            
        }
        
        double menor = pessoa[0].getAltura();
        for(int i = 0; i < pessoa.length; i++){
            if(pessoa[i].getGenero().equals("M")){
                masculino += 1;
                somaAlturaM += pessoa[i].getAltura();
            } else{
                feminino += 1;
                somaAlturaF += pessoa[i].getAltura();
            }
            
            if(maior < pessoa[i].getAltura()){
                maior = pessoa[i].getAltura();
            }
            
            if(menor > pessoa[i].getAltura()){
                menor = pessoa[i].getAltura();
            }
        }
        
        double mediaAlturaM = (masculino > 0 ? somaAlturaM/masculino : 0.0);
        double mediaAlturaF = (feminino > 0 ? somaAlturaF/feminino : 0.0);
        
        System.out.printf("Maior altura: %.2f%n", maior);
        System.out.printf("Menor altura: %.2f%n", menor);
        System.out.printf("Numero de homens: %d%n", masculino);
        System.out.printf("Numero de mulheres: %d%n", feminino);
        System.out.printf("Media de altura das homens: %.3f%n", mediaAlturaM);
        System.out.printf("Media de altura das mulheres: %.3f%n", mediaAlturaF);
        
        sc.close();
    
    }
    
}
