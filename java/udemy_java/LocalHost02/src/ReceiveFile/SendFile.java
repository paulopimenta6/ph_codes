package ReceiveFile;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Scanner;

public class SendFile {
    public static void main(String args[]){
    Scanner sc = new Scanner(System.in);
    String ans;
    do {         
        System.out.println("[Conectando ao servidor...]");
        System.out.print("Digite o caminho do arquivo a ser enviado: ");
        String caminhoArquivo = sc.nextLine().trim();
        System.out.println("O caminho é: " + caminhoArquivo);
        File file = new File(caminhoArquivo);
        if(!file.exists()){
            System.out.println("Arquivo não encontrado: " + file.getPath());
            //sc.close();
            return;
        }
        long total = file.length();
        //sc.close();
        try(Socket clienteC = new Socket("localhost", 1234);
            Socket clienteD = new Socket("localhost", 1235)) {

                System.out.printf("[Conexão aceita de %s]\n", clienteC.getInetAddress().toString());
                //Obtenção dos dados e sua abertura                
                System.out.printf("[Enviando arquivo '%s']\n", file.getName());
                BufferedInputStream arquivo = new BufferedInputStream(new FileInputStream(file));
                //abre canal controle (modo texto)
                PrintWriter canalC = new PrintWriter(clienteC.getOutputStream(), true);
                long sent = 0;
                
                System.out.printf("[%d bytes no arquivo]\n", total);
                canalC.println(file.getName()); //envio dos dados do arquivo
                canalC.println(total + "");
                canalC.close(); //fecha canal modo texto
                //abertura canal binario
                BufferedOutputStream canalD = new BufferedOutputStream(clienteD.getOutputStream());
                
                while(sent + 256 < total){
                    byte dados[] = new byte[256]; //cria array para blocos
                    arquivo.read(dados, 0, 256); //lê dados para o bloco
                    canalD.write(dados, 0, 256); //envia blocos
                    sent += 256;
                }
                if(sent < total){
                    int fim = (int)(total - sent);
                    byte dados[] = new byte[fim]; //cria array para bloco final
                    arquivo.read(dados, 0, fim); //lê dados para bloco final
                    canalD.write(dados, 0, fim); //enia blocos final
                }
                canalD.flush();
                canalD.close(); //fecha canal binario
                arquivo.close(); //fecha arquivo
                System.out.printf("[%d bytes enviados]\n", total);           
        } catch (IOException exc) {
            System.out.println("Problemas no envio");
            exc.printStackTrace();
        } //fecha conexão com close() implicito de clienteC e clienteD
        System.out.print("Deseja continuar [s/S ou n/N]?: ");
        ans = sc.nextLine().trim();      
    } while(!ans.equalsIgnoreCase("n"));
    sc.close();
    System.out.println("Conexão encerrada");
}

}

