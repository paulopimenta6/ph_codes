package br.bean;

import javax.ejb.Stateless;
import java.util.Random;

@Stateless
public class SomaBean {
    
    private Random random = new Random();
    
    public int[] generateNumbers() {
        int[] numbers = new int[2];
        numbers[0] = random.nextInt(100);
        numbers[1] = random.nextInt(100);
        return numbers;
    }
    
    public boolean checkAnswer(int num1, int num2, int answer) {
        return (num1 + num2) == answer;
    }
}

