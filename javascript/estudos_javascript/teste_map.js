var numeros = [1,2,3];
var numeros2 = numeros.map(n=>n**2);
var numeros3 = numeros2.filter(n => n > 1 && n < 9);
var s = numeros.reduce((valorAcumulado, n) => valorAcumulado + n*2,1);
console.log(numeros2);
console.log(numeros3);
console.log(s);