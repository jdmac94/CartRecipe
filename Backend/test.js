var fs = require('fs');
const { Categoria } = require("./models/categoria");
require("./database");

var input = fs.createReadStream('database_prototype.txt');

var rl  = require('readline').createInterface({
    input: input,
    terminal: false
});

rl.on('line', async function(line){
    var line = line;//.toLowerCase();
    var x = line.split(",");
    // let cat = new Categoria();
    // cat.es = x[0];
    // cat.en = x[1];

    // const result = await cat.save();
    
    console.log(x[0] + " |||| " + x[1]);

});