const express = require("express");
const mongoose = require("mongoose");
const https = require("https");
const router = express.Router();

const { Receta } = require("../models/receta");
const { Nevera } = require("../models/nevera");
const { ProductV2 } = require("../models/product_v2");
const { Usuario } = require("../models/usuario");
const auth = require("../middlewares/auth");
const { convertIngredientsUnits } = require("../utils/unitConversion");
const { query } = require("express");


router.get("/suggested", auth, async (req, res) => {
  const nevera = await Nevera.findOne(
    { usuario: req.user._id },
  );

  if (nevera) {

    intArray = [];

    nevera.productos.forEach(function (item) {
      intArray.push(parseInt(item, 10));
    });

    console.log(nevera.productos);

    // const names = await ProductV2.find(
    //   {  id: { $in: nevera.productos } },
    //   { _id: 0, inner_ingredient: 1 }
    // );

    const names = await ProductV2.aggregate([
      { $match: { id: { $in: nevera.productos } } },
      { $group: {_id: null, uniqueValues: {$addToSet: "$inner_ingredient"}} }
    ]);

    console.log(names[0]);
    console.log(names[0].uniqueValues);
    
    if (names) {
      const recetas = await Receta.find({ ingredientes_list: { $in: names[0].uniqueValues } });
      console.log(recetas);
      res.send(recetas);
    }
  }
  res.send("No hay nada");
});

// router.get("/getDiets", auth, async (req, res) => {
 async function fetchDiet(product) {

  autoTags = [];

  // console.log(product[0].tags);
  allergens = product[0];

  if (allergens.tags.includes("en:non-vegan"))
  // if (product.tags.includes("en:vegan"))
    autoTags.push("Vegano");

  //se puede sustituir para hacer un flitro más suave
  if (allergens.tags.includes("en:non-vegetarian"))
  // if (product.tags.includes("en:vegetarian"))
    autoTags.push("Vegetariano");

  // console.log(autoTags);
  return autoTags;
}
// });

// router.get("/getAllergens/:id", auth, async (req, res) => {
async function fetchAllergens(product) {
  x = product[0].allerg;
  // console.log(x.length);
  // console.log(x);

  if (x.length > 0) {
    arr1 = x[0];
    for (let i = 1; i < x.length; i++) {
      arr1 = arr1.filter((value) => x[i].includes(value));
    }
    // console.log(arr1);
    return (arr1);
  }

  // const genericProd = await ProductV2.find({ name: test });
  // genericProd.allergens_from_user = arr1;
  // genericProd.save();

  return [];
}  
// });

//ojo con el rendimiento al demandar mucha receta. Pendiente de hacer regulable el limite
router.get("/getAllRecetas", auth, async (req, res) => {

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

  var ingre = "";

  if (req.user.sistema_internacional || req.user.sistema_unidades == 'sist_int') {
    ingre = "$ingredientes_inter";
    console.log("internacional");
  }
  else {
    ingre = "$ingredientes_imp";
    console.log("imperial");
  }

  console.log(user.recetas_favs);
  
    let recetaList = await Receta.aggregate([
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
  

  res.send(recetaList);
});
router.get("/getAllRecetas2", auth, async (req, res) => {

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

  var ingre = "";
  if (req.user.sistema_internacional || req.user.sistema_unidades == 'sist_int') {
    ingre = "$ingredientes_inter";
    console.log("internacional");
  }
  else {
    ingre = "$ingredientes_imp";
    console.log("imperial");
  }

    var dietArr = [];
    var dietQuery = {};
    var banQuery = {};
    var levelQuery = {};

    if (user.vegano)
      dietArr.push("Vegano");

    if (user.vegetariano)
      dietArr.push("Vegetariano");

    if (dietArr.length > 0)
      dietQuery = { tags: {$in: dietArr }};
      // dietQuery = { tags: {$all: dietArr }};
      
    // esto peta por el tema de que los users están desfasados
    if (user.category_ban.length > 0)
      banQuery = { ingredientes_list: {$nin: user.category_ban }};
      // banQuery = { ingredientes_list: {$nin: ["zanahoria"] }};

    // if (alergias de alimentos)
    // if (req.user.tags)
    // level de dificultad
    if (user.nivel_cocina)
      levelQuery = { score: { $gte: nivel_cocina } };

    console.log(dietQuery);
    console.log(dietArr);
    console.log("/////////////");
    console.log(banQuery);

  // .limit(25);
  //if (vegano) {//ajustar el tema de token

    let recetaList = await Receta.aggregate([
      { 
        $match: {
             $and: [
                 dietQuery,
                 banQuery,
                 levelQuery
             ]
        }
      },
      {
        "$project": {
          "ide": {
            "$toObjectId": "$usuario"
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
        }
      }
    ]);
  

  res.send(recetaList);
});
router.get("/getAllRecetas3", auth, async (req, res) => {

    var dietArr = [];
    var dietQuery = {};
    var banQuery = {};
    var levelQuery = {};
    var neveraQuery = {};


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
  
  /////
  const nevera = await Nevera.findOne(
    { usuario: req.user._id },
  );

  if (nevera) {

    if (nevera.productos.length > 0) {
      console.log(nevera.productos);
  
      const names = await ProductV2.aggregate([
        { $match: { id: { $in: nevera.productos } } },
        { $group: {_id: null, uniqueValues: {$addToSet: "$inner_ingredient"}} }
      ]);
  
      console.log(names[0]);
      console.log(names[0].uniqueValues);
      console.log("//////////");
      
      if (names[0].uniqueValues && names[0].uniqueValues.length > 0) {
        // const recetas = await Receta.find({ ingredientes_list: { $in: names[0].uniqueValues } });
        // console.log(recetas);
        // res.send(recetas);
        neveraQuery = { ingredientes_list: { $in: names[0].uniqueValues } };
      }
    }
  } else
    return res.status(404).send("No existe la nevera del usuario");
  /////

  var ingre = "";
  if (req.user.sistema_internacional || req.user.sistema_unidades == 'sist_int') {
    ingre = "$ingredientes_inter";
    console.log("internacional");
  }
  else {
    ingre = "$ingredientes_imp";
    console.log("imperial");
  }


  if (user.vegano)
    dietArr.push("Vegano");

  if (user.vegetariano)
    dietArr.push("Vegetariano");

  if (dietArr.length > 0)
    dietQuery = { tags: {$in: dietArr }};
    // dietQuery = { tags: {$all: dietArr }};
    
  // esto peta por el tema de que los users están desfasados
  if (user.category_ban.length > 0)
    banQuery = { ingredientes_list: {$nin: user.category_ban }};
    // banQuery = { ingredientes_list: {$nin: ["zanahoria"] }};

  // if (alergias de alimentos)
  // if (req.user.tags)
  // level de dificultad
  console.log(user.nivel_cocina);
  if (user.nivel_cocina)
    levelQuery = { dificultad: { $lte: user.nivel_cocina }};

  console.log(dietQuery);
  console.log(dietArr);
  console.log("/////////////");
  console.log(banQuery);
  console.log(neveraQuery);

  // .limit(25);
  //if (vegano) {//ajustar el tema de token

    let recetaList = await Receta.aggregate([
      { 
        $match: {
             $and: [
                 dietQuery,
                 banQuery,
                 levelQuery,
                 neveraQuery
             ]
        }
      },
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
  

  res.send(recetaList);
});

router.post("/addReceta", auth, async (req, res) => {
  let receta = new Receta();

  // console.log(req.body);
  receta.usuario = req.user._id.toString();
  
  if (req.body.titulo) receta.titulo = req.body.titulo;
  else return res.status(400).send("No se ha enviado un título válido");

  if (req.body.descripcion) receta.descripcion = req.body.descripcion;
  // else
  //   return res.status(400).send("No se ha enviado un nivel de dificultad válido");
  
  if (req.body.imagenes) receta.imagenes = req.body.imagenes;
  // else return res.status(400).send("No se ha enviado un título válido");

  if (req.body.dificultad) receta.dificultad = parseInt(req.body.dificultad, 10);
  else
    return res.status(400).send("No se ha enviado un nivel de dificultad válido");
  
  if (req.body.comensales) receta.comensales = parseInt(req.body.comensales, 10);
  else
    return res.status(400).send("No se ha enviado una cantidad de comensales válido");

  if (req.body.tiempo) receta.tiempo = req.body.tiempo;
  else return res.status(400).send("No se ha insertado una duración válida");

  if (req.body.ingredientes && req.body.ingredientes.length && req.body.ingredientes.length > 0) receta.ingredientes = req.body.ingredientes;
  else
    return res.status(400).send("La receta debe coneter ingredietes válidos");

  if (req.body.pasos && req.body.pasos.length && req.body.pasos.length > 0) receta.pasos = req.body.pasos;
  else return res.status(400).send("La receta debe contener pasos a seguir");

  if (req.body.consejos) receta.consejos = req.body.consejos;

  // if (req.body.tags && req.body.tags.length && req.body.tags.length > 0) receta.tags = req.body.tags;
  // else return res.status(400).send("La receta debe contener al menos un tag");
  receta = await unitConverting(receta);
  
  receta.allergenList = [];
  receta.tags = [];

  var i;
  for (i = 0; i < receta.ingredientes_list.length; i++) {
    const query = await allergenDietQuery(receta.ingredientes_list[i]);

    receta.allergenList = receta.allergenList.concat(await fetchAllergens(query));
    receta.tags = receta.tags.concat(await fetchDiet(query));
    
 }

  receta.allergenList = receta.allergenList.filter(onlyUnique);
  receta.tags = receta.tags.filter(onlyUnique);
  
  const result = receta.save();

  res.send(result);
});

router.get("/getReceta/:id", auth, async (req, res) => {
  let receta = await Receta.findById(req.params.id);
  console.log("Buscando receta: " + req.params.id);
  if (!receta) return res.status(404).send("La receta solicitada no existe");
  res.send(receta);
});

router.get("/addImpInterToAll", auth, async (req, res) => {

  let recetas = await Receta.find({}, {ingredientes:1});

  console.log("//////print de recetas enteras///////");
  console.log(recetas);

  recetas.forEach(function (x) {
    var dictImp = JSON.parse(JSON.stringify(x.ingredientes));
    var dictInter = JSON.parse(JSON.stringify(x.ingredientes));
    var ingArr = [];

    for (const [key, value] of Object.entries(dictImp)) {
      let [keyIn, valueIn] = Object.entries(value)[0];
      valueIn = convertIngredientsUnits(valueIn, false);
      ingArr.push(keyIn);
    }
    
    for (const [key, value] of Object.entries(dictInter)) {
      let [keyIn, valueIn] = Object.entries(value)[0];
      valueIn = convertIngredientsUnits(valueIn, true);
    }

    console.log("//////x.ingredientes///////");
    console.log(x.ingredientes);
    console.log("//////dictImp///////");
    console.log(dictImp);
    console.log("//////dictInter///////");
    console.log(dictInter);
    console.log("//////ingArr///////");
    console.log(ingArr);

    x.ingredientes_imp    = dictImp;
    x.ingredientes_inter  = dictInter;
    x.ingredientes_list   = ingArr;

    const result = x.save();
      if(!result)
          return res.status(400).send("ERROR al actualizar perfil");
    console.log(result);
  });

    res.send("OK");

});

async function unitConverting(x) {

  dictImp = JSON.parse(JSON.stringify(x.ingredientes));
  dictInter = JSON.parse(JSON.stringify(x.ingredientes));
  var ingArr = [];

  for (const [key, value] of Object.entries(dictImp)) {
    let [keyIn, valueIn] = Object.entries(value)[0];
    valueIn = convertIngredientsUnits(valueIn, false);
    ingArr.push(keyIn);
  }
  
  for (const [key, value] of Object.entries(dictInter)) {
    let [keyIn, valueIn] = Object.entries(value)[0];
    valueIn = convertIngredientsUnits(valueIn, true);
  }

  x.ingredientes_imp    = dictImp;
  x.ingredientes_inter  = dictInter;
  x.ingredientes_list   = ingArr;

  return x;
}

async function allergenDietQuery(product) {

  var a = await ProductV2.aggregate([
    { $match: { inner_ingredient: product } },
    { "$group": {
    "_id": "analysis",
    "tags": { "$addToSet": "$ingredients_analysis_tags" },
	  "allerg": { $push: "$allergens_tags" },
	}},
	{ "$addFields": {
    "tags": {
      "$reduce": {
        "input": "$tags",
        "initialValue": [],
        "in": { "$setUnion": [ "$$value", "$$this" ] }
      }
    }
  }}
  ]);
  
  return a;
}

function onlyUnique(value, index, self) {
  return self.indexOf(value) === index;
}

router.get("/addRecetaFIXED1", auth, async (req, res) => {
  let receta = new Receta();
  //https://www.lagloriavegana.com/hummus-de-zanahoria/
  var dict = [
    { "garbanzos cocidos": ["400", "gramos"] },
    { "diente de ajo": ["1", ""] },
    { "zanahoria": ["300", "gramos"] },
    { "aceite de oliva": ["50", "gramos"] },
    { "zumo de limón": ["1", "cucharada"] }, //1 cda de zumo limón
    { "tahín tostado": ["30", "gramos"] }, // 30 g de tahín tostado o 30 g de semillas de sésamo (triturar solas antes)
    { "Nutella": ["", ""] }
  ];

  receta.usuario = "60b293125590d80030bcded2";
  receta.titulo = "Hummus de zanahoriaFIXED";
  receta.dificultad = 2;
  receta.descripcion =
    "¡Hola a tod@s! ¡¿Cuántas versiones de hummus os habré presentado hasta la fecha?! Desde luego, no me aburro de comerlo en sus distintas variedades, y mis invitad@s tampoco.\n\n Os traigo una opción para acompañar en cualquier pica-pica que se preste. ¡Y esta triunfa ¡seguro! A mi me gusta acompañarlo de sticks de zanahoria, pepino, tomate cherry, endibia…Pero los crackers, nachos y palitos también son una buena alternativa. Para gustos, colores. Y para hummus, ¡sabores!";

  receta.tiempo = "15:00";
  receta.imagenes = [
    "https://www.lagloriavegana.com/wp-content/uploads/2020/08/IMG_9275-1280x1280.jpg",
  ];
  receta.ingredientes = dict;
  
  receta.pasos = [
    "Lavamos y cortamos en rodajas las zanahorias.",
    "Las ponemos en un recipiente apto para microondas y cocinamos a máxima potencia durante 5 minutos (o hasta que estén tiernas). También se pueden hornear o hacer al vapor. Dejamos que se templen.",
    "Ponemos en el procesador todos los ingredientes y trituramos hasta conseguir una crema fina. ¡ESTÁ INCREÍBLE!",
  ];
  receta.consejos = [];

  receta.rating_num = 4;
  receta.tags = ["Vegetariano", "tag1", "tag2", "tag3", "tag4"];
  receta.allergenList = ["en:gluten", "en:oats", "en:crustaceans", "en:eggs", "en:fish", "en:peanuts", "en:soybeans", "en:milk", "en:nuts", "en:celery", "en:mustard", "en:sesame-seeds", "en:sulphur-dioxide-and-sulphites", "en:lupin", "en:molluscs"];
  const result = receta.save();
  //return res.status(404).send("No hay recetas");

  res.send(receta);
});

// andrés, cuando acabes lo que estás haciendo como te dije antes, necesito la ruta de búsqueda de recetas teniendo en cuenta si está en favs o es del usuario en cuestión
// a este pedido añadele un borrar recetas en base a la id que te pasen
// no has de controlar ni que sean del usuario en cuestión, de eso me he encargado yo

router.get("/getUserRecetas/", auth, async (req, res) => {
  
  let user = await Usuario.findOne({ correo: req.user.correo },
    {
        _id: 0,
        recetas_favs: 1,
    });

    if (req.user.sistema_internacional || req.user.sistema_unidades == 'sist_int') {
      ingre = "$ingredientes_inter";
      console.log("internacional");
    }
    else {
      ingre = "$ingredientes_imp";
      console.log("imperial");
    }
    
    console.log(user.recetas_favs);
    // let objectIdArray = mongoose.Types.ObjectId(user.recetas_favs);
    // console.log(objectIdArray);

    let recetaList2 = await Receta.aggregate([
      {$addFields: {
        idReceta: { $toString: "$_id" }
      }} ,
      { 
        $match: {
             $or: [
                { idReceta: { $in: user.recetas_favs } },
                { usuario: req.user._id},
             ]
        }
      },
      {
        "$project": {
          "ide": {
            "$toObjectId": "$usuario"
          },
          "idReceta": { "$toString": "$_id" },
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
            $cond: {if: { $in: [ "$idReceta", user.recetas_favs]}, then: true, else: false}
          },
        }
      }
    ]);
    
    res.send(recetaList2);
});

router.delete("/:id", auth, async (req, res) => {

  let recetaDel = await Receta.findByIdAndDelete(req.params.id);
    console.log(recetaDel);

    if (!recetaDel) return res.status(404).send("Error al eliminar receta");
    
    res.send("Receta eliminada correctamente");

});



module.exports = router;