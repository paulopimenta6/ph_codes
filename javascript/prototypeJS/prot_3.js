let object = {
    nome: "Paulo",
    exibeInfo: function(){
        console.log(nome);
    } 
};
console.log(object.toString());

object.toString = () => {
    return "[object custom]";
};

console.log(object.toString());

//apaga as propriedades do toString()
delete object.toString;
console.log(object.toString());

//sem efeito para apagar o objeto do objeto
delete object.toString;
console.log(object.toString());