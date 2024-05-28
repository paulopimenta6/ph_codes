function Pessoa(){
    this.nome="Paulo";
	this.hello=function(){
        return "Hello Pessoa!";
	}
}

function objetos3(){
    var pessoa = new Pessoa();
    console.log(pessoa);
    console.log(pessoa.nome);
	console.log(pessoa.hello());
}

objetos3();	