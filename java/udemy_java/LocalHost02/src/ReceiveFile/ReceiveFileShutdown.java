package ReceiveFile;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;

/**
 *
 * @author Paulo_Pimenta
 */
public class ReceiveFileShutdown {
    public static void main(String args[]) throws IOException{
        System.out.println("[Conectando Servidor...]");
        Socket controle = new Socket("localhost", 1234);
        Socket dados = new Socket("localhost", 1235);
        
        //abre canal controle (modo texto)
        PrintWriter saidaTexto = new PrintWriter(controle.getOutputStream(), true);
        System.out.println("[Requisitando Shutdown...]");
        saidaTexto.println("@shutdown"); //enviando comando para encerramento.
        saidaTexto.close(); //fecha canal de conunicações
        controle.close();
        dados.close();        
        System.out.println("[Ok]");
    }
            
    
}
