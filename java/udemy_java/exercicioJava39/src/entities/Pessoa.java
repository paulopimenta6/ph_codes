package entities;

/**
 *
 * @author Paulo_Pimenta
 */
public class Pessoa {
    private String nome;
    private double nota1;
    private double nota2;

    public Pessoa() {
        this.nome = "";
        this.nota1 = 0.0;
        this.nota2 = 0.0;
    }
    
    public Pessoa(String nome, double nota1, double nota2) {
        this.nome = nome;
        this.nota1 = nota1;
        this.nota2 = nota2;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setNota1(double nota1) {
        this.nota1 = nota1;
    }

    public void setNota2(double nota2) {
        this.nota2 = nota2;
    }

    public String getNome() {
        return nome;
    }

    public double getNota1() {
        return nota1;
    }

    public double getNota2() {
        return nota2;
    }   
    
    public void aprovadoOunao(){
        double media = (getNota1() + getNota2())/2.0;
        if (media >= 6.0){
             System.out.print("Aluno aprovado: " + getNome() + " Media: " + " - " + media + "\n");
        } else{
            System.out.print("Aluno reprovado: " + getNome() + " Media: " + " - " + media + "\n");
        }        
    }
    
}
