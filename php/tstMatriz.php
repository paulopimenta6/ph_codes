<?php

$dados['Infos']['Info'] = array();

var_dump($dados);

$dados['Infos']['Info'][0] = 1;

var_dump($dados);

$dados['Infos']['Info']["nome"] = array();

var_dump($dados);

if (isset($dados)) {
    echo "Esta Setado";
}


?>