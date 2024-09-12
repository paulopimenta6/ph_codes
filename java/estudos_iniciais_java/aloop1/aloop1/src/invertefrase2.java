import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import javax.swing.JOptionPane;
import java.io.FileWriter;
import java.io.PrintWriter;

public class invertefrase2 {
    public String invertefrase2 (String a, String n1, int n2){
    int i,j,n,m1,l;
        String resposta,frase;
        resposta = null;
        frase=a;
        n = Integer.parseInt(n1);
        int [][]c = new int[n][n];          // tabua do grupo
        int [][]c1 = new int[2*n][2*n];     // tabua do holomorfo
        int []d = new int [n];             //inversos de cada elemento do grupo
        m1 = n2;




        //parte do programa destinada a criar um arquivo interfrase4processando.txt com a frase digitada anteriormente


        try {
            FileWriter arq = new FileWriter( "interfrase4processando.txt" );
            PrintWriter out = new PrintWriter( arq );

            out.println( frase );               // escreve no arquivo saida a frase

            out.close();
        }
        catch ( IOException erro ) {
            JOptionPane.showMessageDialog(null, "Erro na escrita dos dados", "Erro", 0);
        }








//parte do programa destinada a ler interfrase4processando.txt com a frase digitada anteriormente e invertê-la

        try {
            FileReader ent = new FileReader("interfrase4processando.txt");
            BufferedReader br = new BufferedReader ( ent );
            String linha;
            String []campos2 = null;                    // campos2 irá quebrar cada linha em algarismos 0 e 1, campos2[0]= vazio, por isso ele tem comprimento nulo,caso contrário se tivesse algum espaço no final da linha o programa não funcionaria
            linha=br.readLine();
            campos2=linha.split(" ");                 // lê a primeira linha do arquivo entrada
            String resposta1;

            resposta1 = campos2[2];
            for (j=1;j<n;j++){
                resposta1 += campos2[j+2];
            }

            l=(n-1)+ 7;
            resposta1 += ",";
            for (i=1;i<n;i++){
                for (j=0;j<n;j++){
                    resposta1 += campos2[j+l];
                }
                l = n + 4 + l;
                resposta1 += ",";
            }

            String []campos3 = null;
            campos3=resposta1.split(",");

            for (i=0;i<n;i++){
                for (j=0;j<n;j++){
                    c[i][j] = Integer.parseInt(campos3[i*n + j]);
                    c1[i][j] = c[i][j];                                 // bloco superior esquerdo do holomorfo
                }
            }
            for (i=0;i<n;i++){
                for (j=0;j<n;j++){
                    if(c[i][j]==1){
                        d[i]=j;
                    }
                }
            }

            for (i=0;i<n;i++){
                for (j=0;j<n;j++){
                    c1[i+n][j] = n + c[i][j];                         //bloco inferior esquerdo do holomorfo
                    c1[i][j+n] = n + c[d[i]][j];                    //bloco superior direito do holomorfo
                    c1[i+n][j+n] = c[i][(d[j])];                     //bloco inferior direito do holomorfo
                }
            }
            

            if(m1==0){
                resposta = "1/" + String.valueOf(d[0] + 1);
                 for (j=1;j<n;j++){
                    resposta += ", " + String.valueOf(j + 1) + "/" + String.valueOf(d[j]+1);
                }
            }
                else {

            String []resposta2 = new String [2*n];

            resposta = "[ [ ";

            resposta2[0] ="[ [ ";
            for(i=1;i<2*n;i++){
                resposta2[i] ="  [ ";
            }
            for(i=0;i<2*(n-1)+1;i++){
                for (j=0;j<2*(n-1)+1;j++){
                    resposta += String.valueOf(c1[i][j] ) + ", ";
                    resposta2 [i] += String.valueOf(c1[i][j] ) + ", ";
                }
                resposta += String.valueOf(c1[i][2*(n-1)+1] ) + " ], \n [ ";
                resposta2[i] += String.valueOf(c1[i][2*(n-1)+1] ) + " ],";
            }
            for (j=0;j<2*(n-1)+1;j++){
                    resposta += String.valueOf(c1[2*(n-1)+1][j] ) + ", ";
                    resposta2[2*(n-1)+1] += String.valueOf(c1[2*(n-1)+1][j] ) + ", ";
                }
                resposta += String.valueOf(c1[2*(n-1)+1][2*(n-1)+1] ) + " ]];";
                resposta2[2*(n-1)+1] += String.valueOf(c1[2*(n-1)+1][2*(n-1)+1] ) + " ]];";



                try {
            FileWriter arq = new FileWriter( "aloop.txt" );
            PrintWriter out = new PrintWriter( arq );
            for (j=0;j<2*n;j++){
                out.println( resposta2[j] );               // escreve no arquivo saida a frase
            }
            out.close();
        }
        catch ( IOException erro ) {
            JOptionPane.showMessageDialog(null, "Erro na escrita dos dados", "Erro", 0);
        }



            }
            

            //JOptionPane.showInputDialog(null, "Frase invertida, de control c para copiá-la", "Frase invertida", -1, null, null, resposta);
            br.close();
          }

        catch(IOException erro){
            JOptionPane.showMessageDialog(null, "Erro na leitura dos dados", "Erro", 0);
        }





        //deleta o arquivo interfrase4processando.txt

        try{


        File delFile1 = new File("interfrase4processando.txt");
            delFile1.createNewFile();
            delFile1.delete();

        }
        catch(IOException e){}


        return(resposta);
    }


}