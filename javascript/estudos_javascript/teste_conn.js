var mysql=require("mysql");

//criar  a conexao com MySQL
var connection=mysql.createConnection({
    host: "localhost",
    user: "usrPaulo",
    password: "paulo123",
    database: "carro"
});
connection.connect();

let sql="select id,nome,tipo from carro";
connection.query(sql, function(error, results, fields){
	//A funcao de callback possui 3 parametros:
	//error: erro caso a consulta SQl seja invalida, por exemplo um erro de sintaxe.
	//results: contem os registros retornados pela consulta, neste caso sera a lista de carros.
	//fields: contem informacoes sobre as colunas retornadas, neste exemplo as colunas id, nome e tipo.
	if(error){
		throw error;
	};
	let carros=results;
	for(let i=0; carros.length>i; i++){
		console.log(carros[i].id + ": " + carros[i].nome);
	}
});
//fecha a conexao
connection.end();