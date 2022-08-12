function exibeInfos() {
    console.log(this.nome, this.email)
   }
   
   const user = {
    nome: 'Mariana',
    email: 'm@m.com'
   }
   
   exibeInfos.call(user)

console.log("===========================================================");

function User(nome, email) {
    this.nome = nome
    this.email = email
   
    this.exibeInfos = function(){
      console.log(this.nome, this.email)
    }
}

const newUser = new User('mariana', 'm@m.com');
const outroUser = {
    nome: 'Rodrigo',
    email: 'r@r.com'
}

console.log(newUser.nome);
console.log(newUser.email);
newUser.exibeInfos();

exibeInfos.call(outroUser); //ou
newUser.exibeInfos.call(outroUser);