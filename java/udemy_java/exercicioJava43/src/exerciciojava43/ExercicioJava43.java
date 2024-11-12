package exerciciojava43;

import java.util.Scanner;
/**
 *
 * @author Paulo_Pimenta
 */
public class ExercicioJava43 {   
    
    public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);    
    
    System.out.print("Digite o numero de linhas (M): ");
    int M = sc.nextInt();
    
    System.out.print("Digite o numero de colunas (N): ");
    int N = sc.nextInt();
    
    int[][] mat = new int[M][N];
    
    System.out.print("Digite o numero inteiro de matriz\n");
    
    for(int i = 0; i < mat.length; i++){
        for(int j = 0; j < mat[i].length; j++){
            //System.out.printf("Digite o numero inteiro de mat[%d][%d]: ", i,j);
            mat[i][j] = sc.nextInt();            
        }
    }
    
    System.out.print("Digite um valor inteiro: ");
    int X = sc.nextInt();
    
    for(int pos_i = 0; pos_i < mat.length; pos_i++){
        for(int pos_j = 0; pos_j < mat[pos_i].length; pos_j++){
            if (mat[pos_i][pos_j] == X){
                System.out.printf("Posicao i: %d, j: %d%n", pos_i, pos_j);
            
                if(pos_j > 0){
                    //left
                    System.out.println("left: " + mat[pos_i][pos_j-1]);
                }            
                if(pos_i > 0){                
                    //up
                    System.out.println("up: " + mat[pos_i-1][pos_j]);
                }                
                if(pos_j < mat[pos_i].length - 1){
                    //right            
                    System.out.println("right: " + mat[pos_i][pos_j+1]);
                }
                if(pos_i < mat.length - 1){
                    //down
                    System.out.println("down: " + mat[pos_i+1][pos_j]);
                }
            }           
        }
    }
    
    sc.close();
    
    }      
}
