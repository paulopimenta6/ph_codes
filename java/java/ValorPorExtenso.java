/**
 *
 * @author Paulo Pimenta
 */
public class ValorPorExtenso {
    public static void main(String args[]){
		int num = Integer.parseInt(args[0]);
		String dias_semana_0_9[] = {"zero", "um", "dois", "tres", "quatro", "cinco", "seis", "sete", "oito", "nove"};
		String dias_semana_0_19[] = {"dez", "onze", "doze", "treze", "quatorze", "quinze", "dezesseis", "dezessete", "dezoito", "dezenove"};
		String dias_semana_20_49[] = {"vinte", "trinta", "quarenta"};
		
		int resto;
		int quociente;
		
		quociente = num/10;
		resto = num%10;
		
		//System.out.printf("O quociente e...:%d%n ", quociente);
		//System.out.printf("O resto e...:%d%n ", resto);
		
		if(num >= 0 && num <= 49){			
			System.out.printf("O valor do argumento e...: %d%n", num);
			
			if(quociente == 0){
				System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_9[resto]);
			}else{
				if(quociente == 1){					
					if(resto == 0){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}
					if(resto == 1){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}
					if(resto == 2){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}					
					if(resto == 2){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}				
					if(resto == 3){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}				
					if(resto == 4){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}				
					if(resto == 5){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}
					if(resto == 6){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}
					if(resto == 7){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}
					if(resto == 8){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}
					if(resto == 9){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_0_19[resto]);
					}				
				}
				if(quociente == 2){
					if(resto == 0){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_20_49[quociente-dias_semana_20_49.length+1]);
					}
					if(resto > 0 && resto <= 9){
						System.out.printf("O valor do argumento e...: %s e %s%n", dias_semana_20_49[quociente-dias_semana_20_49.length+1], dias_semana_0_9[resto]);					 	
					}					
				}
				if(quociente == 3){
					if(resto == 0){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_20_49[quociente-dias_semana_20_49.length+1]);
					}
					if(resto > 0 && resto <= 9){
						System.out.printf("O valor do argumento e...: %s e %s%n", dias_semana_20_49[quociente-dias_semana_20_49.length+1], dias_semana_0_9[resto]);					 	
					}					
				}
				if(quociente == 4){
					if(resto == 0){
						System.out.printf("O valor do argumento e...: %s%n", dias_semana_20_49[quociente-dias_semana_20_49.length+1]);
					}
					if(resto > 0 && resto <= 9){
						System.out.printf("O valor do argumento e...: %s e %s%n", dias_semana_20_49[quociente-dias_semana_20_49.length+1], dias_semana_0_9[resto]);					 	
					}					
				}
				
			}					
		}else{
			System.out.println("Valor diferente do intervalo [0...49]");
		}
		
	}
}