import java.util.Scanner;

/**
 *
 * @author Paulo Pimenta
 */
public class MatrizDeterminante {

    static double calcDeterminante(double matriz[][]){
        double D = 0;        
        
        if (matriz.length == 1){
            return matriz[0][0];
        }
        else{
            double sinal = 1;
            int tamanho = (matriz.length - 1);
            double matrizCof[][] = new double[tamanho][tamanho];
            
            for(int f = 0; f < matriz.length; f++){
                cofator(matriz, matrizCof, 0, f);
                D = D + (sinal*matriz[0][f]*calcDeterminante(matrizCof));
                sinal = -sinal;
            }
            return D;            
        }              
    }    
    
    static void cofator(double matriz[][], double matrizCof[][], int linhaCofator, int colunaCofator){
        int lin = 0; 
        int col = 0;
        int tamanho = matrizCof.length;               
        
        for(int i = 0; i < matriz.length; i++){
            for(int j = 0; j < matriz.length; j++){
                if (i != linhaCofator && j != colunaCofator){
                    matrizCof[lin][col] = matriz[i][j];
                    col = col + 1;
                    if(col == tamanho){
                        col = 0;
                        lin = lin + 1;
                    }                    
                }
            }
        }       
    }    
        
    static void iniciaMatriz(){
        
        Scanner sc = new Scanner(System.in);
        
        System.out.print("Digite o numero de linhas/colunas e da matriz: ");
        int tamanho = sc.nextInt();
        
        double matriz[][] = new double[tamanho][tamanho];              
        
        for(int i = 0; i < matriz.length; i++){
            for(int j = 0; j < matriz[i].length; j++){
                System.out.printf("Valor de matriz[%d][%d]: ", i, j);
                matriz[i][j] = sc.nextDouble();
            }
        }

        
        double resul = calcDeterminante(matriz);        
        System.out.printf("Resultado: %.2f\n", resul);
    }    
    
    public static void main(String args[]){
        iniciaMatriz();

    }
    
    
        
        
    
        
        
}
    

