/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package teste;

/**
 *
 * @author Paulo Pimenta
 */
public class Veiculo {
    private String placa;
    private String marca;
    private String modelo;
    private String cor;
    private float velocMax;
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
public Veiculo(String placa, String marca, String modelo, String cor, float velocMax, int qtdRodas){    
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
public Veiculo(String placa, String marca, String modelo, String cor, float velocMax, int qtdRodas, int qtdPist, int potencia){
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
public float getvelocMax(){
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
public String setPlaca(String placa){
    return this.placa = placa;
}
public String setMarca(String marca){
    return this.marca = marca;
}
public String setModelo(String modelo){
    return this.modelo = modelo;
}       
public String setCor(String cor){
    return this.cor = cor;
}       
public float setvelocMax(float velocMax){
    return this.velocMax = velocMax;
}
public int setQtdRodas(int qtdRodas){
    return this.qtdRodas = qtdRodas;
}
//================================================   

        
}
