public class Pessoa{
	
	public static void main(String args[]){
		Pai p = new Pai();
		
		p.nome = "Jose Henrique"; //public
		p.idade = 65; //public
		//p.salario = 3000; //public
		
		p.cadPai("Jose Henrique", 65, 3000); //public
		//p.calcSalario(); //private
		p.impPai(); //public
	}

}