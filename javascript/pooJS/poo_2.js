const user = {
    nome : "Paulo",
    email : "paulopimenta315@gmail.com"
}
function exibeInfos(){
    console.log(this.nome);
}

let exibeNome = exibeInfos.bind(user);
exibeNome();  