package br.com.alura.algoritmos;

public class TesteOrdenacao {
    
    public static void main(String[] args) {
        Produto produtos[] = {
            new Produto("Lamborghini", 1000000),
            new Produto("Jipe", 46000),
            new Produto("Brasilia", 16000),
            new Produto("Smart", 46000),
            new Produto("Fusca", 17000)
        };
        
        ordena(produtos);
        
        for(int i = 0; i < produtos.length; i++){
            System.out.println(produtos[i].getNome() + " custa: " + produtos[i].getPreco());
        }
    }
    
    private static void ordena(Produto[] produtos){
        for(int atual = 0; atual < produtos.length; atual++){
           int menor = buscaMenor(produtos, atual, produtos.length);
           Produto produtoAtual = produtos[atual];
           Produto produtoMenor = produtos[menor];
           //realizando um swap...
           produtos[atual] = produtoMenor;
           produtos[menor] = produtoAtual;            
       }
    }
    
    private static int buscaMenor(Produto[] produtos, int inicio, int termino){
        int maisBarato = inicio;
        for(int atual = inicio; atual < termino; atual++){
            if(produtos[atual].getPreco() < produtos[maisBarato].getPreco()){
                maisBarato = atual;
            }
        }
        return maisBarato;
    }
    
}
