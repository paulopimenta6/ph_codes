/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package teste;

/**
*
* @author Paulo Pimenta
*/
public abstract class Veiculo {
    private String placa;
    private String marca;
    private String modelo;
    private String cor;
    private int velocMax;
    private int qtdRodas;
    private Motor motor;

    //================================================
    //Metodo que inicia tudo zerado.    
    public Veiculo(){
        this.placa = " ";
        this.marca = " ";
        this.modelo = " ";
        this.cor = " ";
        this.velocMax = 0;
        this.qtdRodas = 0;
        motor = new Motor(); 
    }    
    //================================================

    //================================================
    //Metodo que inicia com os atributos da classe Veiculo, sem parametros para a classe Motor
    //Os objetos da classe Motor retornarao vazio
    public Veiculo(String placa, String marca, String modelo, String cor, int velocMax, int qtdRodas){    
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.cor = cor;
        this.velocMax = velocMax;
        this.qtdRodas = qtdRodas;
        motor = new Motor();
    }
    //================================================

    //================================================
    //Metodo para atribuir todos os atributos e torna-los globais por meio do this    
    public Veiculo(String placa, String marca, String modelo, String cor, int velocMax, int qtdRodas, int qtdPist, int potencia){
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.cor = cor;
        this.velocMax = velocMax;
        this.qtdRodas = qtdRodas;
        motor = new Motor(qtdPist, potencia);        
    }
    //================================================

    //================================================
    //getters
    public String getPlaca(){
        return this.placa;
    }
    public String getMarca(){
        return this.marca;
    }
    public String getModelo(){
        return this.modelo;
    }       
    public String getCor(){
        return this.cor;
    }       
    public int getvelocMax(){
        return this.velocMax;
    }
    public int getQtdRodas(){
        return this.qtdRodas;
    }
    //getter tambem se aplica aos objetos gerados pela instancia 
    //da classe motor
    public Motor getMotor(){
        return this.motor;
    }
    //================================================

    //================================================
    //setters
    public final void setPlaca(String placa){
        this.placa = placa;
    }
    public final void setMarca(String marca){
        this.marca = marca;
    }
    public final void setModelo(String modelo){
        this.modelo = modelo;
    }       
    public final void setCor(String cor){
        this.cor = cor;
    }       
    public final void setvelocMax(int velocMax){
        this.velocMax = velocMax;
    }
    public final void setQtdRodas(int qtdRodas){
        this.qtdRodas = qtdRodas;
    }
    //================================================   

    public abstract float calcVel();
        //int fatorMuti = 0;
        //float resuVelocFatorMulti;
        //resuVelocFatorMulti = fatorMuti*velocMax;
        //return resuVelocFatorMulti;


}
