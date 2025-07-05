package br.bean;

import javax.ejb.Singleton;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Singleton
public class RankingBean {
    
    private Map<String, Integer> players = new HashMap<>();
    
    public void addPlayer(String name) {
        if (!players.containsKey(name)) {
            players.put(name, 0);
        }
    }
    
    public void incrementScore(String name) {
        if (players.containsKey(name)) {
            players.put(name, players.get(name) + 1);
        } else {
            players.put(name, 1);
        }
    }
    
    public List<Map.Entry<String, Integer>> getRanking() {
        List<Map.Entry<String, Integer>> sortedPlayers = new ArrayList<>(players.entrySet());
        
        // Ordenar por pontuação em ordem decrescente
        Collections.sort(sortedPlayers, new Comparator<Map.Entry<String, Integer>>() {
            @Override
            public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
                return o2.getValue().compareTo(o1.getValue());
            }
        });
        
        return sortedPlayers;
    }
    
    public int getScore(String name) {
        return players.getOrDefault(name, 0);
    }
}

