function exibeInfos() {
    console.log(this.nome, this.email)
}
   
const user = {
    nome: 'Mariana',
    email: 'm@m.com'
}
   
exibeInfos.call(user)