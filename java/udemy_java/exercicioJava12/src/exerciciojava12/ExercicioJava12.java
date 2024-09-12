package exerciciojava12;

import java.util.Locale;
import java.util.Scanner;

/**
 *
 * @author paulo
 */
public class ExercicioJava12 {

    
    public static void main(String[] args) {
            Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        int opt, qtd;
        double total;
        char ans;
        
        System.out.print("Codigo - Especificacao - Preco\n");
        System.out.print("1\tCachorro Quente\tR$ 4.00\n"
                + "2\tX-Salada\tR$ 4.50\n"
                + "3\tX-Bacon\t\tR$ 5.00\n"
                + "4\tTorrada simples\tR$ 2.00\n"
                + "5\tRefrigerante\tR$ 1.50\n");
        
        do{ 
            
            System.out.print("Escolha opcao: ");
            opt = sc.nextInt();
            System.out.print("Quantidade: ");
            qtd = sc.nextInt();
            
            switch(opt){
                case 1:
                    System.out.print("O lanche escolhido foi o cachorro quente\n");
                    total = (double) qtd*4.00;
                    System.out.printf("Total: %.2f\n", total);
                    break;
                case 2:
                    System.out.print("O lanche/bebida escolhido foi o x-salada\n");
                    total = (double) qtd*4.50;
                    System.out.printf("Total: %.2f\n", total);
                    break;
                case 3:
                    System.out.print("O lanche/bebida escolhido foi o x-bacon\n");
                    total = (double) qtd*5.00;
                    System.out.printf("Total: %.2f\n", total);
                    break;
                case 4:
                    System.out.print("O lanche/bebida escolhido foi o torrada simples\n");
                    total = (double) qtd*2.00;
                    System.out.printf("Total: %.2f\n", total);
                    break;
                case 5:
                    System.out.print("O lanche/bebida escolhido foi o refrigerante\n");
                    total = (double) qtd*1.50;
                    System.out.printf("Total: %.2f\n", total); 
                    break;
                default:
                    System.out.print("Opcao invalida\n");
                    break;
            }
            
            System.out.print("Deseja continuar? s/s ou n/N: ");
            ans = sc.next().charAt(0);
            
        }while(ans == 's' || ans == 'S');
        
        sc.close();
        System.out.println("-----------------------------");
        System.out.println("-----Programa Finalizado-----");
        System.out.println("-----------------------------");
    }
    
}
