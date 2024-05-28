function soma(a, b){
    return a + b;
}

function multiplicador(a, b){
	return a * b;
}

function executar(funcao, a, b){
    return funcao(a, b);
}

//A funcao sera executada
let resultado = executar(soma, 1, 2);
console.log(resultado);