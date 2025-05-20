package calc;

import jakarta.ejb.Stateless;

@Stateless
public class CalcBean implements CalcRemote {

    @Override
    public double somar(double a, double b) {
        return a + b;
    }

    @Override
    public double subtrair(double a, double b) {
        return a - b;
    }

    @Override
    public double multiplicar(double a, double b) {
        return a * b;
    }

    @Override
    public double dividir(double a, double b) {
        if (b == 0) throw new ArithmeticException("Divisão por zero!");
        return a / b;
    }
}
