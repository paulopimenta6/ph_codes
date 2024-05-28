const moment = require('moment-timezone');
var data_hoje = moment().format('MMMM Do YYYY, h:mm:ss a');
var data_atm = moment.tz('America/Bahia').format('DD/MM/YYYY HH:mm:ss');
console.log(data_hoje);
console.log(data_atm);