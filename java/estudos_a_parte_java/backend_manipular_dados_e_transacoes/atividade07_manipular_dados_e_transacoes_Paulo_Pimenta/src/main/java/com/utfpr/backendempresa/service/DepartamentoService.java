package com.utfpr.backendempresa.service;

import com.utfpr.backendempresa.entity.Departamento;
import com.utfpr.backendempresa.entity.Funcionario;
import com.utfpr.backendempresa.repository.DepartamentoRepository;
import com.utfpr.backendempresa.repository.FuncionarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DepartamentoService {
    @Autowired
    private DepartamentoRepository departamentoRepository;

    @Autowired
    private FuncionarioRepository funcionarioRepository;

    //3 - Listar o primeiro departamento cadastrado
    public Departamento findFirstByOrderByIdAsc(){

        return departamentoRepository.findFirstByOrderByIdAsc();
    }

    // ------------ Atividade de manipulacao de dados e transacoes ------------
    // 05. Criar um método na classe de serviço de departamento para salvar um departamento, associar esse
    // departamento a um funcionário e salvar esse funcionário em um mesmo controle de transação(@Transactional).
    @Transactional
    public void salvarDepartamentoEFuncionario(Departamento departamento, Funcionario funcionario) {
        Departamento savedDepartamento = departamentoRepository.save(departamento);
        funcionario.setDepartamento(savedDepartamento);
        funcionarioRepository.save(funcionario);
    }

}
