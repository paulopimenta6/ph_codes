--criacao da tabela comex
CREATE TABLE comex(
	cod_dest_expo INTEGER PRIMARY KEY AUTOINCREMENT,
	nome_dest_exp VARCHAR(30) NOT NULL,
	populacao INTEGER,
	distrito VARCHAR(30) NOT NULL
);

--insere os dados na tabela criada acima
INSERT INTO comex (nome_dest_exp, populacao, distrito) VALUES('Reino de Minami', 100, 'Mar do Sul');
INSERT INTO comex (nome_dest_exp, populacao, distrito) VALUES('Reino de Paronu', 200, 'Central');
INSERT INTO comex (nome_dest_exp, populacao, distrito) VALUES('Reino de Tokanta', 160, 'Mar do Norte');
INSERT INTO comex (nome_dest_exp, populacao, distrito) VALUES('Imperio de Alfa', 120, 'Mar do Norte');

--criando uma view
CREATE VIEW regiao_mar_do_norte AS 
       SELECT * 
       FROM comex 
       WHERE distrito = 'Mar do Norte';
       
--usando select na view
select * from regiao_mar_do_norte;

--usando update no banco comex
update comex set populacao=150 where nome_dest_exp = 'Reino de Tokanta';
select * from comex;

--usando delete em comex
delete from comex where nome_dest_exp = 'Reino de Paronu';
select * from comex;

--deletando tudo para comecar de novo
--delete from comex;
--select * from comex;
--drop table comex;
--drop view regiao_mar_do_norte;
