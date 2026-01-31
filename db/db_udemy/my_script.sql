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

/*Criando uma nova tabela usando foreign key*/
create database comercio;
use comercio;
-- criando tabelas
-- tabela cliente
create table cliente(
idcliente int primary key auto_increment,
nome varchar(30) not null,
sexo enum("M", "F") not null,
email varchar(50) unique,
cpf varchar(15) unique
);
-- tabela endereco
create table endereco(
idendereco int primary key auto_increment,
rua varchar(30) not null,
bairro varchar(30) not null,
cidade varchar(30) not null,
estado char(2) not null,
id_cliente int unique,

foreign key(id_cliente)
references cliente(idcliente)
);
-- tabela telefone
create table telefone(
idtelefone int primary key auto_increment,
tipo enum("res", "com", "cel") not null,
numero varchar(10) not null,
id_cliente int,

foreign key(id_cliente)
references cliente(idcliente)
);

/* ENDERECO - OBRIGATORIO 
CADASTRO DE SOMENTE UM.

TELEFONE - NAO OBRIGATORIO
CADASTRO DE MAIS DE UM (OPCIONAL) */

/* CHAVE ESTRANGEIRA É A CHAVE PRIMARIA DE UMA TABELA
QUE VAI ATÉ A OUTRA TABELA PARA FAZER REFERENCIA ENTRE
REGISTROS */

-- inserindo dados
insert into cliente(idcliente, nome, sexo, email, cpf) values(NULL, "Joao", "M", "joaoa@ig.com", "76567587887"); 
insert into cliente(idcliente, nome, sexo, email, cpf) values(NULL, "Carlos", "M", "carlosa@ig.com", "5464553466");
insert into cliente(idcliente, nome, sexo, email, cpf) values(NULL, "Ana", "F", "ana@ig.com", "456545678");
insert into cliente(idcliente, nome, sexo, email, cpf) values(NULL, "Clara", "F", NULL, "5687766856");
insert into cliente(idcliente, nome, sexo, email, cpf) values(NULL, "Jorge", "M", "jorge@ig.com", "8756547688");
insert into cliente(idcliente, nome, sexo, email, cpf) values(NULL, "Celia", "M", "jcelia@ig.com", "5767876889"); 

-- verificando os dados inseridos
select * from cliente;
-- select usando count para verificar os grupos diferentes
select count(*) as quantidade, sexo 
from cliente
group by sexo;
-- descrevendo a tabela endereco
desc endereco;
-- inserindo dados na tabela endereco
insert into endereco(idendereco, rua, bairro, cidade, estado, id_cliente) values(NULL, "Rua Antonio Sa", "Centro", "Belo Horizonte", "MG", 4);
insert into endereco(idendereco, rua, bairro, cidade, estado, id_cliente) values(NULL, "Rua Capitao Hermes", "Centro", "Rio de Janeiro", "RJ", 1);
insert into endereco(idendereco, rua, bairro, cidade, estado, id_cliente) values(NULL, "Rua Pres. Vargas", "Jardins", "Sao Paulo", "SP", 3);
insert into endereco(idendereco, rua, bairro, cidade, estado, id_cliente) values(NULL, "Rua da Alfandega", "Estacio", "Rio de Janeiro", "RJ", 2);
insert into endereco(idendereco, rua, bairro, cidade, estado, id_cliente) values(NULL, "Rua do Ouvidor", "Flamengo", "Rio de Janeiro", "RJ", 6);
insert into endereco(idendereco, rua, bairro, cidade, estado, id_cliente) values(NULL, "Rua da Uruguaiana", "Centro", "Vitoria", "ES", 5);
-- aqui nao dara certo, pois o id_cliente na tabela endereco e unique, logo ele associa um id_cliente a um idcliente de cliente
insert into endereco(idendereco, rua, bairro, cidade, estado, id_cliente) values(NULL, "Rua da Alfandega", "Centro", "Sao Paulo", "SP", 5);
-- verificando os dados inseridos
select * from endereco;

-- inserindo os dados na tabela telefone
insert into telefone(idtelefone, tipo, numero, id_cliente) values(NULL, "cel", "78458743", 5);
insert into telefone(idtelefone, tipo, numero, id_cliente) values(NULL, "res", "56576876", 5);
insert into telefone(idtelefone, tipo, numero, id_cliente) values(NULL, "cel", "87866896", 1);
INSERT INTO telefone(idtelefone, tipo, numero, id_cliente) VALUES(NULL, "com", "54768899", 2);
INSERT INTO telefone(idtelefone, tipo, numero, id_cliente) VALUES(NULL, "res", "99667587", 1);
INSERT INTO telefone(idtelefone, tipo, numero, id_cliente) VALUES(NULL, "cel", "78989765", 3);
INSERT INTO telefone(idtelefone, tipo, numero, id_cliente) VALUES(NULL, "cel", "99766676", 3);
INSERT INTO telefone(idtelefone, tipo, numero, id_cliente) VALUES(NULL, "com", "66687899", 1);
INSERT INTO telefone(idtelefone, tipo, numero, id_cliente) VALUES(NULL, "res", "89986668", 5);
INSERT INTO telefone(idtelefone, tipo, numero, id_cliente) VALUES(NULL, "cel", "88687909", 2);


