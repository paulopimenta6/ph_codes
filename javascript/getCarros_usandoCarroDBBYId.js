//Importa a classe CarroDB
const CarroDB=require("./CarroDB");
var callback=function(carro){
	//Imprime os dados de carro
	console.log(carro.id + ": " + carro.nome);
}
CarroDB.getCarroById(11, callback);