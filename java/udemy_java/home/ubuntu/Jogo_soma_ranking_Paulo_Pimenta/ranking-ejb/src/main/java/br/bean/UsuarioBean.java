package br.bean;

import javax.ejb.Stateful;
import java.io.Serializable;

// Author: Paulo Henrique Pimenta
@Stateful
public class UsuarioBean implements Serializable {

    private String nomeUsuario;
    private int pontuacao = 0;

    public String getNomeUsuario() {
        return nomeUsuario;
    }

    public void setNomeUsuario(String nomeUsuario) {
        this.nomeUsuario = nomeUsuario;
    }

    public int getPontuacao() {
        return pontuacao;
    }

    public void incrementarPontuacao() {
        this.pontuacao++;
    }
}

