public class Filho {

    private int rgFilho;
    private String nomeFilho;

    public Filho(){
        this.rgFilho = 0;
        this.nomeFilho = " ";
    }

    public Filho (int rgFilho, String nomeFilho){
        this.rgFilho = rgFilho;
        this.nomeFilho = nomeFilho;
    }

    public int getRgFilho() {
        return this.rgFilho;
    }

    public String getNomeFilho() {
        return this.nomeFilho;
    }

    public void setRgFilho(int rgFilho) {
        this.rgFilho = rgFilho;
    }

    public void setNomeFilho(String nomeFilho) {
        this.nomeFilho = nomeFilho;
    }
}
