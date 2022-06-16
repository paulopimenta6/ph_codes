var mysql=require("mysql");

//criar  a conexao com MySQL
var connection=mysql.createConnection({
    host:"localhost",
    user:"usrPaulo",
    password:"paulo123",
    database:"carro"
});
connection.connect();

//SQL para inserir o carro
let sql = "insert into carro set ?";
//objeto carro em formato JSON
var carro={nome:"Meu Carro", tipo:"esportivos"};
connection.query(sql, carro, function(error, results, fields){
	if(error){
		throw error;
	}
	else{
		console.log("Carro salvo com sucesso, id: " + results.insertId);
	}
});
//fecha conexao
connection.end();	