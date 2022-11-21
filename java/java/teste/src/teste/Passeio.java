/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package teste;

/**
 *
 * @author Paulo Pimenta
 */
public final class Passeio extends Veiculo implements Calcular{
    
    private int qtdPassageiros;
    
    //================================================
    //Construtores
    public Passeio(){
        this.qtdPassageiros = 0;
    }

    public Passeio(int qtdPassageiros){
        this.qtdPassageiros = qtdPassageiros;
    }
    
    public Passeio(int qtdPassageiros, String _placa, String _marca, String _modelo, String _cor, int _velocMax, int _qtdRodas){
        super(_placa, _marca, _modelo, _cor, _velocMax, _qtdRodas);
        this.qtdPassageiros = qtdPassageiros;            
    }
    
    public Passeio(int qtdPassageiros, String _placa, String _marca, String _modelo, String _cor, int _velocMax, int _qtdRodas, int _qtdPist, int _potencia){
        super(_placa, _marca, _modelo, _cor, _velocMax, _qtdRodas, _qtdPist, _potencia);
        this.qtdPassageiros = qtdPassageiros;
    }
    //================================================
    
    //================================================
    //getters
    public int getPassageiros(){
            return this.qtdPassageiros;
    }
    //================================================
    
    //================================================
    //setters
    public final void setPassageiros(int qtdPassageiros){
            this.qtdPassageiros = qtdPassageiros;
    }    
    //================================================
    
    //================================================
    @Override
    public int Calcular(){
        int somaLetras=0;
        somaLetras += getPlaca().length();
        somaLetras += getMarca().length();
        somaLetras += getModelo().length();
        somaLetras += getCor().length();
        
        return somaLetras;
    }
    //================================================
    
    @Override
    public final float calcVel() {
        //throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
        int fatorMuti = 1000;
        float resuVelocFatorMulti;
        resuVelocFatorMulti = getvelocMax()*fatorMuti;
        return resuVelocFatorMulti;
    }
    
}
