let net = require('net');
let count = 1;

let server = net.createServer(function(socket){
    console.log("Cliente se conectou do IP: " + socket.remoteAddress);
    socket.end("Ola usuario " + socket.remoteAddress + " numero: " + (count++) + " seja bem-vindo!" );
});

server.listen(3001, "localhost");
console.log("Servidor TCP iniciado...");