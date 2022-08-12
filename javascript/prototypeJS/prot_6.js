function Person(name){
    this.name = name;
}
Person.prototype = {
    constructor: Person,
    sayName: function(){
        console.log(this.name)
    },
    toString: function(){
        return "[Person " + this.name + "]";
    }
};

let person1 = new Person("Paulo");
let person2 = new Person("Nicolle");

person1.sayName();
person2.sayName();

console.log(person1.toString());
console.log(person2.toString());

Person.prototype.sayHi = function(){
    console.log("Hi " + this.name);
};

person1.sayHi();
person2.sayHi();