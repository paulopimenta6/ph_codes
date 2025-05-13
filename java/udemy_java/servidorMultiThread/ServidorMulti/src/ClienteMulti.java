import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.Scanner;

public class ClienteMulti {
    public static void main(String[] a){
        Scanner sc = new Scanner(System.in);

        System.out.println("[Conectando Servidor...]");
        try(Socket cliente = new Socket("localhost", 1234);){

            System.out.printf("[Conexao aceita de: %s]", cliente.getInetAddress().toString());
            System.out.println("[Enviando Limite...]");
            ObjectOutputStream saida = new ObjectOutputStream(cliente.getOutputStream());
            saida.flush();

            System.out.print("Digite um valor: ");
            int valor = sc.nextInt();

            saida.writeObject(new Integer(valor));
            System.out.println("[Recebendo mensagem...]");
            ObjectInputStream entrada = new ObjectInputStream((cliente.getInputStream()));
            String msg;

            do {
                msg = (String) entrada.readObject();
                System.out.println(msg);
            } while(!msg.equals("EOT"));

            System.out.println("[Contagem Ok! Conexao encerrada.");

        } catch (ClassNotFoundException | IOException e) {
            System.out.println("Erro!\n" + e.getMessage());
        }
    }
}
