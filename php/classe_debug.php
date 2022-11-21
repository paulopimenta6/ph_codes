<?php

class Cachorro {
    private $raca;
    private $nome;
 
    public function __construct()
    {
   $this->raca = 'Poodle';
   $this->nome = 'Bob';
    }
 
    public function setRaca($raca)
    {
   $this->raca = $raca;
    }
 
    public function setName($nome)
    {
	die(var_dump($nome));	
   $this->nome = $nome;
    }
 
    public function getInformacoes()
    {
   return "Meu cachorro é da raça {$this->raca} e o nome dele é {$this->nome}";
    }
}
 
$cachorro = new Cachorro(); 
$cachorro->setRaca('Dogue Alemão');
$cachorro->setName('Scooby'); 
echo $cachorro->getInformacoes();