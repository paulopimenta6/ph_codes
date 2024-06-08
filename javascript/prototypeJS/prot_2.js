let object = {};
let prototype = Object.getPrototypeOf(object);

console.log(prototype);
console.log(prototype === Object.prototype);
console.log(Object.prototype.isPrototypeOf(object));