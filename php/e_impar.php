<?php


for ($i=0; $i<101; $i++){
    if ($i%2==0){        
        continue;
    }
    echo "#i: $i" . PHP_EOL;     
}

//Abaixo uma solucao nao muito sofisticada pq o continue busca um repetidor com incrementador
//$i++ -> executa e depois incrementa
//++$i -> incrementa e depois executa
//$i=0;
//while (++$i<101){
//    if ($i%2==0){
//        continue;
//    }
//    echo "$i" . PHP_EOL;
//}