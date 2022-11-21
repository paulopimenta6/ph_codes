public class TstEst{

	public static void main(String arg[]){

		Pai p1 = new Pai();

		p1.getFiote().setIdade(18);
		p1.getFiote().setApelido("Apelido do Fiote");

		p1.setRg(16);
		p1.setNome("Papai");

		System.out.println("\n ==== Dados do Fiote do Pai ====");
		System.out.println("IDADE - FIOTE: "+p1.getFiote().getIdade());
		System.out.println("APELIDO - FIOTE: "+p1.getFiote().getApelido());

		System.out.println("\n ==== Dados do Pai do Fiote  ====");
		System.out.println("RG - PAI: "+p1.getRg());
		System.out.println("NOME - PAI: "+p1.getNome());


	}
}