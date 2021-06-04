const express = require("express");
const router = express.Router();

const { ProductV2 } = require("../models/product_v2");
const { Receta } = require("../models/receta");
const { Usuario } = require("../models/usuario");
const auth = require("../middlewares/auth");

router.get("/recetas/:search", auth, async (req, res) => {

    console.log("regex test");
    var replace = ".*" + req.params.search.trim() + ".*";
    var re = new RegExp(replace, "i");

    var ingre = "";

    let user = await Usuario.findOne({ correo: req.user.correo },
      {
        vegano: 1,
        vegetariano: 1,
        alergias: 1,
        tags: 1,
        banArray: 1,
        nivel_cocina: 1,
        category_ban: 1,
        recetas_favs: 1,
      });
  
    if (!user)
      return res.status(404).send("Error al obtener las preferencias del usuario");
    
    console.log(user);

    if (req.user.sistema_internacional || req.user.sistema_unidades == 'sist_int') {
      ingre = "$ingredientes_inter";
      console.log("internacional");
    }
    else {
      ingre = "$ingredientes_imp";
      console.log("imperial");
    }

    // var fetchResult = await Receta.find({ titulo: re }).limit(10);
    let fetchResult = await Receta.aggregate([
      { $match: { titulo: re } },
      {
        "$project": {
          "ide": {
            "$toObjectId": "$usuario"
          },
          _id: {
            $toString: "$_id"
           },
          "titulo": "$titulo",
          "dificultad": "$dificultad",
          "descripcion": "$descripcion",
          "tiempo": "$tiempo",
          "imagenes": "$imagenes",
          "ingredientes": ingre,
          "pasos": "$pasos",
          "consejos": "$consejos",
          "comensales" : "$comensales",
          "tags" : "$tags",
          "allergenList" : "$allergenList",
        }
      },
      {
        "$lookup": {
          "from": "usuarios",
          "localField": "ide",
          "foreignField": "_id",
          "as": "usr"
        }
      },
      {
      "$project": {
          "usuario": "$usuario",
          "titulo": "$titulo",
          "dificultad": "$dificultad",
          "descripcion": "$descripcion",
          "tiempo": "$tiempo",
          "imagenes": "$imagenes",
          "ingredientes": "$ingredientes",
          "pasos": "$pasos",
          "consejos": "$consejos",
          "comensales" : "$comensales",
          "tags" : "$tags",
          "allergenList" : "$allergenList",
          "usr.apellido": 1,
          "usr.nombre": 1,
          "fav": 
          {
            $cond: {if: { $in: [ "$_id", user.recetas_favs]}, then: true, else: false}
          },
        }
      }
    ]);



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