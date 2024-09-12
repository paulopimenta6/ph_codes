package exerciciojava30;

import entities.Grade;
import java.util.Locale;
import java.util.Scanner;

public class ExercicioJava30 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        Grade st = new Grade();
        
        System.out.print("Name: ");
        st.name = sc.nextLine();
        
        System.out.print("Grade 1: ");
        st.grade1 = sc.nextDouble();
        
        System.out.print("Grade 2: ");
        st.grade2 = sc.nextDouble();
        
        System.out.print("Grade 3: ");
        st.grade3 = sc.nextDouble();
        
        System.out.println(st);
        sc.close();
    }
    
}
