package com.utfpr.backendempresa.repository;

import com.utfpr.backendempresa.entity.Funcionario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FuncionarioRepository extends JpaRepository<Funcionario, Long> {

    //1 - Listar um funcionario pelo seu nome e quantidade de depdendentes usando consulta por palavra chave
    Funcionario findByNomeAndDependentes(String nome, int dependentes);

   //2 - Listar todos os funcionarios de um determinado departamento por JPQL via @Query
   @Query("SELECT f from Funcionario f WHERE f.departamento.id = :departamentoId");
   List<Funcionario> findByDepartamentoId(@Param("departamentoId") Long departamentoId);
}
