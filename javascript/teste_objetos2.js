function objetos2(){
    var pessoa={
	nome: "Ricardo",
	hello: function(){
	    return "Hello Pessoa!";
	}
	}
	console.log(pessoa);
	console.log(pessoa.nome);
	console.log(pessoa.hello());
}
objetos2();