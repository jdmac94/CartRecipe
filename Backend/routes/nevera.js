const express = require("express");
const https = require("https");
const router = express.Router();
const fetch = require('node-fetch');
const { Nevera } = require("../models/nevera");
const { Product } = require("../models/product");
let OFFurl = 'https://world.openfoodfacts.org/api/v0/product/';


router.post("/apiImg", async (req, res) => {

    let url = OFFurl + req.body.barcode + '.json';

    let fotos;
    // fetch(url)
    //     .then(res => res.json())
    //     .then(json => {
    //         var x = json.product.selected_images.front.display;
    //         console.log(x);
    //     });
        //fotos = json.product.selected_images.front);

        fetch(url)
        //.then(res => res.json())
        .then(function(response) {
            return response.json();
        })
        .then(json => {
            var x = json.product.selected_images.front.display;
            console.log(x[0]);
            res.send(x);
        });

    
    res.send(fotos);
});

router.post("/getProdbyAPI", async (req, res) => {

    //let producto = await Product.find( { _id: req.body.barcode } );
    let url = OFFurl + req.body.barcode + '.json';
    let parsedData;
    
    https.get(url, function(res) {
        console.log("Got response: " + res.statusCode);

        res.setEncoding('utf8');
        let rawData = '';
        
        res.on('data', (chunk) => { rawData += chunk; });
        res.on('end', () => {
            try {
            parsedData = JSON.parse(rawData);

            console.log(parsedData.product.selected_images.front);//impresión del fragmento de JSON que incluye las imágenes

            } catch (e) {
            console.error(e.message);
            }
        });

      }).on('error', function(e) {
        console.log("ERROR: " + e.message);
      });
    
    console.log(parsedData);//no incluye los datos del JSON parseado
    //res.json(parsedData.product.selected_images); //definir campos en función de lo que quiera front
    res.send(req.body.barcode);

});


router.post("/getProd", async (req, res) => {

    console.log("GETTING PROD: " + req.body.barcode);

    let bc = req.body.barcode;

    var producto = await Product.findById(bc);

    // const producto = await Product.findById(req.body.barcode);

    if (!producto)
        return res.status(404).send("El producto solicitado no existe");
    
    // if (!producto.selected_images) {
    //     console.log("GETTING IMAGES FROM OFF API FOR PRODUCT: " + req.body.barcode);
    //     //llamada a la función encargada de ello
    //     let url = OFFurl + req.body.barcode + '.json';
    //     let parsedData;
        
    //     //const result = nevera.save();

    //     //return res.send(producto);
    //     return res.send(producto);
    // } //else
        //res.send(producto);
    

    let img = "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.200.jpg";

    producto.imgs = [ img ];

    res.send(producto);    

});

router.get("/getNevera", async (req, res) => {

    console.log("GETTING NEVERA");
    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.findOne();

    //test
    if (!nevera) {
        nevera = new Nevera();
        nevera.usuario = "0";
        nevera.productos = ["0000000018449", "5449000000996"];
        //nevera.usuario = req.body.user;
        //nevera.productos = [];
        const result = nevera.save();
    }
    

    let prodArray = nevera.productos;
    let listedPords = await Product.find( { _id: { $in: prodArray } }, { _keywords:1, allergens_from_user:1, product_name_es:1, nutriscore_data:1, nova_group:1} );

    res.send(listedPords);

});


router.get("/getNeveraList", async (req, res) => {

    console.log("GETTING NEVERA LIST"+ Date.now());
    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.findOne();

    //test
    if (!nevera) {
        nevera = new Nevera();
        nevera.usuario = "0";
        nevera.productos = ["0000000018449", "5449000000996"];
        //nevera.usuario = req.body.user;
        //nevera.productos = [];
        const result = nevera.save();
    }
    

    let prodArray = nevera.productos;
    let listedPords = await Product.find( { _id: { $in: prodArray } }, { product_name:1, allergens_from_user:1, product_name_es:1,} );

    res.send(listedPords);

});

router.get("/getNeveraListIMG", async (req, res) => {

    console.log("GETTING NEVERA LIST");
    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.findOne();

    //test
    if (!nevera) {
        nevera = new Nevera();
        nevera.usuario = "0";
        nevera.productos = ["5449000000996"];
        //nevera.usuario = req.body.user;
        //nevera.productos = [];
        const result = nevera.save();
    }
    

    let prodArray = nevera.productos;
    let listedPords = await Product.find( { _id: { $in: prodArray } }, { product_name:1, allergens_from_user:1, product_name_es:1,} );

    let img = "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.200.jpg";

    listedPords.forEach(function(element) {
        element.imgs = [ img ];
    });

    res.send(listedPords);

});

router.get("/getNeveraArray", async (req, res) => {

    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.findOne();

    //test
    if (!nevera) {
        nevera = new Nevera();
        nevera.usuario = "0";
        nevera.productos = ["0000000018449", "5449000000996"];
        //nevera.usuario = req.body.user;
        //nevera.productos = [];
        const result = nevera.save();    
    }

    res.send(nevera.productos);

});

/*
{
    "toDeleteArr": ["111111111111111"]
}
 */
router.post("/deleteNevera", async (req, res) => {

    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.findOne();

    if (!nevera)
        return res.status(404).send("No se encuentran los datos de la nevera");

    let neveraContent = nevera.productos;
    
    req.body.toDeleteArr.forEach(function(element) {

        delIndex = neveraContent.indexOf(element)
        
        if (delIndex != -1)
            neveraContent.splice(delIndex, 1);

    });
    
    nevera.productos = neveraContent;
    const result = nevera.save();

    if (result) 
        res.send(nevera.productos);

});

router.delete("/clearNevera", async (req, res) => {
    
    let nevera = await Nevera.findOne();

    if (!nevera)
        return res.status(404).send("No se encuentran los datos de la nevera");

    nevera.productos = [];

    const result = nevera.save();

    if (result) 
        res.send(nevera.productos);

});

/*
  
 {
    "barcode": "111111111111111"
 }

 */
router.put("/addNevera", async (req, res) => {

    let nevera = await Nevera.findOne();

    if (!nevera)
        return res.status(404).send("No se encuentran los datos de la nevera");


    let neveraContent = nevera.productos;
    delIndex = neveraContent.indexOf(req.body.barcode)

    if (delIndex == -1) {
        let prodArray = nevera.productos;

        prodArray.push(req.body.barcode);
        nevera.productos = prodArray;
        const result = nevera.save();
        if (result) 
            res.send(nevera.productos);
    } else
        return res.status(400).send("El Producto ya exsite en la nevera");
});


router.get("/restoreNevera", async (req, res) => {

    console.log("GETTING NEVERA LIST");
    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.remove( { } );

    nevera = new Nevera();
    nevera.usuario = "0";
    nevera.productos = ["5449000000996"];
    //nevera.usuario = req.body.user;
    //nevera.productos = [];
    const result = nevera.save();

});

module.exports = router;