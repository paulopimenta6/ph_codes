package com.utfpr.backendempresa;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class BackendEmpresaApplication {

	public static void main(String[] args) {
		SpringApplication.run(BackendEmpresaApplication.class, args);
		System.out.print("Departamento e funcionarios");
	}
}
