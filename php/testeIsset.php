<?php

$a = array ('test' => 1, 'hello' => NULL);

var_dump( isset ($a['test']) ) . PHP_EOL;            // TRUE
var_dump( isset ($a['foo']) ) . PHP_EOL;             // FALSE
var_dump( isset ($a['hello']) ) . PHP_EOL;           // FALSE

// A chave 'hello' é igual a NULL sendo considerada como inexistente
// Se quiser verificar o valor NULL da chave tente:
var_dump( array_key_exists('hello', $a) ); // TRUE

?>