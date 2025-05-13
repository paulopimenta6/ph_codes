import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class ServidorMulti {
    public static void main(String[] a){

        int idCliente = 0;
        try{
            System.out.println("[Criando Servidor...]");
            ServerSocket servidor = new ServerSocket(1234);
            System.out.println("[Servidor operando na porta 1234]");
            while(true){
                System.out.println("[Esperando conexao...]");
                Socket cliente = servidor.accept();
                new Contador(++idCliente, cliente).start();
            }
        } catch (Exception e) {
            System.out.println("Erro!\n" + e.getMessage());
        }
    }
}

class Contador extends Thread{
    private Socket conexao;
    private int idCliente;
    public Contador(int idCliente, Socket conexao){
        this.idCliente = idCliente;
        this.conexao = conexao;
    }

    public void run(){
        System.out.printf("[%d: Conexao aberta de %s]\n", idCliente, conexao.getInetAddress().toString());
        try(ObjectInputStream entrada = new ObjectInputStream(conexao.getInputStream());
            ObjectOutputStream saida = new ObjectOutputStream((conexao.getOutputStream()));) {

            saida.flush();
            System.out.printf("[%d: Recebendo Limite...]\n", idCliente);
            Integer limite = (Integer) entrada.readObject();
            System.out.printf("[%d: Limite = %d]\n", idCliente, limite);
            for(int i = limite.intValue(); i >= 0; i--){
                saida.writeObject("IdCliente " + idCliente + ": " + i);
            }

            saida.writeObject("EOT");
            conexao.close();
            System.out.printf("[%d: Conexao encerrada]\n", idCliente);

        } catch (ClassNotFoundException | IOException e) {
          System.out.printf("[%d: Erro I/O]\n", idCliente);
        }
    }

}
