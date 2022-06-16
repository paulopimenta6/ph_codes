class Pessoa{
	constructor(){
		this.nome="Paulo";
	}
	static hello(){
		return "Hello Pessoa!";
	}
}

function objetos4(){
	var pessoa=new Pessoa();
	console.log(pessoa);
	console.log(pessoa.nome);
	console.log(Pessoa.hello()); //usando um metodo de classe sem precisar ser instanciado
}

objetos4();