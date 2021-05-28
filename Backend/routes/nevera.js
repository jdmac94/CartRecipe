const express = require("express");
const router = express.Router();

const { Nevera } = require("../models/nevera");
const { Product } = require("../models/product");
const { ProductV2 } = require("../models/product_v2");
const { Categoria } = require("../models/categoria");
const { Receta } = require("../models/receta");

const { checkImgFromAPI } = require("../utils/imageAPI");
const auth = require("../middlewares/auth");

const barcodeRegEx = /^[0-9]{13}$/;
const barcodeRegEx2 = /^[0-9]{8}$/;

router.get("/", auth, async (req, res) => {
  console.log("GETTING NEVERA");
  let nevera = await Nevera.findOne({ usuario: req.user._id });

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  let prodArray = nevera.productos;
  let listedProds = await ProductV2.find(
    { _id: { $in: prodArray } },
    {
      product_name: 1,
      product_name_es: 1,
      nutriments: 1,
      ecoscore_grade: 1,
      nova_groups: 1,
      quantity: 1,
      nutriscore_grade: 1,
      // ingredients: 1,
      ingredients_analysis_tags: 1,
      allergens_tags: 1,
      traces: 1,
      traces_tags: 1,
      ingredients_text_es: 1,
    }
  );

  for (let element of listedProds) {
    element.imgs = await checkImgFromAPI(element._id);
  }

  res.send(listedProds);
});

router.get("/list", auth, async (req, res) => {
  //var date = Date.now();
  //var timeStr = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();

  console.log("GETTING NEVERA LIST ");
  // let nevera = await Nevera.find( { usuario: req.body.user } )
  let nevera = await Nevera.findOne({ usuario: req.user._id });

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  let prodArray = nevera.productos;

  console.log(prodArray);

  let listedProds = await ProductV2.find(
    { _id: { $in: prodArray } },
    { product_name: 1, allergens_from_user: 1, product_name_es: 1 }
  );

  if (
    !(
      typeof listedProds[Symbol.iterator] === "function" &&
      !(typeof listedProds === "string")
    )
  )
    return res
      .status(400)
      .send("Formato del contenido de la nevera incorrecto");

  for (let element of listedProds) {
    element.imgs = await checkImgFromAPI(element._id);
  }

  res.send(listedProds);
});

/*
{
    "toDeleteArr": ["111111111111111"]
}
 */
router.delete("/product", auth, async (req, res) => {
  console.log("DELETING NEVERA CONTENT");
  deleteArr = req.body.toDeleteArr;
  console.log(deleteArr);

  if (!deleteArr) return res.status(400).send("Datos del body mal formateados");

  if (
    !(
      typeof deleteArr[Symbol.iterator] === "function" &&
      !(typeof deleteArr === "string")
    )
  )
    return res.status(400).send("Datos del body mal formateados");

  // let nevera = await Nevera.find( { usuario: req.body.user } )
  let nevera = await Nevera.findOne({ usuario: req.user._id });

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  let neveraContent = nevera.productos;

  deleteArr.forEach(function (element) {
    delIndex = neveraContent.indexOf(element);

    if (delIndex != -1) neveraContent.splice(delIndex, 1);
  });

  nevera.productos = neveraContent;
  const result = nevera.save();

  if (result) res.send(nevera.productos);
});

router.delete("/", auth, async (req, res) => {
  console.log("CLEARING NEVERA CONTENT");
  let nevera = await Nevera.findOne({ usuario: req.user._id });

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  nevera.productos = [];

  const result = nevera.save();

  if (result) res.send(nevera.productos);
});

/*
  
 {
    "barcode": "111111111111111"
 }

 */
router.put("/product/:id", auth, async (req, res) => {
  console.log("ADDING NEVERA CONTENT");
  console.log(req.params);
  let nevera = await Nevera.findOne({ usuario: req.user._id });

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  if (!barcodeRegEx.test(req.params.id) || !barcodeRegEx2.test(req.params.id))
    return res.status(400).send("Datos del body mal formateados");

  var prod = await ProductV2.findById(req.params.id);

  if (!prod) return res.status(404).send("El producto a insertar no existe");

  let neveraContent = nevera.productos;
  delIndex = neveraContent.indexOf(req.params.id);

  if (delIndex == -1) {
    let prodArray = nevera.productos;

    prodArray.push(req.params.id);
    nevera.productos = prodArray;
    const result = nevera.save();
    if (result) {
      let listedProds = await ProductV2.findOne(
        { _id: req.params.id },
        {
          _id: 1,
          allergens_from_user: 1,
          imgs: 1,
          product_name: 1,
          product_name_es: 1,
          nutriments: 1,
          ecoscore_grade: 1,
          nova_groups: 1,
          quantity: 1,
          nutriscore_grade: 1,
          // ingredients: 1,
          ingredients_analysis_tags: 1,
          allergens_tags: 1,
          traces: 1,
          traces_tags: 1,
          ingredients_text_es: 1,
        }
      );

      listedProds.imgs = await checkImgFromAPI(listedProds._id);

      res.send(listedProds);
    }
  } else return res.status(400).send("El Producto ya exsite en la nevera"); // pendiente de probar
});

////////////////////////////////////////////////////////////////
/////                  RUTAS PARA PRUEBAS                  /////
////////////////////////////////////////////////////////////////

router.post("/apiImg", async (req, res) => {
  console.log("apiImg");
  var pics = await getImageAPI(req.body.barcode);
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

  if (result) res.send(nevera.productos);
});

router.get("/dropNeveraCol", async (req, res) => {
  console.log("DROPPING NEVERA");
  let nevera = await Nevera.deleteMany({});

  if (nevera) return res.send("Nevera collection dropped");
  else return res.status(400).send();
});

router.get("/getNeveraArray", async (req, res) => {
  // let nevera = await Nevera.find( { usuario: req.body.user } )
  let nevera = await Nevera.findOne();

  console.log(nevera);

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  res.send(nevera.productos);
});

router.get("/getNeveraCat", auth, async (req, res) => {
  /////      EXTRAEMOS CATEGORÍAS DE LA NEVERA      /////

  let nevera = await Nevera.findOne({ usuario: req.user._id });

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  let neveraCategories = await ProductV2.find(
    { _id: { $in: nevera.productos } },
    {
      categories_hierarchy: 1,
    }
  );

  var catArr = [];

  neveraCategories.forEach(function (item) {
    item.categories_hierarchy.forEach(function (element) {
      catIndex = catArr.indexOf(element);

      if (catIndex == -1) catArr.push(element);
    });
  });

  console.log(catArr);
  /////    COMPARAMOS CON LAS CATEGORIAS VALIDAS    /////

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  let filteredCategories = await Categoria.find(
    { en: { $in: catArr } },
    {
      es: 1,
      _id: 0,
    }
  );

  var filteredArr = [];

  filteredCategories.forEach(function (item) {
    filteredArr.push(item.es);
  });
  /////      BUSCAMOS LAS RECETAS COMPATIBLES       /////

  console.log(filteredArr);

  // var finalRecipes = await Receta.find({ ingredientes: { $all: filteredArr } },
  // var finalRecipes = await Receta.find({ ingredientes: { $all: filteredArr } },
  //   {
  //     ingredientes: 1,
  //   });

  var finalRecipes = await Receta.aggregate([
    {
      $project: {
        inBOnly: { $setDifference: ["$ingredientes", filteredArr] },
        _id: 0,
      },
    },
  ]);
  //lo suyo sería poder filtrar el resultado de la proyección de manera que descarte aquellas recetas en que inBOnly mida más de 0

  console.log(finalRecipes);
  res.send(finalRecipes);
});

router.get("/loadCategories", auth, async (req, res) => {
  var fs = require("fs");

  var input = fs.createReadStream("database_prototype.txt");

  var rl = require("readline").createInterface({
    input: input,
    terminal: false,
  });

  rl.on("line", async function (line) {
    var line = line; //.toLowerCase();
    var x = line.split(",");
    let cat = new Categoria();
    cat.es = x[0];
    cat.en = x[1].toLowerCase();

    const result = await cat.save();

    console.log(x[0] + " |||| " + x[1]);
  });
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
