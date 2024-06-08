<?php

//MENOR QUE 18,5	MAGREZA	0
//ENTRE 18,5 E 24,9	NORMAL	0
//ENTRE 25,0 E 29,9	SOBREPESO	I
//ENTRE 30,0 E 39,9	OBESIDADE	II
//MAIOR QUE 40,0	OBESIDADE GRAVE	III
//imc = peso/altura²

$peso=89.0;
$altura=1.74;
$imc=number_format(($peso/($altura**2)), 2, '.', ' ');

echo "seu imc e: $imc e ";

if ($imc<18.5){
    echo "nivel 0 - magreza";
}
elseif ($imc>=18.5 || $imc<24.9){
    echo "nivel 0 - normal";
}
elseif ($imc>=25.0 || $imc<29.9){
    echo "nivel I - sobrepeso";
}
elseif ($imc>=30.0 || $imc<39.9){
    echo "nivel II - obesidade";
}
elseif ($imc>=40){
    echo "nivel III - obesidade grave";
}
//else{
//    echo "Houve algum erro ao passar os valores de peso e altura";
//}