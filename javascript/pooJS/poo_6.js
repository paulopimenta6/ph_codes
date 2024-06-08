function User(nome, email) {
    this.nome = nome
    this.email = email
   
    this.exibeInfos = function() {    
      return `${nome}, ${email}`
    }
   }