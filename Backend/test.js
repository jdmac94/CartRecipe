var fs = require('fs');

var input = fs.createReadStream('aaa.txt');

var rl  = require('readline').createInterface({
    input: input,
    terminal: false
});

var cats = "Напитки, Газированные напитки, Газированные безалкагольные напитки, en:Colas, Напитки с добавлением сахара"

var str = cats.split(",");
console.log(str[0]);

for (let element of str) {
    element = element.trim();
}
var temp = [];
var catching = false;

rl.on('line', function(line){

    if (line.includes("<")) {
        catching = true;
    }

    
    //revisa el array recogido
    if (catching) {

        if (line == "\n") {
            matches = false;

            for (let element of temp) {
                if (element.includes("varias")) {
                    matches = true;
                }
            }

            if (matches) {
                console.log(temp);
            }
                

        } else  {
            temp.push(line);
        }
    }



});