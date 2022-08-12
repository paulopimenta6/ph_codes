function criaUser(nome, email) {
    return {
      nome,
      email,
      exibeInfos() {
        return `${nome}, ${email}`
      }
    }
   }

const novoUser = criaUser("Paulo", "paulo.pimenta@alumni.usp.br");
console.log(novoUser.nome);
console.log(novoUser.email);
console.log(novoUser.exibeInfos());
console.log(novoUser);