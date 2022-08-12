class User {
    _role = '';
   
    set role(tipoRole) {
      if (tipoRole !== 'admin') {
        tipoRole = 'estudante'
      }
      this._role = tipoRole
    }
   
    get role() {
      return this._role
    }
   
    constructor(nome) {
      this._nome = nome;
    }
   }

// criar o usuário
let novoUser = new User('Paulo');

// modificar o role
novoUser.role = 'admin'; // acessando via setter
console.log(novoUser.role) // admin

// tentar incluir um role não existente
novoUser.role = 'gerente';
console.log(novoUser.role) // estudante