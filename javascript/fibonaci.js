const fibonaci = [];
fibonaci[1] = 1;
fibonaci[2] = 1;

for (let i = 3; i < 100; i++){
	fibonaci[i] = fibonaci[i-1] + fibonaci[i-2];
}

console.log(fibonaci.slice(1,));

//for (let i = 1; i < fibonaci.length; i++){
//	console.log(fibonaci[i]);
//}  