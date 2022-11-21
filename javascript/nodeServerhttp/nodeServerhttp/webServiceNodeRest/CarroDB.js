//Importa o modulo do MySQL
const mysql=require("mysql");

//Classe CarroDB
class CarroDB{
	//Funcao para conectar no banco de dados
	static connect(){
		//Cria a conexao com MySQL
		let connection=mysql.createConnection({
			host:"localhost",
			user:"usrPaulo",
			password:"paulo123",
			database:"carros"
		});
		//Conecta no banco de dados
		connection.connect();
		return connection;
	}
	
	// Retorna a lista de carros
	static getCarros(callback){
		let connection=CarroDB.connect();
		//Cria uma consulta
		let sql="select * from carros";
		let query=connection.query(sql, function(error, results, fields){
			if(error){
				throw error;
			}
			//Retorna os dados pela funcao de callback
			else{
				callback(results);
			}			
		});
		console.log(query.sql)
		//Fecha a conexao
		connection.end();
	}
	
	//Retorna a lista de carros por tipo do banco de dados
	static getCarrosByTipo(tipo, callback){
		let connection=CarroDB.connect();
		//Cria uma consulta 
		let sql="select id,nome,tipo from carros where tipo='" + tipo + "'";
		let query=connection.query(sql, function(error, results, fields){
			if(error){
				throw error;
			}
			else{
				//Retorna os dados pela funcao de callback
				callback(results);
			}		
		});
	console.log(query.sql);
	//Fecha a conexao
	connection.end();
	}
	
	//Retorna a lista de carros
	static getCarroById(id, callback){
		//nicolle!!!!
		let connection=CarroDB.connect();
		//Cria uma consulta
		let sql="select * from carros where id=?";
		let query=connection.query(sql, id, function(error, results, fields){
			if(error){
				throw error;
			}
			if(results.length==0){
				console.log("Nenhum carro encontrado...");
				return
			}
			//Encontrou o carro
			let carro=results[0];
			//Retorna o carro pela funcao de callback
			callback(carro);
		});
	console.log(query.sql);
	//Fecha a conexao
	connection.end();
	}
	
	//Salva um carro no banco de dados
	//Recebe o JSON com dados do carro como parametro
	
	static save(carro, callback){
		let connection=CarroDB.connect();
		//Insere o carro
		let sql="insert into carros set ?";
		let query=connection.query(sql, carro, function(error, results, fields){
			if(error){
				throw error;				
			}			
			else{
				//Atualiza o objeto carro do parametro com o "id" inserido
				carro.id=results.insertId;				
			}
			//Retorna o carro pela funcao de callback
			callback(carro)
		});
		console.log(query.sql);
		//Fecha a conexao
		connection.end();
	}
	
	static update(carro, callback){
		let connection=CarroDB.connect()
		//SQL para atualizar o carro
		let sql="update carros set ? where id=?";
		//Id do carro para atualizar
		let id=carro.id;
		let query=connection.query(sql, [carro, id], function(error, results, fields){
			if(error){
				throw error;
			}
			else{
				callback(carro);
			}
		});
		console.log(query.sql);
		//Fecha a conexao
		connection.end();
	}
	
	//Deleta um carro no banco de dados
	static delete(carro, callback){
		let connection=carroDB.connect();
		//SQL para deletar o carro
		let sql="delete from carros where id=?";
		//Id do carro para deletar
		let id=carro.id;
		let query=connection.query(sql, id, function(error, results, fields){
			if(error){
				throw error;
			}
			else{
				callback(carro);
			}
		});
		console.log(query.sql);
		//Fecha a conexao
		connection.end();
	}
	
	//Deleta um carro pelo id
	static deleteById(id, callback){
		let connection=carroDB.connect();
		//SQL para deletar o carro
		let sql="delete from carros where id=?";
		let query=connection.query(sql, id, function(error, results, fields){
			if(error){
				throw error;
			}
			else{
				callback(results.affectedRows);
			}
		});
		console.log(query.sql);
		//Fecha a conexao
		connection.end();
	};
};
	
module.exports=CarroDB;