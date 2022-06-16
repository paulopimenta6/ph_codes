const express = require("express"); //para evitar ter subscricao da variavel 
const app = express(); //sera usado const ao inves de var

app.get("/", function(req, res){
	res.send("Seja bem-vindo ao meu app");
});

app.get("/sobre", function(req, res){
	res.send("Sobre");
});

app.get("/blog", function(req, res){
	res.send("Blog da pagina");
});

app.get("/:nome/:cargo/:cor", function(req, res){
	res.send("<h3>Ola Sr(a) " + req.params.nome + "</h3>" + "<h3>Seu cargo: " + req.params.cargo + "</h3>" +  "<h3>Sua cor favorita: " + req.params.cor + "</h3>");
});

app.listen(8081, function(){
	console.log("Servidor Rodando na url http://localhost:8081");
});