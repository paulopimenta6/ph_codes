package com.utfpr.backendempresa.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "funcionario")
@Data
public class Funcionario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "codigo", nullable = false)
    private long codigo;

    @Column(name = "nome")
    private String nome;

    @Column(name = "dependentes")
    private int dependentes;

    @Column(name = "salario")
    private double salario;

    @Column(name = "cargo")
    private String cargo;

    @ManyToOne
    @JoinColumn(name = "codigo_dep", nullable = false)
    private Departamento departamento;
}
