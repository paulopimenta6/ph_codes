
INSERT INTO departamento (codigo, nome) VALUES (1, 'Recursos Humanos');
INSERT INTO departamento (codigo, nome) VALUES (2, 'TI');
INSERT INTO departamento (codigo, nome) VALUES (3, 'Financeiro');

INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Joao Silva', 2, 6500.00, 'Analista de teste', 2);
INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Maria Oliveira', 0, 7500.00, 'Desenvolvedora', 2);
INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Paulo Henrique', 0, 8500.00, 'Desenvolvedor', 2);
INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Andre Luiz', 0, 7200.00, 'Gerente', 2);

INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Carlos Santos', 1, 6030.00, 'Contador', 3);
INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Jose Henrique', 1, 6030.00, 'administrador', 3);
INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Francisco Heinze', 1, 7025.00, 'Gerente', 3);

INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Ana Souza', 1, 4700.00, 'Analista de Marketing', 1);
INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Pedro Oliveira', 3, 5200.00, 'Analista de Vendas', 1);
INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Mariana Costa', 0, 4500.00, 'Engenheira de Producao', 1);
INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Luiz Santos', 2, 4800.00, 'Analista de Vendas', 1);
INSERT INTO funcionario (nome, dependentes, salario, cargo, codigo_dep) VALUES ('Carla Pereira', 0, 6000.00, 'Gerente', 1);
