function Person(name){
    this.name = name;
}

Person.prototype.sayName = function(){
    console.log(this.name);
};
Person.prototype.favorites = [];

let person1 = new Person("Paulo");
let person2 = new Person("Nicolle");
person1.favorites.push("Pizza");
person2.favorites.push("Hamburguer");

person1.sayName();
person2.sayName();

console.log(person1.favorites);
console.log(person2.favorites);