/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package bri;

import javax.ejb.Remote;

/**
 *
 * @author Paulo_Pimenta
 */
@Remote
public interface CalcInterface {
    double somar(double a, double b);
    double subtrair(double a, double b);
    double multiplicar(double a, double b);
    double dividir(double a, double b) throws ArithmeticException;
}
