/**
 *
 * @author Paulo Pimenta
 */
 
 public class maiorDeTres{
	 public static void main(String args[]){
		 int R = Integer.parseInt(args[0]);
		 int S = Integer.parseInt(args[1]);
		 int T = Integer.parseInt(args[2]);
		 
		 //Verificando se o primeiro e maior que todos os outros dois...
		 
		 if(R>S && R>T){
			 System.out.println("O maior é R = " + R);
		 }else{
			 if(S>R && S>T){
				 System.out.println("O maior é S = " + S);
			 }else{
				 if(T>R && T>S){
					 System.out.println("O maior é T = " + T);
				 }else{
					 if(T==R && T==S){
						 System.out.println("Valores de R, S e T sao iguais, " + R + " == " + S + " == " + T);
					 }
				 }
			 }
		 }
		 
	 }
 }