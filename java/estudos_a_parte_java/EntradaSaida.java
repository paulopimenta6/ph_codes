import java.util.Scanner;
public class EntradaSaida{
    public static void main(String args[]){
        System.out.println("Ola");
        System.out.print("Digite um valor inteiro: ");
        Scanner s = new Scanner(System.in);
        int valor = s.nextInt();
        System.out.println("Valor = " + valor);
        s.close();
    }
} 
