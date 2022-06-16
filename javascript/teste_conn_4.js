var mysql=require("mysql");

//criar  a conexao com MySQL
var connection=mysql.createConnection({
    host:"localhost",
    user:"usrPaulo",
    password:"paulo123",
    database:"carro"
});
connection.connect();

//SQL para excluir o carro
let sql = "delete from carro where id = ?";
let id=[32, 33, 34, 35]; //criei um vetor de indices que depois serao usados para apagar os carros criados a mais

for(p in id){
		
	connection.query(sql, id[p], function(error, results, fieds){ //usa-se id[p] ao inves de p. p e indice de id
		if(error){
			throw error;
		}
		else{
			console.log("Carro deletado com sucesso.");
			console.log("Quantidade de registros atualizados: " + results.affectedRows)
		}
	});
	
}
//Fecha a conexao
connection.end();
