import java.net.*;

public class LocalHost{
    public static void main(String args[]){
        try {
            InetAddress localIP = InetAddress.getLocalHost();
            String canonicalHostName = localIP.getCanonicalHostName();
            InetAddress google = InetAddress.getByName("www.google.com");
            String googleCanonicalHostName = google.getCanonicalHostName();

            System.out.println("Endereço de IP Local: " + localIP.getHostAddress());
            System.out.println("Nome do Host Local: " + localIP.getHostName());
            System.out.println("Nome/Endereco Local: " + localIP);
            System.out.println("Canonical Host Name: " + canonicalHostName);
            System.out.println("Google Canonical Host Name: " + googleCanonicalHostName);            
        } catch (UnknownHostException e) {
            System.err.println("Endereço local não pode ser determinado.\n" + e);
        }
    }
}