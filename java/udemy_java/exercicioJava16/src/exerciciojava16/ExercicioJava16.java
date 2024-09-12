package exerciciojava16;

import java.util.Scanner;
public class ExercicioJava16 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int input; 
        int senha = 2002;
       
        System.out.print("Digite a senha: ");
        input = sc.nextInt();
        
        while(input != senha){
            System.out.print("Digite novamente a senha: ");
            input = sc.nextInt();    
        }
        
        sc.close();
        System.out.print("Acesso permitido...\n");
    }
    
}
