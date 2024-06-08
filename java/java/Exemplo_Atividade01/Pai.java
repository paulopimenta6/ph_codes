public class Pai {

    private int rgPai;
    private String nomePai;
    private Filho filho;

    public Pai(){
        this.rgPai = 0;
        this.nomePai = " ";
        filho = new Filho();
    }

    public Pai(int rgPai, String nomePai){
        this.rgPai = rgPai;
        this.nomePai = nomePai;
        filho = new Filho();
    }

    public Pai(int rgPai, String nomePai, int rgFilho, String nomeFilho){
        this.rgPai = rgPai;
        this.nomePai = nomePai;
        this.filho = new Filho(rgFilho, nomeFilho);
    }

    public int getRgPai() {
        return this.rgPai;
    }

    public String getNomePai() {
        return this.nomePai;
    }

    public Filho getFilho() {
        return this.filho;
    }

    public void setRgPai(int rgPai) {
        this.rgPai = rgPai;
    }

    public void setNomePai(String nomePai) {
        this.nomePai = nomePai;
    }

    // Sobrecarga do método toString para imprimir o objeto
    @Override
    public String toString(){

        System.out.println("Rg: " + this.rgPai);
        System.out.println("Nome: " + this.nomePai);
        System.out.println("RgFilho: " + this.filho.getRgFilho());
        System.out.println("NomeFilho: " + this.filho.getNomeFilho());
        System.out.println("************************************************************");
        return null;
    }

}
