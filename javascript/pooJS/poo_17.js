class User {
    _nome = '';
   
    setNome(nome) {
      this._nome = nome;
    }
   
    getNome() {
      return this._nome;
    }
   }

   const novoUser = new User();
   novoUser.setNome("Paulo");
   console.log(novoUser.getNome());