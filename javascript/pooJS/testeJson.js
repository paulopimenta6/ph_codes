let testeJson = '[{"nome": "paulo", "cidade": "Sao Goncalo"}, {"nome": "nicolle", "cidade": "Sao Paulo"}]';
let teste2 = JSON.parse(testeJson);

console.log(teste2);

for (dados in teste2){
    console.log(teste2[dados]);
}

