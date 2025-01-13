CREATE TABLE detalhes_de_vendas(
    codigo_do_relatorio INTEGER,
    codigo_do_produto INTEGER,
    quantidade INTEGER,
    FOREIGN KEY(codigo_do_produto) REFERENCES produtos(codigo_do_produto)
);