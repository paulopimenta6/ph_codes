package ServidorBasico;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.net.Socket;

public class ClienteBasico {

    public static void main(String[] args) throws ClassNotFoundException {
        
        System.out.println("[Conectando servidor...]");
        try(Socket cliente = new Socket("localhost", 1234);){
            System.out.println("[Conexao aceita de " + cliente.getInetAddress().toString() +"]");
            System.out.println("[Recebendo mensagens...]");
            ObjectInputStream entrada = new ObjectInputStream(cliente.getInputStream());
            String msg;
            do { 
                msg = (String) entrada.readObject();
                System.out.println(msg);
            } while (!msg.equals("EOT"));
            System.out.println("[Conexao encerrada]");
            cliente.close();
        } catch (IOException ex) {
            System.out.println("Erro: " + ex.getMessage());
        }       

    }
    
}
