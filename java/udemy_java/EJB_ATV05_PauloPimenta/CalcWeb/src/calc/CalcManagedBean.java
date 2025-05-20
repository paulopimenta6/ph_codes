package calc;

import jakarta.ejb.EJB;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Named;

@Named
@RequestScoped
public class CalcManagedBean {

    private double a;
    private double b;
    private double resultadoSoma;
    private double resultadoSubtracao;
    private double resultadoMultiplicacao;
    private double resultadoDivisao;
    private String erro;

    @EJB
    private CalcRemote calcBean;

    public void calcular() {
        try {
            resultadoSoma = calcBean.somar(a, b);
            resultadoSubtracao = calcBean.subtrair(a, b);
            resultadoMultiplicacao = calcBean.multiplicar(a, b);
            resultadoDivisao = calcBean.dividir(a, b);
            erro = null;
        } catch (ArithmeticException e) {
            erro = e.getMessage();
        }
    }

    public double getA() { return a; }
    public void setA(double a) { this.a = a; }

    public double getB() { return b; }
    public void setB(double b) { this.b = b; }

    public double getResultadoSoma() { return resultadoSoma; }
    public double getResultadoSubtracao() { return resultadoSubtracao; }
    public double getResultadoMultiplicacao() { return resultadoMultiplicacao; }
    public double getResultadoDivisao() { return resultadoDivisao; }
    public String getErro() { return erro; }
}
