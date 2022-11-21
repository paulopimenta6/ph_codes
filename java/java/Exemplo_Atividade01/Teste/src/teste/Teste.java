package teste;

public class Teste {

    public static void main(String arg[]){

        // Pai 1 est� usando o construtor default da classe
        Pai pai1 = new Pai();
        pai1.setRgPai(0);
        pai1.setNomePai("Pai 1");
        pai1.getFilho().setRgFilho(1);
        pai1.getFilho().setNomeFilho("Filho 1");

        // Pai 2 est� usando o construtor com 2 par�metros da classe
        Pai pai2 = new Pai(11, "Pai 2");

        // Pai 3 est� usando o construtor que recebe os
        // par�metros do Pai e do Filho
        Pai pai3 = new Pai(22, "Pai 3", 2, "Filho 3");

        // Usando o toString para imprimir o objeto
        // Ver a sobrescrita do m�todo
        pai1.toString();

        // Usando getters para imprimir os objetos
        System.out.println("Pai 2");
        System.out.println("Rg: " + pai2.getRgPai());
        System.out.println("Nome: " + pai2.getNomePai());
        System.out.println("RgFilho: " + pai2.getFilho().getRgFilho());
        System.out.println("NomeFilho: " + pai2.getFilho().getNomeFilho());

        System.out.println("************************************************************");
        System.out.println("Pai 3");
        System.out.println("Rg: " + pai3.getRgPai());
        System.out.println("Nome: " + pai3.getNomePai());
        System.out.println("RgFilho: " + pai3.getFilho().getRgFilho());
        System.out.println("NomeFilho: " + pai3.getFilho().getNomeFilho());

    }

}
