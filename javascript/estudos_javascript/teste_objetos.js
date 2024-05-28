function objetos1(){
    var pessoa=Object();
    pessoa.nome="Paulo";
    pessoa.sobrenome="Pimenta";
    pessoa.hello=function(){
        return "Hello Pessoa!";
	}
    console.log(pessoa);
    console.log(pessoa.nome);
    console.log(pessoa.hello());
}
objetos1();  	