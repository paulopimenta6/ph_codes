package com.utfpr.backendempresa.repository;

import com.utfpr.backendempresa.entity.Funcionario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface FuncionarioRepository extends JpaRepository<Funcionario, Long> {

    //1 - Listar um funcionario pelo seu nome e quantidade de depdendentes usando consulta por palavra chave
    Funcionario findByNomeAndDependentes(String nome, int dependentes);

   //2 - Listar todos os funcionarios de um determinado departamento por JPQL via @Query
   @Query("SELECT f FROM Funcionario f WHERE f.departamento.id = :departamentoId")
   List<Funcionario> findByDepartamentoId(@Param("departamentoId") Long departamentoId);

   //4 - Listar o primeiro funcionario que tem o maior salario
   Funcionario findFirstByOrderBySalario();

   //5 - Listar os 3 primeiros funcionarios que tem os maiores salarios
   List<Funcionario> findTop3ByOrderBySalarioDesc();

   //6 - Listar os funcionarios que nao tem dependentes em ordem crescente de nome por JPQL via @Query
   @Query("SELECT f FROM Funcionario f where f.dependentes = 0 ORDER BY f.nome ASC")
   List<Funcionario> findByDependentesIsZeroOrderByNomeAsc();

  //7 - Listar os funcionarios que tem salario maior que um determinado valor por JPQL sobrescrevendo palavras-chaves @Query
  @Query("SELECT f FROM Funcionario f WHERE f.salario > :salario")
  List<Funcionario> findBySalarioGreaterThan(@Param("salario") BigDecimal salario);

  //8 - Listar os funcionarios que tem salario maior que um determinado valor por @Query com native query
  @Query(value = "SELECT * FROM Funcionario f WHERE f.salario > :salario", nativeQuery = true)
  List<Funcionario> findBySalarioGreaterThanNative(@Param("salario") BigDecimal salario);

  //9 - Alterar a classe Funcionario e criar uma consulta para listar os funcionarios com uma determinada quantidade de dependentes por @NamedQuery
  List<Funcionario> findByDependentes(@Param("dependentes") int dependentes);

  //10 - Alterar a classe Funcionario e criar uma consulta para listar os funcionarios que contenham em qualquer parte do seu nome um determinado nome por @NamedNativeQuery
  List<Funcionario> findByNomeContaining(@Param("nome") String nome);

  // ------------ Atividade de manipulacao de dados e transacoes ------------
  // 01. Implementar a chamada de uma stored procedure criada no banco de dados, que aumenta o salário de todos os funcionários em X porcento, onde X é um número inteiro.
  @Query(value = "CALL aumentarSalario(:porcentagem)", nativeQuery = true)
  void aumentarSalario(@Param("porcentagem") int porcentagem);

  // 02. Uma consulta que lista todos os funcionários de um determinado departamento que não possuam dependentes utilizando parâmetros nomeados.
  @Query("SELECT f FROM Funcionario f WHERE f.departamento.id = :departamentoId AND f.dependentes = 0")
  List<Funcionario> findFuncionariosSemDependentes(@Param("departamentoId") Long departamentoId);

  // 03. Uma instrução de update que troca todos os funcionários de um determinado departamento para outro departamento utilizando a anotação @Modifying.
  @Modifying
  @Transactional
  @Query("UPDATE Funcionario f SET f.departamento.id = :novoDepartamentoId WHERE f.departamento.id = :antigoDepartamentoId")
  void atualizarDepartamento(@Param("antigoDepartamentoId") Long antigoDepartamentoId, @Param("novoDepartamentoId") Long novoDepartamentoId);

  // 04. Uma instrução de delete que exclui todos os funcionários de um determinado departamento utilizando a anotação @Modifying.
  @Modifying
  @Transactional
  @Query("DELETE FROM Funcionario f WHERE f.departamento.id = :departamentoId")
  void deletarFuncionariosPorDepartamento(@Param("departamentoId") Long departamentoId);
}
