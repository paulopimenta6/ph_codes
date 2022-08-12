function Person(name) {
    this.name = name;
}

Person.prototype.sayName = function() {
    console.log(this.name);
}

let person1 = new Person("Paulo");
let person2 = new Person("Nicolle");

console.log(person1.name);
console.log(person2.name);

person1.sayName();
person2.sayName();

console.log(" ");

person1.name = "Henrique";
person2.name = "Danielle";
console.log(person1.name);
console.log(person2.name);
person1.sayName();
person2.sayName();