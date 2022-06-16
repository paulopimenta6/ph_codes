var mysql=require("mysql");

//criar  a conexao com MySQL
var connection=mysql.createConnection({
    host: "localhost",
    user: "usrPaulo",
    password: "paulo123",
    database: "carro"
});
connection.connect();

let sql = "select id,nome,tipo from carro where id = ?";
let id=11;
connection.query(sql, id, function(error, results, fields){
	if(error){
		throw error;
	}
	if(results.length==0){
		console.log("nenhum carro encontrado");
		return
	}
	//O carro esta na 1a posicao do array
	let carro = results[0];
	console.log(carro.id + ": " + carro.nome);
});

//Fecha a conexao
connection.end();