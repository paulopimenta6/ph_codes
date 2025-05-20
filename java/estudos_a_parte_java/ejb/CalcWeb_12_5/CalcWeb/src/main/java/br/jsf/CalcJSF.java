/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSF/JSFManagedBean.java to edit this template
 */
package br.jsf;

import bri.CalcInterface;
import javax.ejb.EJB;
import javax.inject.Named;
import javax.enterprise.context.RequestScoped;
import lombok.Getter;
import lombok.Setter;

/**
 *
 * @author Paulo_Pimenta
 */
@Named(value = "calcJSF")
@RequestScoped
public class CalcJSF {

    @EJB
    private CalcInterface calcEJB;

    /**
     * Creates a new instance of CalcJSF
     */
    public CalcJSF() {
    }
    
    public void somar(){
        resultadoSoma = calcEJB.somar(a, b);
    }
    public void subtrair(){
        resultadoSubtracao = calcEJB.subtrair(a, b);
    }
    public void mutiplicar(){
        resultadoMultiplicacao = calcEJB.multiplicar(a, b);
    }
    public void dividir(){
        resultadoDivisao = calcEJB.dividir(a, b);
    }
    
    public void calcula(){
        somar();
        subtrair();
        mutiplicar();
        dividir();
    }
    
    @Getter @Setter
    private double a;
    @Getter @Setter
    private double b;
    @Getter
    private double resultadoSoma;
    @Getter
    private double resultadoSubtracao;
    @Getter
    private double resultadoMultiplicacao;
    @Getter
    private double resultadoDivisao;     
    
}
