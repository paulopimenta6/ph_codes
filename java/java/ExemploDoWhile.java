/**
 *
 * @author Paulo Pimenta
 */
public class ExemploDoWhile {
    public static void main(String args[]){
        int min = Integer.parseInt(args[0]);
        int max = Integer.parseInt(args[1]);
        
        do{
            System.out.println(min + " < " + max);
            min++;
            max--;
        } while(min<max);
        System.out.println(min + " < " + max + " condição inválida!");
    }    
}
