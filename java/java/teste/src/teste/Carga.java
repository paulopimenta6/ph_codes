/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package teste;

/**
 *
 * @author Paulo Pimenta
 */
public final class Carga extends Veiculo implements Calcular{
    
    private int cargaMax;
    private int tara;
    
    //================================================
    //Construtores
    public Carga(){
        this.cargaMax = 0;
        this.tara = 0;
    }

    public Carga(int cargaMax, int tara){
        this.cargaMax = cargaMax;
        this.tara = tara;
    }
    
    public Carga(int cargaMax, int tara, String _placa, String _marca, String _modelo, String _cor, int _velocMax, int _qtdRodas){
        super(_placa, _marca, _modelo, _cor, _velocMax, _qtdRodas);
        this.cargaMax = cargaMax;
        this.tara = tara;
    }
    
    public Carga(int cargaMax, int tara, String _placa, String _marca, String _modelo, String _cor, int _velocMax, int _qtdRodas, int _qtdPist, int _potencia){
        super(_placa, _marca, _modelo, _cor, _velocMax, _qtdRodas, _qtdPist, _potencia);
        this.cargaMax = cargaMax;
        this.tara = tara;
    }
    //================================================
    
    //================================================
    //getters
    public int getcargaMax(){
        return this.cargaMax;
    }
    public int gettara(){
        return this.tara;
    }
    //================================================
    
    //================================================
    //setters
    public final void setcargaMax(int cargaMax){
        this.cargaMax = cargaMax;
    }
    public final void settara(int tara){
        this.tara = tara;
    }    
    //================================================
    
    //================================================
    @Override
    public int Calcular(){
        int somaNum=0;
        somaNum += getMotor().getqtdPist();
        somaNum += getMotor().getPotencia();
        somaNum += getQtdRodas();
        somaNum += getvelocMax();
        somaNum += gettara();
        somaNum += getcargaMax();
        
        return somaNum;
    }
    //================================================    
    
    @Override
    public final float calcVel() {
        //throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
        int fatorMuti = 100000;
        float resuVelocFatorMulti;
        resuVelocFatorMulti = getvelocMax()*fatorMuti;
        return resuVelocFatorMulti;
    }
    
}