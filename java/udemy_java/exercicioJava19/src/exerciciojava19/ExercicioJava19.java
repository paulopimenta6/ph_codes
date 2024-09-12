package exerciciojava19;

import java.util.Scanner;

public class ExercicioJava19 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int num;
        
        System.out.print("Digite um valor entre 1 e 1000: 1<=X<=1000: ");
        num = sc.nextInt();
        
        while(num < 1 || num > 1000){
            System.out.print("Digite um valor entre 1 e 1000: 1<=X<=1000: ");
            num = sc.nextInt();
        }
        
        sc.close();
        for(int i = 0; i <= num; i++){
            if(i%2 != 0){
                System.out.println(i);
            }
        }
    }
    
}
