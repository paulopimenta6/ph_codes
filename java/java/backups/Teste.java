package testeveiculosmotor;

/**
 *
 * @author Paulo Pimenta
 */
public class Teste{

    /**
     *
     * @param args
     */
    public static void main(String args[]) {
        
      //Primeira instanciacao de um veiculo
      //String placa, String marca, String modelo, String cor, float velocMax, int qtdRodas, int qtdPist, int potencia
      //================================================
        Veiculo veiculo_1 = new Veiculo("ABC123", "Ford,", "Ford Fiesta Rocam 1.6 2012/13",
              "Preto", 200, 4, 4, 107);
        System.out.println("Placa: " + veiculo_1.getPlaca());
        System.out.println("Marca: " + veiculo_1.getMarca());
        System.out.println("Modelo: " + veiculo_1.getModelo());
        System.out.println("Cor: " + veiculo_1.getCor());
        System.out.println("Velocidade Maxima: " + veiculo_1.getvelocMax());
        System.out.println("Quantidade de rodas: " + veiculo_1.getQtdRodas());
        System.out.println("Quantidade de pistoes: " + veiculo_1.getMotor().getqtdPist());
        System.out.println("Potencia: " + veiculo_1.getMotor().getPotencia() + " cv");
      //================================================
      
      //================================================
      //Instanciando e exibindo atraves de getters e setters
        Veiculo veiculo_2 = new Veiculo();
        veiculo_2.setPlaca("ABC456");
        veiculo_2.setMarca("Hyundai");
        veiculo_2.setModelo("Hyundai HB20 TGDI");
        veiculo_2.setCor("Branco");
        veiculo_2.setvelocMax(190);
        veiculo_2.setQtdRodas(4);
        veiculo_2.getMotor().setPotencia(120);
        veiculo_2.getMotor().setqtdPist(3);
      
        System.out.println("Placa: " + veiculo_2.getPlaca());
        System.out.println("Marca: " + veiculo_2.getMarca());
        System.out.println("Modelo: " + veiculo_2.getModelo());
        System.out.println("Cor: " + veiculo_2.getCor());
        System.out.println("Velocidade Maxima: " + veiculo_2.getvelocMax());
        System.out.println("Quantidade de rodas: " + veiculo_2.getQtdRodas());
        System.out.println("Quantidade de pistoes: " + veiculo_2.getMotor().getqtdPist());
        System.out.println("Potencia: " + veiculo_2.getMotor().getPotencia() + " cv");
      //================================================
      
    }

   
    
}
