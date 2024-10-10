package entities;

/**
 *
 * @author Paulo_Pimenta
 */
public class Pessoa {
    private double altura;
    private String genero;

    public Pessoa(double altura, String genero) {
        this.altura = altura;
        this.genero = genero;
    }

    public double getAltura() {
        return altura;
    }

    public String getGenero() {
        return genero;
    }

    public void setAltura(double altura) {
        this.altura = altura;
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }
    
    
    
}
