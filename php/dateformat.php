<?php

$dateObj=array();
for($i=1; $i<25; $i++){
	$monthName=DateTime::createFromFormat('m', $i);
	if($i%2==0){		
		$dateObj[$i]=$monthName->format('F');
	}
	else{
		$dateObj[$i]=$monthName->format('m/Y');
	}		
}
var_dump($dateObj);