package exerciciojava26;

import entities.retangulo;
import java.util.Locale;
import java.util.Scanner;

public class ExercicioJava26 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        retangulo rt = new retangulo();
        
        System.out.print("Digite a largura: ");
        rt.largura = sc.nextDouble();
        
        System.out.print("Digite a altura: ");
        rt.altura = sc.nextDouble();
                
        System.out.println(rt);
        sc.close();
    }
    
}
