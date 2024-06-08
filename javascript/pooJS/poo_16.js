class User {
    constructor(nome) {
     this._nome = nome
   }
  
   get nome(){
     return this._nome
   }
  }

let novoUser = new User("Paulo");
console.log(novoUser.nome);

novoUser.nome = 'Andre'
console.log(novoUser.nome) //não é modificado, continua 'Rodrigo'
