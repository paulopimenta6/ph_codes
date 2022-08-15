let net=require('net');
let sockets=[];
let port=8000;
let guestId=0;

let server = net.createServer(function(socket){
    //incremento
    guestId++;
    socket.nickname="Guest" + guestId;
    let clienteName=socket.nickname;
    sockets.push(socket);

    //logando de fora do servidor
    console.log(clienteName + " joined this chat.");
    socket.write("Welcome to telnet chat " + socket.nickname + "! \n");
    broadcast(clienteName, clienteName + " joined this chat. \n");    
    
    //quando cliente envia dados
    socket.on('data', function(data){
        let message=clienteName + '> ' + data.toString();
        broadcast(clienteName, message);
        process.stdout.write(message);
    });
    
    //quando cliente sai
    socket.on('end', function(){
        let message=clienteName + " left this chat \n";
        process.stdout.write(message);
        removeSocket(socket);
        broadcast(clienteName, message);
    });

    //quando da erro no socket
    socket.on('error', function(error){
        console.log("Socket got problems: ", error.message);
    });

});

//broadcast para os outros excluindo quem envia
function broadcast(from, message){
    //se nao tem socket, entao nao faz broadcast
    if (sockets.length===0){
        process.stdout.write("Everyone left the chat");
        return;
    }
    //se ha cliente remanescente entao ha boradcast de mensagem    
    sockets.forEach(function(socket, index, array){
        if (socket.nickname===from){
            return;
        }
        socket.write(message);
    });
};

//remove cliente disconectado
function removeSocket(socket){
    sockets.splice(sockets.indexOf(socket), 1);
}

//escutando qualquer problema ocorrido no servidor
server.on("error", function(error){
    console.log("So we got problems: ", error.message);
});

//escutando a porta pelo telnet
//no terminal execute telnet localhost [port]
server.listen(port, function(){
    console.log("Server listening at localhost: " + port);
});