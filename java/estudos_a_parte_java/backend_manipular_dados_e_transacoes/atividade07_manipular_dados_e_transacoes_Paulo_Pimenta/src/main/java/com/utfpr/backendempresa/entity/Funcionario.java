package com.utfpr.backendempresa.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "funcionario")
@Data
//9 - Alterar a classe Funcionario e criar uma consulta para listar os funcionarios com uma determinada quantidade de dependentes por @NameedQuery
@NamedQuery(name = "Funcionario.findByDependentes", query = "SELECT f FROM Funcionario f where f.dependentes = :dependentes")
//10 - Alterar a classe Funcionario e criar uma consulta para listar os funcionarios que contenham em qualquer parte do seu nome umm determinado nome por @NamedNativeQuery
@NamedNativeQuery(name = "Funcionario.findByNomeContaining", query = "SELECT * FROM funcionario f where f.nome LIKE :nome", resultClass = Funcionario.class)
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
