/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package teste;

/**
 *
 * @author Paulo Pimenta
 */
public class Teste {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
      // TODO code application logic here
      //Primeira instanciacao de um veiculo
      //String placa, String marca, String modelo, String cor, float velocMax, int qtdRodas, int qtdPist, int potencia
      //================================================
        Veiculo veiculo_1 = new Veiculo("ABC123", "Ford", "Ford Fiesta Rocam 1.6 2012/13",
              "Preto", 200, 4, 4, 107);
        System.out.println("================================================");
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
        Veiculo veiculo_2 = new Veiculo("ABC909", "Toyota", "Corolla GLi",
              "Preto", 205, 4);
        veiculo_2.getMotor().setPotencia(177);
        veiculo_2.getMotor().setqtdPist(4);
        System.out.println("================================================");
        System.out.println("Placa: " + veiculo_2.getPlaca());
        System.out.println("Marca: " + veiculo_2.getMarca());
        System.out.println("Modelo: " + veiculo_2.getModelo());
        System.out.println("Cor: " + veiculo_2.getCor());
        System.out.println("Velocidade Maxima: " + veiculo_2.getvelocMax());
        System.out.println("Quantidade de rodas: " + veiculo_2.getQtdRodas());
        System.out.println("Quantidade de pistoes: " + veiculo_2.getMotor().getqtdPist());
        System.out.println("Potencia: " + veiculo_2.getMotor().getPotencia() + " cv");
      //================================================   
      
      //================================================
      //Instanciando e exibindo atraves de getters e setters
        Veiculo veiculo_3 = new Veiculo();
        veiculo_3.setPlaca("ABC456");
        veiculo_3.setMarca("Hyundai");
        veiculo_3.setModelo("Hyundai HB20 TGDI");
        veiculo_3.setCor("Branco");
        veiculo_3.setvelocMax(190);
        veiculo_3.setQtdRodas(4);
        veiculo_3.getMotor().setPotencia(120);
        veiculo_3.getMotor().setqtdPist(3);
        System.out.println("================================================");
        System.out.println("Placa: " + veiculo_3.getPlaca());
        System.out.println("Marca: " + veiculo_3.getMarca());
        System.out.println("Modelo: " + veiculo_3.getModelo());
        System.out.println("Cor: " + veiculo_3.getCor());
        System.out.println("Velocidade Maxima: " + veiculo_3.getvelocMax());
        System.out.println("Quantidade de rodas: " + veiculo_3.getQtdRodas());
        System.out.println("Quantidade de pistoes: " + veiculo_3.getMotor().getqtdPist());
        System.out.println("Potencia: " + veiculo_3.getMotor().getPotencia() + " cv");
      //================================================
        
      //================================================
      //Instanciando e exibindo atraves de getters e setters
        Veiculo veiculo_4 = new Veiculo();
        veiculo_4.setPlaca("ABC459");
        veiculo_4.setMarca("Volvo");
        veiculo_4.setModelo("Volvo XC60 (eletrico)");
        veiculo_4.setCor("Branco");
        veiculo_4.setvelocMax(180);
        veiculo_4.setQtdRodas(4);
        veiculo_4.getMotor().setPotencia(145);
        veiculo_4.getMotor().setqtdPist(0);
        System.out.println("================================================");
        System.out.println("Placa: " + veiculo_4.getPlaca());
        System.out.println("Marca: " + veiculo_4.getMarca());
        System.out.println("Modelo: " + veiculo_4.getModelo());
        System.out.println("Cor: " + veiculo_4.getCor());
        System.out.println("Velocidade Maxima: " + veiculo_4.getvelocMax());
        System.out.println("Quantidade de rodas: " + veiculo_4.getQtdRodas());
        System.out.println("Quantidade de pistoes: " + veiculo_4.getMotor().getqtdPist());
        System.out.println("Potencia: " + veiculo_4.getMotor().getPotencia() + " cv");
      //================================================
        
      //================================================
        Veiculo veiculo_5 = new Veiculo("ABC973", "Mitsubishi", "Mitsubishi Outlander",
              "Prata", 220, 4);
        veiculo_5.getMotor().setPotencia(240);
        veiculo_5.getMotor().setqtdPist(6);
        System.out.println("================================================");
        System.out.println("Placa: " + veiculo_5.getPlaca());
        System.out.println("Marca: " + veiculo_5.getMarca());
        System.out.println("Modelo: " + veiculo_5.getModelo());
        System.out.println("Cor: " + veiculo_5.getCor());
        System.out.println("Velocidade Maxima: " + veiculo_5.getvelocMax());
        System.out.println("Quantidade de rodas: " + veiculo_5.getQtdRodas());
        System.out.println("Quantidade de pistoes: " + veiculo_5.getMotor().getqtdPist());
        System.out.println("Potencia: " + veiculo_5.getMotor().getPotencia() + " cv");
      //================================================
      
    }
    
}
