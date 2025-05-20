package calc;

import jakarta.ejb.Remote;

@Remote
public interface CalcRemote {
    double somar(double a, double b);
    double subtrair(double a, double b);
    double multiplicar(double a, double b);
    double dividir(double a, double b) throws ArithmeticException;
}
