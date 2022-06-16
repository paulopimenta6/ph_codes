function testeArray(){
	var numeros=[1,2,3];
	numeros.push(4);
	numeros.push(5);
	//for (let i=0; numeros.length>i; i++){
	//	console.log(numeros[i]);
	//}
	numeros.map(n=>{
		console.log(n);
	});
}
testeArray();	