var mysql=require("mysql");

//criar  a conexao com MySQL
var connection=mysql.createConnection({
    host:"localhost",
    user:"usrPaulo",
    password:"paulo123",
    database:"carro"
});
connection.connect();

//SQL para atualizar o carro
let sql="update carro set ? where id = ?"
//Objeto carro em JSON
var json = {id:31, nome:"Meu Carro Updateeeeeeeee", tipo:"esportivos"};
let id=json.id;

connection.query(sql, [json, id], function(error, results, fields){
	if(error){
		throw error;
	}
	else{
		console.log("Carro atualizado com sucesso.");
		console.log("Quantidade de registros atualizados: " + results.affectedRows);
	}
});

//Fecha a conexão
connection.end();