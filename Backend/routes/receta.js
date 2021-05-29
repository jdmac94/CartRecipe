const express = require("express");
const https = require("https");
const router = express.Router();

const { Receta } = require("../models/receta");
const { Nevera } = require("../models/nevera");
const { ProductV2 } = require("../models/product_v2");
const { Usuario } = require("../models/usuario");
const auth = require("../middlewares/auth");
const { convertIngredientsUnits } = require("../utils/unitConversion");
const { query } = require("express");

async function fillReceta(body, receta) {
  if (body.titulo) receta.titulo = body.titulo;
  else return res.status(400).send("No se ha enviado un título válido");

  if (body.dificultad) receta.dificultad = body.dificultad;
  else
    return res
      .status(400)
      .send("No se ha enviado un nivel de dificultad válido");

  if (body.tiempo) receta.tiempo = body.tiempo;
  else return res.status(400).send("No se ha insertado una duración válida");

  if (body.ingredientes) receta.ingredientes = body.ingredientes;
  else
    return res.status(400).send("La receta debe coneter ingredietes válidos");

  if (body.pasos.length) receta.pasos = body.pasos;
  else return res.status(400).send("La receta debe contener pasos a seguir");

  if (body.consejos) receta.consejos = req.body.consejos;

  if (body.tags) receta.tags = body.tags;

  //receta.allergenList = ["alergeno0","alergeno1","alergeno2","alergeno3","alergeno4","alergeno5"]
  // antes de guardar la receta debe haber una función para extraer los alergenos de todos los ingredientes de la receta

  //receta.rating_num = 4; por defecto que sea undefined al no tener valoraciones

  return receta;
}
// falta tocarla pero es para el 10, anes quedan otras cosas
router.get("/suggested", auth, async (req, res) => {
  const nevera = await Nevera.findOne(
    { usuario: req.user._id },
  );

  if (nevera) {

    intArray = [];

    nevera.productos.forEach(function (item) {
      intArray.push(parseInt(item, 10));
    });

    console.log(intArray);

    const names = await ProductV2.find(
      { products: { $elemMatch: { id: { $in: intArray } } } },
      { _id: 0, name: 1 }
    );
    console.log(names);
    if (names) {
      const recetas = await Receta.find({ ingredientes: { $in: names } });
      res.send(recetas);
    }
  }
  res.send("No hay nada");
});

// router.get("/getDiets", auth, async (req, res) => {
 async function fetchDiet(product) {
  
  // var product = "Patatas Fritas";

  // const allergens = await ProductV2.aggregate([
  //   { $match: { inner_ingredient: product } },//MODIFICAR!!!!!!!!
  //   { "$group": {
  //   "_id": "analysis",
  //   "tags": { "$addToSet": "$ingredients_analysis_tags" }
	// }},
	// { "$addFields": {
  //   "tags": {
  //     "$reduce": {
  //       "input": "$tags",
  //       "initialValue": [],
  //       "in": { "$setUnion": [ "$$value", "$$this" ] }
  //     }
  //   }
  // }}
  // ]);

  autoTags = [];

  console.log(product.tags);

  //if (allergens.tags.includes("en:non-vegan"))
  if (product.tags.includes("en:vegan"))
    autoTags.push("Vegano");

  //se puede sustituir para hacer un flitro más suave
  //if (allergens.tags.includes("en:non-vegetarian"))
  if (product.tags.includes("en:vegetarian"))
    autoTags.push("Vegetariano");


  res.send(autoTags);
}
// });

// router.get("/getAllergens/:id", auth, async (req, res) => {
async function fetchAllergens(product) {

  // const allergens = await ProductV2.aggregate([
  //   { $match: { inner_ingredient: product } },
  //   {
  //     $group: {
  //       _id: "$inner_ingredient",
  //       allerg: { $push: "$allergens_tags" },
  //     },
  //   },
  //   { $project: { name: 1, allerg: 1 } },
  // ]);

  // x = allergens[0].allerg;
  x = product.allerg;

  if (x.length > 0) {
    arr1 = x[0];
    for (let i = 1; i < x.length; i++) {
      arr1 = arr1.filter((value) => x[i].includes(value));
    }
    console.log(arr1);
    return res.send(arr1);
  }

  // const genericProd = await ProductV2.find({ name: test });
  // genericProd.allergens_from_user = arr1;
  // genericProd.save();

  res.send([]);
}  
// });

//ojo con el rendimiento al demandar mucha receta. Pendiente de hacer regulable el limite
router.get("/getAllRecetas", auth, async (req, res) => {

  var ingre = "";
  if (req.user.sistema_internacional || req.user.sistema_unidades == 'sist_int') {
    ingre = "$ingredientes_inter";
    console.log("internacional");
  }
  else {
    ingre = "$ingredientes_imp";
    console.log("imperial");
  }

    let recetaList = await Receta.aggregate([
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

    if (user.vegano)
      dietArr.push("Vegano");

    if (user.vegetariano)
      dietArr.push("Vegetariano");

    if (dietArr.length > 0)
      dietQuery = { tags: {$in: dietArr }};
      
    // esto peta por el tema de que los users están desfasados
    if (user.category_ban.length > 0)
      banQuery = { ingredientes_list: {$nin: user.category_ban }};
      // banQuery = { ingredientes_list: {$nin: ["zanahoria"] }};

    // if (alergias de alimentos)
    // if (req.user.tags)

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
router.post("/addReceta", auth, async (req, res) => {
  let receta = new Receta();

  receta.usuario = "0";

  if (titulo) receta.titulo = req.body.titulo;
  else return res.status(400).send("No se ha enviado un título válido");

  if (req.body.dificultad) receta.dificultad = req.body.dificultad;
  else
    return res.status(400).send("No se ha enviado un nivel de dificultad válido");

  if (req.body.tiempo) receta.tiempo = req.body.tiempo;
  else return res.status(400).send("No se ha insertado una duración válida");

  if (req.body.ingredientes.length && req.body.ingredientes.length > 0) receta.ingredientes = req.body.ingredientes;
  else
    return res.status(400).send("La receta debe coneter ingredietes válidos");

  if (req.body.pasos.length && req.body.pasos.length > 0) receta.pasos = req.body.pasos;
  else return res.status(400).send("La receta debe contener pasos a seguir");

  if (req.body.consejos) receta.consejos = req.body.consejos;

  // receta = processReceta(receta);

  const result = receta.save();

  res.send(result);
});
router.get("/sugerida", auth, async (req, res) => {
  const recetas = [];
  const palabrasClaveNevera = [];
  const productos = await Nevera.find(
    { usuario: req.user._id },
    { _id: 0, productos: 1 }
  );

  productos.map(async (index) => {
    const palabrasClaveProducto = await Product.findOne(
      { _id: index },
      { generic_name: 1 }
    );
    palabrasClaveNevera.push(palabrasClaveProducto.split(""));
  });
  return palabrasClaveNevera.length !== 0
    ? await Receta.find({ ingredientes: { $regex: palabrasClaveNevera } })
    : [];
});
router.get("/getReceta/:id", auth, async (req, res) => {
  let receta = await Receta.findById(req.params.id);
  console.log("Buscando receta: " + req.params.id);
  if (!receta) return res.status(404).send("La receta solicitada no existe");
  res.send(receta);
});
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
    { "Sal": ["", ""] }
  ];

  receta.usuario = "60acad1719bfc70030a006cf";
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
  receta.tags = ["tag0", "tag1", "tag2", "tag3", "tag4"];
  receta.allergenList = ["en:gluten", "en:oats", "en:crustaceans", "en:eggs", "en:fish", "en:peanuts", "en:soybeans", "en:milk", "en:nuts", "en:celery", "en:mustard", "en:sesame-seeds", "en:sulphur-dioxide-and -sulphites", "en:lupin", "en:molluscs"];
  const result = receta.save();
  //return res.status(404).send("No hay recetas");

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

  console.log("/////////////");
  console.log(x.ingredientes);
  console.log(dictImp);
  console.log(dictInter);
  console.log(ingArr);

  x.ingredientes_imp    = dictImp;
  x.ingredientes_inter  = dictInter;
  x.ingredientes_list   = ingArr;

  const result = x.save();
    if(!result)
        return res.status(400).send("ERROR al actualizar perfil");
  console.log(result);
}

async function allergenDietQuery(product) {

  db.customProducts.aggregate([
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

}

function onlyUnique(value, index, self) {
  return self.indexOf(value) === index;
}

async function processReceta(receta) {

  receta.ingredientes_list.forEach(function (ingredient) {
    var query = allergenDietQuery(ingredient);

    receta.allergenList = receta.allergenList.concat(fetchAllergens(query));
    receta.tags = receta.tags.concat(fetchDiet(query));
  });

  receta.allergenList = receta.allergenList.filter(onlyUnique);
  receta.tags = receta.tags.filter(onlyUnique);


  receta = unitConverting(receta);
  return receta;
}

module.exports = router;
