//Aluno: Paulo Henrique de Almeida Soares Pimenta

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

class Competidor implements Runnable {
    private final String nome;
    private Corrida corrida;
    private int pontosTotais = 0;

    public Competidor(String nome) {
        this.nome = nome;
    }

    public void setCorrida(Corrida corrida) {
        this.corrida = corrida;
    }

    @Override
    public void run() {
        try {
            // Simula o tempo da corrida com um tempo aleatório
            Thread.sleep((long) (Math.random() * 500));

            // Competidor chega à linha de chegada
            int pontos = corrida.chegarLinhaDeChegada(this);
            this.pontosTotais += pontos;

        } catch (InterruptedException exc) {
            System.out.println("Corrida interrompida!!!");
        }
    }

    public String getNome() {
        return nome;
    }

    public int getPontosTotais() {
        return pontosTotais;
    }
}

class Corrida {
    private final List<Competidor> rankingCorrida = new ArrayList<>();
    private final List<Competidor> competidores;

    public Corrida(List<Competidor> competidores) {
        this.competidores = competidores;
        for (Competidor c : competidores) {
            c.setCorrida(this);  // Atualiza a referência da corrida nos competidores
        }
    }

    public synchronized int chegarLinhaDeChegada(Competidor competidor) {
        int pontos = 10 - rankingCorrida.size(); // Pontuação decrescente conforme a ordem de chegada
        rankingCorrida.add(competidor);
        System.out.println(competidor.getNome() + " chegou na linha de chegada e ganhou " + pontos + " pontos.");
        return pontos;
    }

    public void iniciarCorrida() {
        rankingCorrida.clear(); // Reseta o ranking para a nova corrida
        List<Thread> threads = new ArrayList<>();

        // Criando e iniciando threads
        for (Competidor competidor : competidores) {
            Thread thread = new Thread(competidor);
            threads.add(thread);
            thread.start();
        }

        // Aguarda todas as threads terminarem
        for (Thread thread : threads) {
            try {
                thread.join();
            } catch (InterruptedException exc) {
                System.out.println("Corrida interrompida!!!");
            }
        }
    }
}

public class Campeonato {
    public static void main(String[] args) {
        final int NUM_COMPETIDORES = 10;
        final int NUM_CORRIDAS = 10;

        List<Competidor> competidores = new ArrayList<>();

        // Criando os competidores
        for (int i = 1; i <= NUM_COMPETIDORES; i++) {
            competidores.add(new Competidor("Competidor #" + i));
        }

        // Criando e executando as corridas
        for (int i = 1; i <= NUM_CORRIDAS; i++) {
            System.out.println("\n ======= Iniciando Corrida " + i + " =======");
            Corrida corrida = new Corrida(competidores);
            corrida.iniciarCorrida();
        }

        // Ordenar os competidores pelo total de pontos usando java.util.collections
        competidores.sort(Comparator.comparingInt(Competidor::getPontosTotais).reversed());

        // Exibir o pódio com verificação de tamanho
        // Usei o if para garantir que independente do tamanho do numero de competidores, que pode variar, sempre havera um podio
        System.out.println("\n ======= Pódio =======");
        if (competidores.size() > 0) {
            System.out.println("1º Lugar: " + competidores.get(0).getNome() + " com " + competidores.get(0).getPontosTotais());
        }
        if (competidores.size() > 1){
            System.out.println("2º Lugar: " + competidores.get(1).getNome() + " com " + competidores.get(1).getPontosTotais());
        }
        if (competidores.size() > 2){
            System.out.println("3º Lugar: " + competidores.get(2).getNome() + " com " + competidores.get(2).getPontosTotais());
        }

        // Exibir o ranking final
        System.out.println("\n ======= Placar Final do Campeonato =======");
        for (int i = 0; i < competidores.size(); i++) {
            System.out.println((i + 1) + "º lugar: " + competidores.get(i).getNome() + " - " + competidores.get(i).getPontosTotais() + " pontos");
        }
    }
}
