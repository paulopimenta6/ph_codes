package entities;

public class retangulo {
    public double largura;
    public double altura;

public double perimetro(){
    return 2*largura + 2*altura;
    }

public double area(){
    return largura*altura;
    }

public double diagonal(){
    return Math.sqrt(Math.pow(altura, 2) + Math.pow(largura, 2));
    }

    @Override
    public String toString(){
        return "Area= " + String.format("%.2f%n",area())
                + "Perimeter = " + String.format("%.2f%n",perimetro())
                + "Diagonal = " + String.format("%.2f%n",diagonal());
}
}
