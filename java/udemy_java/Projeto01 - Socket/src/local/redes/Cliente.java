// Aluno: Paulo Henrique de Almeida Soares Pimenta
package local.redes;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;

public class Cliente {
    
    private static Socket socket;
    private static DataInputStream entrada;
    private static DataOutputStream saida;
    
    public static void main(String[] args) {
        
        try {
            
            socket = new Socket("127.0.0.1", 55001);            
            entrada = new DataInputStream(socket.getInputStream());
            saida = new DataOutputStream(socket.getOutputStream());
            
            //Recebe do usuário algum valor
            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
            System.out.print("Digite algum valor numérico: ");
            String cpf = br.readLine();            
            
            //O valor é enviado ao servidor
            saida.writeUTF(cpf);
            
            //Recebe-se o resultado do servidor
            String resultado = entrada.readUTF();
            
            //Mostra o resultado na tela
            System.out.println("Resultado da validacao: " + resultado);
            
            socket.close();
            
        } catch(IOException e) {
            System.out.println("Erro no cliente: " + e.getMessage());
        }
        
    }
    
}
