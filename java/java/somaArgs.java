public class somaArgs {
    public static void main(String args[]){
		
		int total_int = 0;
		double total_real = 0;
		
		for(int i = 0; i<args.length; i++){
			//int a = Integer.parseInt(args[i]);
			//System.out.println(a);
			try{
				int a = Integer.parseInt(args[i]);
				total_int = total_int + a;
			} catch(NumberFormatException e1){
				try{
					double b = Double.parseDouble(args[i]);
					total_real = total_real + b;
				} catch(NumberFormatException e2){
					continue;
				}
			}	
		}

     	System.out.printf("Valor int...: %d\n", total_int);
        System.out.printf("Valor real...: %.3f", total_real);		
    }    
}