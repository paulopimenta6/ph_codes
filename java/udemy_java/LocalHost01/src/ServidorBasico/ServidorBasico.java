package ServidorBasico;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class ServidorBasico {

    public static void main(String[] args) {
        System.out.println("[Criando servidor...]");
        try(ServerSocket servidor = new ServerSocket(1234);){
            System.out.println("[Servidor operando na porta 1234...]");
            while (true) {
                System.out.println("[Esperando conexão...]");
                Socket cliente = servidor.accept();
                System.out.println("[Conexão aberta de: " + cliente.getInetAddress().toString() + "]");
                System.out.println("[Enviando dados...]");

                ObjectOutputStream saida = new ObjectOutputStream(cliente.getOutputStream());
                saida.flush();
                saida.writeObject("Servidor Basico Conectado!");
                saida.writeObject("Dados conexão: " + cliente.toString());
                saida.writeObject("Tchau!");
                System.out.println("[Dados enviados]");
                saida.writeObject("EOT");
                cliente.close();
                System.out.println("[Conexão encerrada]"); 
            }

        } catch(IOException e){
            System.out.println("Erro: " + e.getMessage());
        }
    }
    
}
