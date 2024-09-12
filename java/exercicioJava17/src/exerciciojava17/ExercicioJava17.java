package exerciciojava17;

import java.util.Scanner;

public class ExercicioJava17 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int x, y;
        
        System.out.print("Digite o valor da coordenada x: ");
        x = sc.nextInt();
        
        System.out.print("Digite o valor da coordenada y: ");
        y = sc.nextInt();
        
        while(x != 0 && y != 0){
            if(x > 0 && y > 0){
                System.out.print("Primeiro quadrante\n");                
            }
            else if(x < 0 && y > 0){
                System.out.print("Segundo quadrante\n");                
            }
            else if(x < 0 && y < 0){
                System.out.print("Terceiro quadrante\n");                
            } else{
                System.out.print("Quarto quadrante\n");                
            }
            
            System.out.print("Digite o valor da coordenada x: ");
            x = sc.nextInt();
        
            System.out.print("Digite o valor da coordenada y: ");
            y = sc.nextInt();            
        }
        
        sc.close();
    }
    
}
