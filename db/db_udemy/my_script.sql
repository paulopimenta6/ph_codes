-- criando a base de dados
create database PROJETO;
-- usando a base de dados
use PROJETO;
-- criando a tabela
create table cliente(
    nome varchar(30),
    sexo char(1),
    email varchar(30),
    cpf int(11),
    telefone varchar(30),
    endereco varchar(100)
);
-- mostrando as tabelas
show tables;
-- descrevendo a tabela
desc cliente;
-- inserindo dados em clientes
insert into cliente(nome, sexo, email, cpf, telefone, endereco) 
values('JOAO','M','JOAO@GMAIL.COM',988638273,'22923110','MAIA LACERDA - ESTACIO - RIO DE JANEIRO - RJ'); 
-- fazendo a primeira projecao
select * from cliente;
-- fazendo as demais insercoes
INSERT INTO cliente VALUES('CELIA','F','CELIA@GMAIL.COM',541521456,'25078869','RIACHUELO - CENTRO - RIO DE JANEIRO - RJ');
INSERT INTO cliente VALUES('JORGE','M',NULL,885755896,'58748895','OSCAR CURY - BOM RETIRO - PATOS DE MINAS - MG');
INSERT INTO cliente(NOME,SEXO,ENDERECO,TELEFONE,CPF) 
VALUES('LILIAN','F','SENADOR SOARES - TIJUCA - RIO DE JANEIRO - RJ','947785696',887774856);
INSERT INTO cliente VALUES('ANA','F','ANA@GLOBO.COM',85548962,'548556985','PRES ANTONIO CARLOS - CENTRO - SAO PAULO - SP'),
                          ('CARLA','F','CARLA@TERATI.COM.BR',7745828,'66587458','SAMUEL SILVA - CENTRO - BELO HORIZONTE - MG');			  
INSERT INTO cliente(NOME,SEXO,ENDERECO,TELEFONE,CPF) VALUES('CLARA','F','SENADOR SOARES - TIJUCA - RIO DE JANEIRO - RJ','883665843',999999999);
INSERT INTO cliente(NOME,SEXO,ENDERECO,TELEFONE,CPF) 
VALUES('CLARA','F','SENADOR SOARES - TIJUCA - RIO DE JANEIRO - RJ','883665843',222222222);
