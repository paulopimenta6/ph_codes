export default class User {
    #nome
    #sobrenome
    // restante das propriedades
    constructor (nome, sobrenome, email, nascimento, role, ativo = true) {
        this.#nome = nome
        this.#sobrenome = sobrenome
        // restante das propriedades
    }

    set nome(novoNome) {
        if (novoNome === '') {
          throw new Error('formato não válido')
        }
        let [nome, ...sobrenome] = novoNome.split(" ")
        sobrenome = sobrenome.join(' ')
        this.#nome = nome
        this.#sobrenome = sobrenome
      }

      get nome() {
        return this.#nome
      }
     
      get sobrenome() {
        return this.#sobrenome
      }

    get nome() {
        return `${this.#nome} ${this.#sobrenome}`
      }  

}

const novoUser = new User('Juliana', 'Souza', 'j@j.com', '2021-01-01')
console.log(novoUser.nome) //'Juliana'
novoUser.nome = 'Juliana Silva Souza'
console.log(novoUser.nome) //'Juliana'
console.log(novoUser.sobrenome) //'Silva Souza'
console.log(novoUser.nome)