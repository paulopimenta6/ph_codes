package local.redes;

import java.io.EOFException;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;

/**
 *
 * @author Paulo Pimenta
 */
public class Servidor {

    private static final int PORT = 50000;

    public static void main(String[] args) {
        ServerSocket serverSocket = null;
        try {
            serverSocket = new ServerSocket(PORT);
            System.out.println("Servidor TCP Simples iniciado na porta " + PORT + ". Aguardando conexões...");

            while (true) {
                try {
                    Socket clientSocket = serverSocket.accept();
                    System.out.println("Cliente conectado: " + clientSocket.getInetAddress().getHostAddress());
                    // Inicia uma nova thread para cada cliente
                    new ClientHandler(clientSocket).start();
                } catch (IOException e) {
                    System.err.println("Erro ao aceitar conexão do cliente: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("Erro fatal ao iniciar o servidor na porta " + PORT + ": " + e.getMessage());
        } finally {
            // Fecha o ServerSocket principal (raramente alcançado no loop infinito)
            if (serverSocket != null && !serverSocket.isClosed()) {
                try {
                    serverSocket.close();
                    System.out.println("Servidor TCP Simples parado.");
                } catch (IOException e) {
                    System.err.println("Erro ao fechar o ServerSocket: " + e.getMessage());
                }
            }
        }
    }

    // Classe interna para lidar com cada cliente
    private static class ClientHandler extends Thread {
        private final Socket clientSocket;
        private ObjectInputStream entradaObjeto = null;
        private PrintWriter saidaTexto = null;
        private final String clientAddress;

        public ClientHandler(Socket socket) {
            this.clientSocket = socket;
            this.clientAddress = socket.getInetAddress().getHostAddress();
        }

        @Override
        public void run() {
            try {
                // Configura streams (uma vez por conexão)
                entradaObjeto = new ObjectInputStream(clientSocket.getInputStream());
                saidaTexto = new PrintWriter(clientSocket.getOutputStream(), true); // autoFlush=true

                System.out.println("Handler iniciado para cliente " + clientAddress + ". Aguardando objetos...");

                // Loop para receber múltiplos objetos
                while (true) {
                    try {
                        // Lê objeto (bloqueante)
                        Pessoa p = (Pessoa) entradaObjeto.readObject();
                        System.out.println("Objeto recebido de [" + clientAddress + "]: Nome=" + p.getNome() + ", Idade=" + p.getIdade());

                        // Envia resposta
                        String resposta = "Objeto (Nome: " + p.getNome() + ") recebido.";
                        saidaTexto.println(resposta);
                        System.out.println("Resposta enviada para [" + clientAddress + "]");

                    } catch (EOFException | SocketException se) {
                        // Cliente desconectou
                        System.out.println("Cliente [" + clientAddress + "] desconectou.");
                        break; // Sai do loop
                    } catch (ClassNotFoundException cnfe) {
                        System.err.println("Erro: Classe Pessoa não encontrada para cliente [" + clientAddress + "]: " + cnfe.getMessage());
                        // Poderia continuar ou quebrar
                    } catch (IOException ioe) {
                        System.err.println("Erro de I/O com cliente [" + clientAddress + "]: " + ioe.getMessage());
                        break; // Sai do loop em caso de erro
                    }
                } // Fim do loop while

            } catch (IOException e) {
                 System.err.println("Erro ao configurar streams para cliente [" + clientAddress + "]: " + e.getMessage());
            } finally {
                // Fecha recursos da conexão do cliente
                closeResources();
                System.out.println("Conexão com cliente [" + clientAddress + "] fechada.");
            }
        }

        // Método auxiliar para fechar recursos
        private void closeResources() {
            try {
                if (entradaObjeto != null) entradaObjeto.close();
            } catch (IOException ex) { /* Ignora erro no fecho */ }
            if (saidaTexto != null) {
                 saidaTexto.close();
            }
            try {
                if (clientSocket != null && !clientSocket.isClosed()) clientSocket.close();
            } catch (IOException ex) { /* Ignora erro no fecho */ }
        }
    }
}

