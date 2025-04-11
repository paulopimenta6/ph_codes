package local.redes;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Servidor {
    
    private static ServerSocket server;
    private static Socket socket;       
    private static DataInputStream entrada;
    private static DataOutputStream saida;
    
    public static void main(String[] args) {

        try {
            System.out.println("Aceitando conexao...");
            server = new ServerSocket(55001);
            socket = server.accept();

            entrada = new DataInputStream(socket.getInputStream());
            String cpfRecebido = entrada.readUTF();

            String resultado;
            if (validarCPF(cpfRecebido)) {
                resultado = "CPF válido!";
            } else {
                resultado = "CPF inválido!";
            }

            saida = new DataOutputStream(socket.getOutputStream());
            saida.writeUTF(resultado);

            socket.close();
            server.close();

        } catch (IOException e) {
            System.out.println("Erro no servidor: " + e.getMessage());
        }
    }      
    
    public static boolean validarCPF(String cpf) {
        cpf = cpf.replaceAll("[^\\d]", "");

        if (cpf.length() != 11 || cpf.matches("(\\d)\\1{10}")) {
            return false;
        }

        try {
            int soma = 0;
            for (int i = 0; i < 9; i++) {
                soma += (cpf.charAt(i) - '0') * (10 - i);
            }

            int primeiroDigito = 11 - (soma % 11);
            if (primeiroDigito >= 10) primeiroDigito = 0;

            if ((cpf.charAt(9) - '0') != primeiroDigito) {
                return false;
            }

            soma = 0;
            for (int i = 0; i < 10; i++) {
                soma += (cpf.charAt(i) - '0') * (11 - i);
            }

            int segundoDigito = 11 - (soma % 11);
            if (segundoDigito >= 10) segundoDigito = 0;

            return (cpf.charAt(10) - '0') == segundoDigito;

        } catch (Exception e) {
            return false;
        }
    }    
}
