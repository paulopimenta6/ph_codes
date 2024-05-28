function executar(funcao, a, b){
    return funcao(a, b);
}

let resultado = executar(function(a,b){return a+b}, 1, 2);
console.log(resultado);

