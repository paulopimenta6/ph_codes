public class Pai{

	private int rg;
	private String nome;
	
	private Filho fiote = new Filho();

// =================================================
	public Filho getFiote(){
		return fiote;
	}

	public void setFiote(Filho fiote){
		this.fiote = fiote;
	}

// =================================================


	public int getRg(){
		return rg;
	}

	public String getNome(){
		return nome;
	}

	public void setRg(int rg){
		this.rg = rg;
	}

	public void setNome(String nome){
		this.nome = nome;
	}

}