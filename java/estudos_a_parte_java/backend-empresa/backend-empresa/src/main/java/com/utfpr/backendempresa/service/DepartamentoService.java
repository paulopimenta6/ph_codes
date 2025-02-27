package com.utfpr.backendempresa.service;

import com.utfpr.backendempresa.repository.DepartamentoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DepartamentoService {
    @Autowired
    private DepartamentoRepository repository;
}
