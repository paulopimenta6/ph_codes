package incremento;

/**
 *
 * @author Paulo Pimenta
 */
public class Incremento {

    /**
     * @param args the command line arguments
     */
public static void main(String[] args) {
 // TODO code application logic here

    int a1 = 1;
    int b1 = ++a1;
    
    int a2 = 1;
    int b2 = a2++;
    //while()
    System.out.println("Incremento com ++a");
    System.out.println(b1);
    System.out.println("=======================================");
    System.out.println("Incremento com a++");
    System.out.println(b2); 
    System.out.println("=======================================");
    System.out.println("Comparacao com \"==\" e \"equals\"");
    String s = "casa";
    String t = "casa";
    System.out.print(t == s); //errado
    System.out.println(" ");
    System.out.print(t.equals(s));
    System.out.println(" ");
    }    
}
