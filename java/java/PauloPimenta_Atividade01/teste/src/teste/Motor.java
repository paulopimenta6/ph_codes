/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package teste;

/**
 *
 * @author Paulo Pimenta
 */
public class Motor {
    
    private int qtdPist;
    private int potencia;
    
    //================================================
    //Inicia tudo com zero ou vazio
    //Metodo que "zera" tudo
    public Motor(){
        this.qtdPist = 0;
        this.potencia = 0;
    }
    //Sobrecarrega o metodo com o valor de qtdPist e a potencia
    //Inicia com os valores para os dois membros construtores
    public Motor(int qtdPist, int potencia){
        this.qtdPist = qtdPist;
        this.potencia = potencia;        
    }
    //================================================
    
    //================================================
    //getters
    public int getqtdPist(){
        return this.qtdPist;        
    }
    public int getPotencia(){
        return this.potencia;
    }
    //setters
    //Aqui os atributos de quantidade de pistao e potencia serao colocados
    //Nao precisa retornar nada, somente configurar os atributos
    public void setqtdPist(int qtdPist){
        this.qtdPist = qtdPist;
    }
    public void setPotencia(int potencia){
        this.potencia = potencia;
    }    
}
