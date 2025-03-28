package com.utfpr.backendempresa.repository;

import com.utfpr.backendempresa.entity.Departamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DepartamentoRepository extends JpaRepository<Departamento, Long>{
    // 3 - Listar o primeiro departamento cadastrado
    Departamento findFirstByOrderByIdAsc();
}

