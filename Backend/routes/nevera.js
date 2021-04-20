const express = require("express");
const router = express.Router();
const { Nevera } = require("../models/nevera");
const { Producto } = require("../models/producto");


router.get("/getProd", async (req, res) => {

    //db.products.find( { _id: req.body.barcode } )
    //let producto = await Producto.find( { _id: req.body.barcode } );

    //let data = JSON.parse("https://world.openfoodfacts.org/api/v0/product/5449000000996.json");
    //console.log(data);
    //res.send(data);

});


router.get("/getNevera", async (req, res) => {

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
    

    //let prodArray = nevera.productos;
    //let listedPords = await Producto.find( { _id: { $in: prodArray } } )

    res.send(nevera.productos);

});

/*
{
    "toDeleteArr": ["111111111111111"]
}
 */
router.delete("/deleteNevera", async (req, res) => {

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

module.exports = router;