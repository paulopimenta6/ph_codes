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
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
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
/* Usando delete */
INSERT INTO cliente VALUES(NULL,'XXX','M',NULL,'XXX');
SELECT * FROM cliente
WHERE IDCLIENTE = 8;

DELETE FROM CLIENTE WHERE idcliente = 8;
-- verificando os dados inseridos
select * from telefone;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Exercicio DML
use comercio;
select * from cliente;
-- Inserindo novos clientes
INSERT INTO cliente VALUES(NULL,'FLAVIO','M','FLAVIO@IG.COM','4657765');
INSERT INTO cliente VALUES(NULL,'ANDRE','M','ANDRE@GLOBO.COM','7687567');
INSERT INTO cliente VALUES(NULL,'GIOVANA','F',NULL,'0876655');
INSERT INTO cliente VALUES(NULL,'KARLA','M','KARLA@GMAIL.COM','545676778');
INSERT INTO cliente VALUES(NULL,'DANIELE','M','DANIELE@GMAIL.COM','43536789');
INSERT INTO cliente VALUES(NULL,'LORENA','M',NULL,'774557887');
INSERT INTO cliente VALUES(NULL,'EDUARDO','M',NULL,'54376457');
INSERT INTO cliente VALUES(NULL,'ANTONIO','F','ANTONIO@IG.COM','12436767');
INSERT INTO cliente VALUES(NULL,'ANTONIO','M','ANTONIO@UOL.COM','3423565');
INSERT INTO cliente VALUES(NULL,'ELAINE','M','ELAINE@GLOBO.COM','32567763');
INSERT INTO cliente VALUES(NULL,'CARMEM','M','CARMEM@IG.COM','787832213');
INSERT INTO cliente VALUES(NULL,'ADRIANA','F','ADRIANA@GMAIL.COM','88556942');
INSERT INTO cliente VALUES(NULL,'JOICE','F','JOICE@GMAIL.COM','55412256');
-- Inserindo os enderecos dos clientes
INSERT INTO endereco VALUES(NULL,'RUA GUEDES','CASCADURA','B. HORIZONTE','MG',9);
INSERT INTO endereco VALUES(NULL,'RUA MAIA LACERDA','ESTACIO','RIO DE JANEIRO','RJ',10);
INSERT INTO endereco VALUES(NULL,'RUA VISCONDESSA','CENTRO','RIO DE JANEIRO','RJ',11);
INSERT INTO endereco VALUES(NULL,'RUA NELSON MANDELA','COPACABANA','RIO DE JANEIRO','RJ',12);
INSERT INTO endereco VALUES(NULL,'RUA ARAUJO LIMA','CENTRO','VITORIA','ES',13);
INSERT INTO endereco VALUES(NULL,'RUA CASTRO ALVES','LEBLON','RIO DE JANEIRO','RJ',14);
INSERT INTO endereco VALUES(NULL,'AV CAPITAO ANTUNES','CENTRO','CURITIBA','PR',15);
INSERT INTO endereco VALUES(NULL,'AV CARLOS BARROSO','JARDINS','SAO PAULO','SP',16);
INSERT INTO endereco VALUES(NULL,'ALAMEDA SAMPAIO','BOM RETIRO','CURITIBA','PR',17);
INSERT INTO endereco VALUES(NULL,'RUA DA LAPA','LAPA','SAO PAULO','SP',18);
INSERT INTO endereco VALUES(NULL,'RUA GERONIMO','CENTRO','RIO DE JANEIRO','RJ',19);
INSERT INTO endereco VALUES(NULL,'RUA GOMES FREIRE','CENTRO','RIO DE JANEIRO','RJ',20);
INSERT INTO endereco VALUES(NULL,'RUA GOMES FREIRE','CENTRO','RIO DE JANEIRO','RJ',21);
-- Inserindo telefone para os clientes 
INSERT INTO telefone VALUES(NULL,'RES','68976565',9);
INSERT INTO telefone VALUES(NULL,'CEL','99656675',9);
INSERT INTO telefone VALUES(NULL,'CEL','33567765',11);
INSERT INTO telefone VALUES(NULL,'CEL','88668786',11);
INSERT INTO telefone VALUES(NULL,'COM','55689654',11);
INSERT INTO telefone VALUES(NULL,'COM','88687979',12);
INSERT INTO telefone VALUES(NULL,'COM','88965676',13);
INSERT INTO telefone VALUES(NULL,'CEL','89966809',15);
INSERT INTO telefone VALUES(NULL,'COM','88679978',16);
INSERT INTO telefone VALUES(NULL,'CEL','99655768',17);
INSERT INTO telefone VALUES(NULL,'RES','89955665',18);
INSERT INTO telefone VALUES(NULL,'RES','77455786',19);
INSERT INTO telefone VALUES(NULL,'RES','89766554',19);
INSERT INTO telefone VALUES(NULL,'RES','77755785',20);
INSERT INTO telefone VALUES(NULL,'COM','44522578',20);
INSERT INTO telefone VALUES(NULL,'CEL','44522578',21);
-- Exercicio
-- Relatorio geral de todos os clientes
use comercio;
desc cliente;
desc endereco;
desc telefone;
-- Relatorio de homens
select c.idcliente, c.nome, c.email, c.cpf,
       e.rua, e.bairro, e.cidade, e.estado,
       t.tipo, t.numero
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente;
/*
+-----------+---------+-------------------+-------------+--------------------+------------+----------------+--------+------+----------+
| idcliente | nome    | email             | cpf         | rua                | bairro     | cidade         | estado | tipo | numero   |
+-----------+---------+-------------------+-------------+--------------------+------------+----------------+--------+------+----------+
|         1 | Joao    | joaoa@ig.com      | 76567587887 | Rua Capitao Hermes | Centro     | Rio de Janeiro | RJ     | cel  | 87866896 |
|         1 | Joao    | joaoa@ig.com      | 76567587887 | Rua Capitao Hermes | Centro     | Rio de Janeiro | RJ     | res  | 99667587 |
|         1 | Joao    | joaoa@ig.com      | 76567587887 | Rua Capitao Hermes | Centro     | Rio de Janeiro | RJ     | com  | 66687899 |
|         3 | Ana     | ana@ig.com        | 456545678   | Rua Pres. Vargas   | Jardins    | Sao Paulo      | SP     | cel  | 78989765 |
|         3 | Ana     | ana@ig.com        | 456545678   | Rua Pres. Vargas   | Jardins    | Sao Paulo      | SP     | cel  | 99766676 |
|         2 | Carlos  | carlosa@ig.com    | 5464553466  | Rua da Alfandega   | Estacio    | Rio de Janeiro | RJ     | com  | 54768899 |
|         2 | Carlos  | carlosa@ig.com    | 5464553466  | Rua da Alfandega   | Estacio    | Rio de Janeiro | RJ     | cel  | 88687909 |
|         5 | Jorge   | jorge@ig.com      | 8756547688  | Rua da Uruguaiana  | Centro     | Vitoria        | ES     | cel  | 78458743 |
|         5 | Jorge   | jorge@ig.com      | 8756547688  | Rua da Uruguaiana  | Centro     | Vitoria        | ES     | res  | 56576876 |
|         5 | Jorge   | jorge@ig.com      | 8756547688  | Rua da Uruguaiana  | Centro     | Vitoria        | ES     | res  | 89986668 |
|         9 | FLAVIO  | FLAVIO@IG.COM     | 4657765     | RUA GUEDES         | CASCADURA  | B. HORIZONTE   | MG     | res  | 68976565 |
|         9 | FLAVIO  | FLAVIO@IG.COM     | 4657765     | RUA GUEDES         | CASCADURA  | B. HORIZONTE   | MG     | cel  | 99656675 |
|        11 | GIOVANA | NULL              | 0876655     | RUA VISCONDESSA    | CENTRO     | RIO DE JANEIRO | RJ     | cel  | 33567765 |
|        11 | GIOVANA | NULL              | 0876655     | RUA VISCONDESSA    | CENTRO     | RIO DE JANEIRO | RJ     | cel  | 88668786 |
|        11 | GIOVANA | NULL              | 0876655     | RUA VISCONDESSA    | CENTRO     | RIO DE JANEIRO | RJ     | com  | 55689654 |
|        12 | KARLA   | KARLA@GMAIL.COM   | 545676778   | RUA NELSON MANDELA | COPACABANA | RIO DE JANEIRO | RJ     | com  | 88687979 |
|        13 | DANIELE | DANIELE@GMAIL.COM | 43536789    | RUA ARAUJO LIMA    | CENTRO     | VITORIA        | ES     | com  | 88965676 |
|        15 | EDUARDO | NULL              | 54376457    | AV CAPITAO ANTUNES | CENTRO     | CURITIBA       | PR     | cel  | 89966809 |
|        16 | ANTONIO | ANTONIO@IG.COM    | 12436767    | AV CARLOS BARROSO  | JARDINS    | SAO PAULO      | SP     | com  | 88679978 |
|        17 | ANTONIO | ANTONIO@UOL.COM   | 3423565     | ALAMEDA SAMPAIO    | BOM RETIRO | CURITIBA       | PR     | cel  | 99655768 |
|        18 | ELAINE  | ELAINE@GLOBO.COM  | 32567763    | RUA DA LAPA        | LAPA       | SAO PAULO      | SP     | res  | 89955665 |
|        19 | CARMEM  | CARMEM@IG.COM     | 787832213   | RUA GERONIMO       | CENTRO     | RIO DE JANEIRO | RJ     | res  | 77455786 |
|        19 | CARMEM  | CARMEM@IG.COM     | 787832213   | RUA GERONIMO       | CENTRO     | RIO DE JANEIRO | RJ     | res  | 89766554 |
|        20 | ADRIANA | ADRIANA@GMAIL.COM | 88556942    | RUA GOMES FREIRE   | CENTRO     | RIO DE JANEIRO | RJ     | res  | 77755785 |
|        20 | ADRIANA | ADRIANA@GMAIL.COM | 88556942    | RUA GOMES FREIRE   | CENTRO     | RIO DE JANEIRO | RJ     | com  | 44522578 |
|        21 | JOICE   | JOICE@GMAIL.COM   | 55412256    | RUA GOMES FREIRE   | CENTRO     | RIO DE JANEIRO | RJ     | cel  | 44522578 |
+-----------+---------+-------------------+-------------+--------------------+------------+----------------+--------+------+----------+
*/
/* Relatorio dos homens usando filtro de sexo = 'M' */
select c.idcliente, c.nome, c.sexo, c.email, c.cpf,
       e.rua, e.bairro, e.cidade, e.estado,
       t.tipo, t.numero
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where sexo = 'M';
/* Os indices 12, 13, 18 e 19 precisam ser modificados */
select * from cliente
where idcliente = 12
or idcliente = 13
or idcliente = 18
or idcliente = 19;
/* usando a clausula IN */
select * from cliente
where idcliente in (12,13,18,19);
/* Realizando atualizacao da base de dados */
update cliente set sexo = 'F'
where idcliente in (12,13,18,19);
/* relatorio completo com o ajuste de sexo */ 
select c.idcliente, c.nome, c.sexo, c.email, c.cpf,
       e.rua, e.bairro, e.cidade, e.estado,
       t.tipo, t.numero
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where sexo = 'M';
/*
+-----------+---------+------+-----------------+-------------+--------------------+------------+----------------+--------+------+----------+
| idcliente | nome    | sexo | email           | cpf         | rua                | bairro     | cidade         | estado | tipo | numero   |
+-----------+---------+------+-----------------+-------------+--------------------+------------+----------------+--------+------+----------+
|         1 | Joao    | M    | joaoa@ig.com    | 76567587887 | Rua Capitao Hermes | Centro     | Rio de Janeiro | RJ     | cel  | 87866896 |
|         1 | Joao    | M    | joaoa@ig.com    | 76567587887 | Rua Capitao Hermes | Centro     | Rio de Janeiro | RJ     | res  | 99667587 |
|         1 | Joao    | M    | joaoa@ig.com    | 76567587887 | Rua Capitao Hermes | Centro     | Rio de Janeiro | RJ     | com  | 66687899 |
|         2 | Carlos  | M    | carlosa@ig.com  | 5464553466  | Rua da Alfandega   | Estacio    | Rio de Janeiro | RJ     | com  | 54768899 |
|         2 | Carlos  | M    | carlosa@ig.com  | 5464553466  | Rua da Alfandega   | Estacio    | Rio de Janeiro | RJ     | cel  | 88687909 |
|         5 | Jorge   | M    | jorge@ig.com    | 8756547688  | Rua da Uruguaiana  | Centro     | Vitoria        | ES     | cel  | 78458743 |
|         5 | Jorge   | M    | jorge@ig.com    | 8756547688  | Rua da Uruguaiana  | Centro     | Vitoria        | ES     | res  | 56576876 |
|         5 | Jorge   | M    | jorge@ig.com    | 8756547688  | Rua da Uruguaiana  | Centro     | Vitoria        | ES     | res  | 89986668 |
|         9 | FLAVIO  | M    | FLAVIO@IG.COM   | 4657765     | RUA GUEDES         | CASCADURA  | B. HORIZONTE   | MG     | res  | 68976565 |
|         9 | FLAVIO  | M    | FLAVIO@IG.COM   | 4657765     | RUA GUEDES         | CASCADURA  | B. HORIZONTE   | MG     | cel  | 99656675 |
|        15 | EDUARDO | M    | NULL            | 54376457    | AV CAPITAO ANTUNES | CENTRO     | CURITIBA       | PR     | cel  | 89966809 |
|        17 | ANTONIO | M    | ANTONIO@UOL.COM | 3423565     | ALAMEDA SAMPAIO    | BOM RETIRO | CURITIBA       | PR     | cel  | 99655768 |
+-----------+---------+------+-----------------+-------------+--------------------+------------+----------------+--------+------+----------+
*/   
-- relatorio de mulheres
select c.idcliente, c.nome, c.sexo, c.email, c.cpf,
       e.rua, e.bairro, e.cidade, e.estado,
       t.tipo, t.numero
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where sexo = 'F';
/* Atualizar o elemento de indice 16 */
update cliente set sexo = 'M'
where idcliente = 16;
/* Relatorio completo com o ajuste no campo sexo */
select c.idcliente, c.nome, c.sexo, c.email, c.cpf,
       e.rua, e.bairro, e.cidade, e.estado,
       t.tipo, t.numero
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where sexo = 'F';
-- Quantidade de homens e mulheres
select count(*), sexo
from cliente
group by sexo;
-- ids e email das mulheres que morem no centro do Rio de Janeiro e Não tenham celular
select c.idcliente, c.email, c.nome, c.sexo
from cliente c 
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente;

select c.idcliente, c.email, c.nome, c.sexo
from cliente c 
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where sexo = 'F';

select c.idcliente, c.email, c.nome, c.sexo
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where c.sexo = 'F'
and e.bairro = 'Centro' and e.cidade = 'Rio de Janeiro';

select c.idcliente, c.email, c.nome, c.sexo, t.tipo, e.bairro, e.cidade
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where c.sexo = 'F'
and e.bairro = 'Centro' and e.cidade = 'Rio de Janeiro';

select c.idcliente, c.email, c.nome, c.sexo, t.tipo, e.bairro, e.cidade
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where c.sexo = 'F'
and e.bairro = 'Centro' and e.cidade = 'Rio de Janeiro'
and (t.tipo = 'res' or t.tipo = 'com');


/* PARA UMA CAMPANHA DE MARKETING, O SETOR SOLICITOU UM
RELATÓRIO COM O NOME, EMAIL E TELEFONE CELULAR 
DOS CLIENTES QUE MORAM NO ESTADO DO RIO DE JANEIRO 
VOCÊ TERÁ QUE PASSAR A QUERY PARA GERAR O RELATORIO PARA
O PROGRAMADOR */
select c.nome, c.email, t.numero as celular
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where t.tipo = 'cel' and e.estado = 'RJ';

/* PARA UMA CAMPANHA DE PRODUTOS DE BELEZA, O COMERCIAL SOLICITOU UM
RELATÓRIO COM O NOME, EMAIL E TELEFONE CELULAR 
DAS MULHERES QUE MORAM NO ESTADO DE SÃO PAULO 
VOCÊ TERÁ QUE PASSAR A QUERY PARA GERAR O RELATORIO PARA
O PROGRAMADOR */
select c.nome, c.email, t.numero as celular -- , t.tipo 
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente
where t.tipo = 'cel' and e.estado = 'SP' and sexo = 'F';