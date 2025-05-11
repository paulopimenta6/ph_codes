package local.redes;

import java.io.*;
import java.net.Socket;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.io.ObjectOutputStream;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

/**
* @author Paulo Henrique Pimenta
*/

public class FormCliente extends JFrame implements ActionListener{
    static final long serialVersionUID = 1L;
    JTextField txtNome, txtIdade;
    JButton btnEnviar;
    JLabel lblNome, lblIdade;
    JTextArea txtRetorno;
    JLabel lblRetorno;
    Socket socket;
    ObjectOutputStream saida;
    ObjectInputStream entrada;
    public static void main(String[] args) {
        FormCliente form = new FormCliente();
    }

    public FormCliente() {
        super("FormCliente");
        setLayout(null);

        //Componentes da janela
        lblNome = new JLabel("Nome");
        lblIdade = new JLabel("Idade");
        lblRetorno = new JLabel("Retorno do Servidor");
        btnEnviar = new JButton("Enviar");
        txtNome = new JTextField();
        txtIdade = new JTextField();
        txtRetorno = new JTextArea();
        lblNome.setBounds(20, 20, 100, 20);
        txtNome.setBounds(20, 45, 550, 20);
        lblIdade.setBounds(20, 80, 100, 20);
        txtIdade.setBounds(20, 105, 550, 20);
        lblRetorno.setBounds(20, 135, 140, 20);
        txtRetorno.setBounds(20, 160, 550, 200);
        btnEnviar.setBounds(470, 375, 100, 20);
        add(lblNome);
        add(txtNome);
        add(lblIdade);
        add(txtIdade);
        add(lblRetorno);
        add(txtRetorno);
        add(btnEnviar);
        btnEnviar.addActionListener(this);

        //Configurações da Janela
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(600, 450);
        setVisible(true);

        //conectando com o servidor
        this.serverConnect();
    }

    public void serverConnect() {
        try{
            socket = new Socket("localhost", 50000);
            saida = new ObjectOutputStream(socket.getOutputStream());
            entrada = new ObjectInputStream(socket.getInputStream());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void actionPerformed(ActionEvent event) {
        if (event.getSource() == btnEnviar) {
            try {
                Pessoa pessoa = new Pessoa(txtNome.getText(), Integer.parseInt(txtIdade.getText()));
                saida.writeObject(pessoa);
                boolean received = entrada.readBoolean();
                if(received)
                    txtRetorno.setText("Recebeu do servidor: Dados recebidos corretamente!");

            } catch (IOException e) {
                txtRetorno.setText("Erro ao enviar/receber os dados para o servidor: " + e.getMessage());
            }
        }
    }
}