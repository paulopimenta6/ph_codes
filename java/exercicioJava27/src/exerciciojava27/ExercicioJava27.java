package exerciciojava27;

import entities.cadastro;
import java.util.Locale;
import java.util.Scanner;

public class ExercicioJava27 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        cadastro usr = new cadastro();
        
        System.out.print("Name: ");
        usr.name = sc.nextLine();
        System.out.print("Gross Salary: ");
        usr.GrossSalary = sc.nextDouble();
        System.out.print("Tax: ");
        usr.tax = sc.nextDouble();
        
        System.out.println();
        System.out.println(usr);
        System.out.println();
        
        System.out.print("Which percentage to increase salary? ");
        double percentage = sc.nextDouble();
        usr.IncreaseSalary(percentage);
        
        System.out.println();
        System.out.println("Updated data: " + usr);
        
        sc.close();
    }
    
}
