/**
 *
 * @author Paulo Pimenta
 */
public class ExemploIf {
    public static void main(String args[]){
		if(args.length>0){
			int max = Integer.parseInt(args[0]);
			for(int j = 0; j < max; j++){
				System.out.print(j + " ");
			}
			System.out.println("...Fim da contagem...");
		}
		System.out.println("Fim do programa...");        
    }    
}
