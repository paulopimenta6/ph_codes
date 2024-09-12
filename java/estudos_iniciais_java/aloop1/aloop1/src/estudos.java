import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.ButtonGroup;
import javax.swing.JFrame;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTextField;
import javax.swing.WindowConstants;

public class estudos extends JFrame{

    private Container      cont;
    private JPanel          panelCentro;
    private final JTextField txtValor1;
    private final JTextField txtValor2;
    private final JTextField txtValor3;
    private final JTextField txtValor4;
    private final JPanel panelDir;
    private final JPanel panelSul;
    private final ButtonGroup grupo;



   private char         op;

    public estudos(){
        super("A-loop");

        cont          = getContentPane();
      cont.setLayout(new BorderLayout());

      panelCentro      = new JPanel(new GridLayout(4,4,5,5));
      panelDir      = new JPanel(new GridLayout(4,1));
      panelSul      = new JPanel(new GridLayout(1,2));

      grupo         = new ButtonGroup();

      txtValor1      = new JTextField();
      txtValor2      = new JTextField();
      txtValor3      = new JTextField();
      txtValor4      = new JTextField();

      panelCentro.add(new JLabel("Insira a ordem do grupo: "));
      panelCentro.add(txtValor4);
      panelCentro.add(new JLabel("Insira o grupo abeliano: "));
      panelCentro.add(txtValor1);
      panelCentro.add(new JLabel("Elementos/Inversos: "));
      panelCentro.add(txtValor3);
      panelCentro.add(new JLabel("A-loop: "));
      panelCentro.add(txtValor2);

      //panelDir.add(btMais);

      //panelSul.add(btResult);
      //panelSul.add(btSair);

     // btResult.addActionListener(this);
      //btSair.addActionListener(this);


      cont.add(new JLabel(""), BorderLayout.NORTH);
      cont.add(panelCentro, BorderLayout.CENTER);
      cont.add(panelSul, BorderLayout.SOUTH);
      cont.add(panelDir, BorderLayout.EAST);


     //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx






    //adiciona botão escrito sair que fecha o aplicativo
    //Container c = getContentPane();
    //c.setLayout(new FlowLayout(FlowLayout.CENTER));

    JButton btn = new JButton("Iniciar");
    btn.addActionListener(
      new ActionListener(){
        public void actionPerformed(ActionEvent e){

          String a,n1;
          a = txtValor1.getText().trim();                                   // copia o que está escrito na caixa de texto em frente ao "Valor 1" na string a
          n1 = txtValor4.getText().trim();
          invertefrase2 m = new invertefrase2();
          txtValor2.setText(m.invertefrase2(a,n1,1));                                         // escreve aaa na caixa de texto em frente ao valor 2
          txtValor3.setText(m.invertefrase2(a,n1,0));

        }
      }
    );

    // Adiciona o botão à janela
    //cont.add(btn);

    //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx













//adiciona botão escrito sair que fecha o aplicativo
    //Container c = getContentPane();
    //c.setLayout(new FlowLayout(FlowLayout.CENTER));

    JButton btn2 = new JButton("Ajuda");
    btn2.addActionListener(
      new ActionListener(){
        public void actionPerformed(ActionEvent e){
            JOptionPane.showMessageDialog(null,"Para o programa funcionar, no bloco \n de notas a tabua do grupo abeliano tem \n que estar no seguinte formato: \n [ [ 1, 2, 3 ],\n    [ 2, 3, 1 ],\n    [ 3, 1, 2 ] ]", "Ajuda", 1);
          }
      }
    );

    // Adiciona o botão à janela
    //cont.add(btn);

    //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


    //adiciona botão escrito sair que fecha o aplicativo
    //Container c = getContentPane();
    //c.setLayout(new FlowLayout(FlowLayout.CENTER));

    JButton btn3 = new JButton("Sair");
    btn3.addActionListener(
      new ActionListener(){
        public void actionPerformed(ActionEvent e){
          System.exit(0);
        }
      }
    );

    // Adiciona o botão à janela
    //cont.add(btn);

    //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


        panelSul.add(btn);              //adiciona os botões no panelSul
        panelSul.add(btn2);
        panelSul.add(btn3);


      cont.add(new JLabel(""), BorderLayout.NORTH);
      cont.add(panelCentro, BorderLayout.CENTER);
      cont.add(panelSul, BorderLayout.SOUTH);               //coloca o panelSul na parte sul do painel
      cont.add(panelDir, BorderLayout.EAST);









    setSize(350, 250);
    setVisible(true);
    setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);





        // centraliza a janela (tem que ser escrito depois do setSize(350, 250); setVisible(true); senão não fica no centro
    setLocationRelativeTo(null);
    //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx




    }

    public static void main(String args[]){
    estudos app = new estudos();
    app.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);



  }


}
