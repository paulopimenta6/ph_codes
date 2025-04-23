
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;



public class ReceiveFile {
    public static void main(String args[]){
        System.out.println("[Criando servidor...]");
        try(ServerSocket servidorC = new ServerSocket(1234);
            ServerSocket servidorD = new ServerSocket(1235);) {
                System.out.println("[Servidor operando nas portas: " 
                + servidorC.getLocalPort() + " e " + servidorD.getLocalPort() + "]");

            while(true) {
                System.out.println("[Esperando conexão...]");
                try(Socket clienteC = servidorC.accept();
                    Socket clienteD = servidorD.accept();) {
                        System.out.printf("[Conexao aberta de %s]\n", 
                        clienteC.getInetAddress().toString());
                    //abre canal de controle (modo texto)
                    BufferedReader canalC = new BufferedReader(new InputStreamReader(clienteC.getInputStream()));
                    //recebe dados do arquivo transferido
                    String nomeArq = canalC.readLine();
                    
                    if(nomeArq.startsWith("@shutdown")){
                        System.out.println("[@shutdown]");
                        break;
                    }
                    System.out.printf("[Recebendo arquivo '%s']\n", nomeArq);
                    long recv = 0;
                    long total = Integer.parseInt(canalC.readLine());
                    canalC.close();
                    //abre canal de dados (modo binario)
                    BufferedInputStream canalD = new BufferedInputStream(clienteD.getInputStream());
                    //abre arquivo para dados transferidos
                    BufferedOutputStream arquivo = new BufferedOutputStream(new FileOutputStream(nomeArq));
                    
                    while(recv + 256 < total){
                        byte dados[] = new byte[256]; //array para blocos
                        canalD.read(dados, 0, 256); //lê blocos
                        arquivo.write(dados, 0, 256); //escreve blocos
                        recv += 256; //totaliza blocos
                    }
                    if(recv < total){
                        int fim = (int)(total - recv);
                        byte dados[] = new byte[fim]; //array para bloco final
                        canalD.read(dados, 0, fim); //lê bloco final
                        arquivo.write(dados, 0, fim); //bloco final
                    }
                    arquivo.close(); //fecha arquivo
                    canalD.close(); //fecha canal binario
                    System.out.println("[" + total + " bytes recebidos]");
                } catch (IOException e) {
                    System.out.println("[Problemas no recebimento do arquivo]");
                    e.printStackTrace();
                }
                System.out.println("[Conexão encerrada]");
            }    
            System.out.println("[Conexão encerrada]");    
        } catch (Exception e) {
            System.out.println("[Erro]\n");
            e.printStackTrace();
        }
    }
}
