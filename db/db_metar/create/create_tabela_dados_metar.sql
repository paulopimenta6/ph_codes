CREATE TABLE dados_metar (
    codigo_da_estacao INTEGER PRIMARY KEY,
    data_hora TEXT,
    temperatura REAL,
    ponto_de_orvalho REAL,
    umidade REAL,
    pressao_atmosferica REAL,
    direcao_do_vento REAL,
    velocidade_do_vento REAL,
    rajada_maxima REAL,
    visibilidade REAL,
    nebulosidade REAL,
    altura_da_base_das_nuvens REAL,
    temperatura_do_ponto_de_orvalho REAL,
    pressao_atmosferica_sea_level REAL,
    pressao_atmosferica_sea_level_maxima REAL,
    pressao_atmosferica_sea_level_minima REAL,
    FOREIGN KEY (codigo_da_estacao) REFERENCES dados_de_estacao(codigo_da_estacao)
);