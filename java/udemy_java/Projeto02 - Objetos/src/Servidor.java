import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

/**
* @author Paulo Henrique Pimenta
*/

public class Servidor {
    public static void main(String args[]) throws IOException{
        while(true){
            try(ServerSocket servidor = new ServerSocket(55000);
                Socket conexao = servidor.accept();                
                ObjectInputStream entrada = new ObjectInputStream(conexao.getInputStream());
                ObjectOutputStream saida = new ObjectOutputStream(conexao.getOutputStream())){
                    System.out.println("[Cliente conectando no IP:Porta:" + 
                            conexao.getInetAddress().getHostAddress() + ":" + conexao.getPort() + "]");
                    
                    Pessoa pessoa = (Pessoa) entrada.readObject();
                    saida.writeBoolean(pessoa != null);
                    escreverPessoa(pessoa);                    
                               
            } catch(Exception e) {
                e.printStackTrace();
            }    
        }        
    }
    public static void escreverPessoa(Pessoa pessoa){
        System.out.println("Dados recebidos: ");
        System.out.println("Nome: " + pessoa.getNome() + " Idade: " + pessoa.getIdade());
    }
}