package com.utfpr.backendempresa.service;

import com.utfpr.backendempresa.entity.Departamento;
import com.utfpr.backendempresa.repository.DepartamentoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DepartamentoService {
    @Autowired
    private DepartamentoRepository departamentoRepository;

    //3 - Listar o primeiro departamento cadastrado
    public Departamento findFirstByOrderByIdAsc(){
        return departamentoRepository.findFirstByOrderByIdAsc();
    }
}
