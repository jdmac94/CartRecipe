const express = require("express");
const https = require("https");
const router = express.Router();
const fetch = require('node-fetch');
const { Nevera } = require("../models/nevera");
const { Product } = require("../models/product");
let OFFurl = 'https://world.openfoodfacts.org/api/v0/product/';
const barcodeRegEx = /^[0-9]{13}$/;

function getImgByAPI(code) {

    let url = OFFurl + code + '.json';

    var fotos = fetch(url)
    .then(function(response) {
        return response.json();
    });

    return fotos;
}

router.post("/getProd", async (req, res) => {

    console.log("GETTING PROD: " + req.body.barcode);

    var producto = await Product.findById(req.body.barcode);

    if (!producto)
        return res.status(404).send("El producto solicitado no existe");

    var fotos = await getImgByAPI(req.body.barcode);
    var pics = fotos.product.selected_images.front.display;

    producto.imgs = [ pics ];

    res.send(producto);    

});

router.post("/getProdKeyWord", async (req, res) => {

    console.log("GETTING PROD WITH KEYWORD: " + req.body._keywords);

    var productos = await Product.find({ _keywords: req.body._keywords}).exec();

    if (!productos)
        return res.status(404).send("No hay productos con la keyword solicitada");
    for (producto in productos)
        var fotos = await getImgByAPI(producto.barcode);
        var pics = fotos.product.selected_images.front.display;
        producto.imgs = [ pics ];

    res.send(productos);    

});

router.get("/getNevera", async (req, res) => {

    console.log("GETTING NEVERA");
    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.findOne();

    if (!nevera)
        return res.status(404).send("No se encuentran los datos de la nevera");

    let prodArray = nevera.productos;
    let listedProds = await Product.find( { _id: { $in: prodArray } }, { _keywords:1, allergens_from_user:1, product_name_es:1, nutriscore_data:1, nova_group:1} );

    for (let element of listedProds) {

        var fotos = await getImgByAPI(element._id);

        var pics = fotos.product.selected_images.front.display;
        element.imgs = [ pics ];
    }

    res.send(listedProds);

});


router.get("/getNeveraList", async (req, res) => {

    //var date = Date.now();
    //var timeStr = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
    
    console.log("GETTING NEVERA LIST ");
    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.findOne();

    if (!nevera)
        return res.status(404).send("No se encuentran los datos de la nevera");

    let prodArray = nevera.productos;
    let listedProds = await Product.find( { _id: { $in: prodArray } }, { product_name:1, allergens_from_user:1, product_name_es:1,} );

    if (!(typeof listedProds[Symbol.iterator] === 'function' && !(typeof listedProds === 'string')))
        return res.status(400).send("Formato del contenido de la nevera incorrecto");

    for (let element of listedProds) {

        var fotos = await getImgByAPI(element._id);

        var pics = fotos.product.selected_images.front.display;
        element.imgs = [ pics ];
    }

    res.send(listedProds);

});


/*
{
    "toDeleteArr": ["111111111111111"]
}
 */
router.post("/deleteNevera", async (req, res) => {

    deleteArr = req.body.toDeleteArr;
    console.log(deleteArr);

    if (!deleteArr)
        return res.status(400).send("Datos del body mal formateados");

    if (!(typeof deleteArr[Symbol.iterator] === 'function' && !(typeof deleteArr === 'string')))
        return res.status(400).send("Datos del body mal formateados");
        
    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.findOne();
    
    if (!nevera)
        return res.status(404).send("No se encuentran los datos de la nevera");


    let neveraContent = nevera.productos;
    
    deleteArr.forEach(function(element) {

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

    if (!barcodeRegEx.test(req.body.barcode))
        return res.status(400).send("Datos del body mal formateados");

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

////////////////////////////////////////////////////////////////
/////                  RUTAS PARA PRUEBAS                  /////
////////////////////////////////////////////////////////////////

router.post("/apiImg", async (req, res) => {

    var fotos = await getImgByAPI(req.body.barcode);

    var pics = fotos.product.selected_images.front.display;
    console.log(pics);
    res.send(pics);
});

router.get("/restoreNevera", async (req, res) => {

    console.log("RESETTING NEVERA");
    
    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = new Nevera();
    nevera.usuario = "0";
    nevera.productos = ["5449000000996", "8422904015553", "3033710065967"];
    //nevera.usuario = req.body.user;
    //nevera.productos = [];
    const result = nevera.save();

    if (result) 
        res.send(nevera.productos);
        
});

router.get("/dropNeveraCol", async (req, res) => {
    console.log("DROPPING NEVERA");
    let nevera = await Nevera.deleteMany({});
    const result = nevera.save();

    if (result) 
        return res.send("Nevera collection dropped");
    else 
        return res.status(400).send();
});

router.get("/getNeveraArray", async (req, res) => {

    // let nevera = await Nevera.find( { usuario: req.body.user } )
    let nevera = await Nevera.findOne();

    console.log(nevera);

    if (!nevera)
        return res.status(404).send("No se encuentran los datos de la nevera");

    res.send(nevera.productos);

});


// router.put("/testregex", async (req, res) => {

//     let nevera = await Nevera.findOne();
    
//     if (!nevera)
//         return res.status(404).send("No se encuentran los datos de la nevera");
    
//     a = req.body.toDeleteArr
//     console.log(typeof a[Symbol.iterator] === 'function' && typeof a === 'string');
    
//     res.send(typeof a[Symbol.iterator] === 'function' && !(typeof a === 'string'));

// });

module.exports = router;