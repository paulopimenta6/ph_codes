package exerciciojava41;

import java.text.ParseException;
import java.util.Scanner;

import entities.Rent;

/**
 *
 * @author paulo
 */
public class ExercicioJava41 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws ParseException {
        Scanner sc = new Scanner(System.in);
        
        Rent[] vector = new Rent[10];
        
        System.out.print("How many rooms will be rented? ");
        int n = sc.nextInt();
        
        for(int i = 1; i <= n; i++){
            System.out.println("");
            System.out.println("Rent #" + i + ":");
            
            System.out.print("Name: ");
            sc.nextLine();
            String name = sc.nextLine();
            
            System.out.print("Email: ");
            String email = sc.nextLine();
            
            System.out.print("Room: ");
            int room = sc.nextInt();
            
            vector[room-1] = new Rent(name, email);
        }
        
        System.out.println();
        System.out.println("Busy rooms: ");
        for(int i = 0; i < vector.length; i++){
            if(vector[i] != null){
                System.out.println(i + 1 +": " + vector[i]);
            }
        }
        
        sc.close();
    }
    
}
