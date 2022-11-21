const mysql=require("mysql");

let connection=mysql.createConnection({
	host:"localhost",
	user:"usrPaulo",
	password:"paulo123",
	database:"livro"
});
//Conecta no banco de dados
connection.connect();
return connection;
