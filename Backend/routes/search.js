const express = require("express");
const router = express.Router();

const { ProductV2 } = require("../models/product_v2");
const { Receta } = require("../models/receta");
const auth = require("../middlewares/auth");

router.get("/recetas/:search", async (req, res) => {

    console.log("regex test");
    var replace = ".*" + req.params.search.trim() + ".*";
    var re = new RegExp(replace, "i");

    var fetchResult = await Receta.find({ titulo: re }).limit(10);
    
    if (!fetchResult)
      return res.status(404).send("No ha resultados coincidentes");

    res.send(fetchResult);
  });

  router.get("/recetas/tags/:search", async (req, res) => {

    console.log("regex test");
    var replace = ".*" + req.params.search.trim() + ".*";
    var re = new RegExp(replace, "i");

    // var fetchResult = await Receta.find({ tags: { $in: [/.*Asiático.*/] } }).limit(10);
    var fetchResult = await Receta.find({ tags: { $in: [re] } }).limit(10);
    
    if (!fetchResult)
      return res.status(404).send("No ha resultados coincidentes");

    res.send(fetchResult);
  });

  router.get("/products/:search", async (req, res) => {

    console.log("search: " + req.params.search);
    
    var replace = ".*" + req.params.search.trim() + ".*";
    var re = new RegExp(replace, "i");

    var fetchResult = await ProductV2.find({ $or: [{ product_name: re }, { product_name_es: re }] }).limit(10);//to test

    if (!fetchResult || (Array.isArray(fetchResult) && fetchResult.length == 0))
      return res.status(404).send("No ha resultados coincidentes");

    res.send(fetchResult);
  });

  router.get("/products/categorias/:search", async (req, res) => {

    console.log("search: " + req.params.search);
    
    var replace = ".*" + req.params.search.trim() + ".*";
    var re = new RegExp(replace, "i");

    var fetchResult = await ProductV2.find({ inner_category: re });//.limit(10);//to test

    if (!fetchResult || (Array.isArray(fetchResult) && fetchResult.length == 0))
      return res.status(404).send("No ha resultados coincidentes");

    res.send(fetchResult);
  });

module.exports = router;