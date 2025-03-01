package com.utfpr.backendempresa.service;

import com.utfpr.backendempresa.entity.Funcionario;
import com.utfpr.backendempresa.repository.FuncionarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class FuncionarioService {
    @Autowired
    private FuncionarioRepository funcionarioRepository;

    //1 - Listar um funcionario pelo seu nome e quantidade de dependentes utilizando consulta por palavras chaves
    public Funcionario findByNomeAndDependentes(String nome, int dependentes){
        return funcionarioRepository.findByNomeAndDependentes(nome, dependentes);
    }

    //2 - Listar todos os funcionarios de um determinado departamento por JPQL via Query
    public List<Funcionario> findByDepartamentoId(Long departamentoId){
        return funcionarioRepository.findByDepartamentoId(departamentoId);
    }

    //4 - Listar o primeiro funcionario que tem o maior salario
    public Funcionario findFirstByOrderBySalarioDesc(){
        return funcionarioRepository.findFirstByOrderBySalario();
    }

    //5 - Listar os 3 primeiros funcionarios que tem os maiores salarios
    public List<Funcionario> findTop3ByOrderBySalarioDesc(){
        return funcionarioRepository.findTop3ByOrderBySalarioDesc();
    }

    //6 - Listar os funcionarios que na tem dependentes em ordem crescente de nome por JPQL via @Query
    public List<Funcionario> findByDependentesIsZeroOrderByNomeAsc(){
        return funcionarioRepository.findByDependentesIsZeroOrderByNomeAsc();
    }

    //7 - Listar os funcionarios que tem salario maior que um determinado valor por JPQL sobrescrevendo palavras-chaves @Query
    public List<Funcionario> findBySalarioGreaterThan(BigDecimal salario){
        return funcionarioRepository.findBySalarioGreaterThan(salario);
    }

    //8 - Listar os funcionarios que tem salario maior quem determinado valor por @Query com native Query
    public List<Funcionario> findBySalarioGreaterThanNative(BigDecimal salario){
        return funcionarioRepository.findBySalarioGreaterThanNative(salario);
    }

    //9 - Alterar a classe Funcionario e crar uma consulta para listar os funcionarios com uma determinada quantidade de dependentes por @NamedQuery
    public List<Funcionario> findByDependentes(int dependentes){
        return funcionarioRepository.findByDependentes(dependentes);
    }

    //10 - Alterar a classe funcionarioo e criar uma consulta para listar os funcionarios que contenham em qualquer parte do seu nome um determinado nome por @NamedNativeQuery
    public List<Funcionario> findByNomeContaining(String nome){
        return funcionarioRepository.findByNomeContaining(nome);
    }
}
