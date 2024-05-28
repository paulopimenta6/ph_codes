let numeros = [1,2,3];
let s1 = numeros.reduce((ValAcum, n) => ValAcum + n*2);
console.log(s1);
let s2 = numeros.reduce((ValAcum, n) => ValAcum + n*2,0);
console.log(s2);
