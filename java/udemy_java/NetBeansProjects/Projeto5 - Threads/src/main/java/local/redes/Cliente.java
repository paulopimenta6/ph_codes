package local.redes;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.net.UnknownHostException;
import javax.swing.JTextArea;
import javax.swing.SwingUtilities;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

/**
 *
 * @author Paulo Pimenta
 */
public class Cliente extends javax.swing.JFrame {

    private static final String SERVER_ADDRESS = "127.0.0.1";
    private static final int SERVER_PORT = 50000;

    private Socket socket = null;
    private ObjectOutputStream saidaObjeto = null;
    private ReceiverThread receiverThread = null;

    /**
     * Creates new form ClienteTCP_Persistente_Simples
     */
    public Cliente() {
        initComponents();
        connectToServer(); // Tenta conectar ao iniciar

        // Listener para fechar a conexão ao fechar a janela
        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                disconnectFromServer();
            }
        });
    }

    // Tenta conectar ao servidor
    private void connectToServer() {
        try {
            if (socket == null || socket.isClosed()) {
                socket = new Socket(SERVER_ADDRESS, SERVER_PORT);
                saidaObjeto = new ObjectOutputStream(socket.getOutputStream());
                saidaObjeto.flush(); // Envia header do stream

                // Inicia thread receptora
                receiverThread = new ReceiverThread(socket, jTArea);
                receiverThread.start();

                appendToTextArea("Conectado ao servidor em " + SERVER_ADDRESS + ":" + SERVER_PORT + "\n");
                System.out.println("Conectado ao servidor.");
            }
        } catch (UnknownHostException ex) {
            appendToTextArea("Erro: Host do servidor desconhecido (" + SERVER_ADDRESS + ")\n");
            System.err.println("Host desconhecido: " + SERVER_ADDRESS);
        } catch (IOException ex) {
            appendToTextArea("Erro: Falha ao conectar ao servidor. Verifique se o servidor está ativo.\n");
            System.err.println("Falha ao conectar: " + ex.getMessage());
        }
    }

    // Desconecta do servidor
    private void disconnectFromServer() {
        System.out.println("Desconectando...");
        appendToTextArea("Desconectando do servidor...\n");
        try {
            if (receiverThread != null) {
                receiverThread.interrupt();
            }
            // Fechar streams e socket (simplificado)
            if (socket != null && !socket.isClosed()) {
                socket.close(); // Fechar o socket geralmente fecha os streams associados
            }
        } catch (IOException e) {
            System.err.println("Erro ao fechar socket: " + e.getMessage());
        } finally {
            socket = null;
            saidaObjeto = null;
            receiverThread = null;
            System.out.println("Recursos liberados.");
            appendToTextArea("Desconectado.\n");
        }
    }

    // Envia objeto Pessoa
    private void sendPessoa(Pessoa p) {
        if (socket == null || socket.isClosed() || saidaObjeto == null) {
            appendToTextArea("Erro: Não conectado ao servidor. Reinicie o cliente para conectar.\n");
            return; // Não tenta reconectar
        }

        try {
            saidaObjeto.writeObject(p);
            saidaObjeto.flush();
            limparCampos();
            appendToTextArea("Objeto Pessoa (Nome: " + p.getNome() + ") enviado.\n");
            System.out.println("Objeto Pessoa enviado: " + p.getNome());
        } catch (IOException ex) {
            appendToTextArea("Erro de comunicação ao enviar: " + ex.getMessage() + ". Conexão perdida.\nReinicie o cliente.\n");
            System.err.println("Erro ao enviar objeto: " + ex.getMessage());
            // Considera a conexão perdida e limpa os recursos
            disconnectFromServer(); 
        }
    }

    // Atualiza JTextArea (thread-safe)
    private void appendToTextArea(String text) {
        SwingUtilities.invokeLater(() -> jTArea.append(text));
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTArea = new javax.swing.JTextArea();
        jTNome = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jTIdade = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        jBEnviar = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Cliente TCP Persistente (Simples)");

        jLabel1.setText("Nome");

        jTArea.setEditable(false);
        jTArea.setColumns(20);
        jTArea.setRows(5);
        jScrollPane1.setViewportView(jTArea);

        jLabel2.setText("Idade");

        jLabel3.setText("Respostas do Servidor / Log");

        jBEnviar.setText("Enviar Objeto");
        jBEnviar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jBEnviarActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 388, Short.MAX_VALUE)
                    .addComponent(jTNome)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel1)
                            .addComponent(jLabel2)
                            .addComponent(jTIdade, javax.swing.GroupLayout.PREFERRED_SIZE, 104, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel3))
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(jBEnviar)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTNome, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTIdade, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 130, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jBEnviar, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        pack();
        setLocationRelativeTo(null); // Centraliza a janela na tela
    }// </editor-fold>//GEN-END:initComponents

    private void limparCampos() {
        jTNome.setText("");
        jTIdade.setText("");
        jTNome.requestFocus();
    }

    private void jBEnviarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jBEnviarActionPerformed
        String nome = jTNome.getText().trim();
        String idadeStr = jTIdade.getText().trim();

        if (nome.isEmpty() || idadeStr.isEmpty()) {
            appendToTextArea("Erro: Preencha os campos Nome e Idade.\n");
            return;
        }

        try {
            int idade = Integer.parseInt(idadeStr);
            Pessoa p = new Pessoa();
            p.setNome(nome);
            p.setIdade(idade);
            sendPessoa(p);
        } catch (NumberFormatException e) {
            appendToTextArea("Erro: Idade inválida. Insira um número.\n");
        }
    }//GEN-LAST:event_jBEnviarActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Define Look and Feel (opcional) */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (Exception ex) {
            System.err.println("Erro ao definir Look and Feel: " + ex.getMessage());
        }

        /* Cria e exibe o form */
        java.awt.EventQueue.invokeLater(() -> {
            new Cliente().setVisible(true);
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jBEnviar;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextArea jTArea;
    private javax.swing.JTextField jTIdade;
    private javax.swing.JTextField jTNome;
    // End of variables declaration//GEN-END:variables

    // Thread interna para receber respostas do servidor
    private static class ReceiverThread extends Thread {
        private final Socket socket;
        private final JTextArea textArea;
        private BufferedReader entradaTexto = null;

        public ReceiverThread(Socket socket, JTextArea textArea) {
            this.socket = socket;
            this.textArea = textArea;
            setName("ReceiverThreadSimples-" + socket.getInetAddress().getHostAddress());
        }

        @Override
        public void run() {
            try {
                entradaTexto = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                String serverResponse;
                // Loop para ler respostas
                while (!Thread.currentThread().isInterrupted() && (serverResponse = entradaTexto.readLine()) != null) {
                    final String response = serverResponse;
                    // Atualiza JTextArea na thread do Swing
                    SwingUtilities.invokeLater(() -> textArea.append("Servidor: " + response + "\n"));
                }
            } catch (IOException e) {
                // Se o socket não estiver fechado intencionalmente, é um erro
                if (!socket.isClosed()) {
                     System.err.println("Erro de I/O no ReceiverThread: " + e.getMessage());
                     SwingUtilities.invokeLater(() -> textArea.append("Erro de conexão: " + e.getMessage() + "\n"));
                }
            } finally {
                 System.out.println("ReceiverThread terminando.");
                 SwingUtilities.invokeLater(() -> textArea.append("Conexão com servidor encerrada.\n"));
                // Tenta fechar o BufferedReader (simplificado)
                try {
                    if (entradaTexto != null) entradaTexto.close();
                } catch (IOException ex) { /* Ignora */ }
            }
        }
    }
}

