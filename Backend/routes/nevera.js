const express = require("express");
const https = require("https");
const router = express.Router();
const fetch = require("node-fetch");
const { Nevera } = require("../models/nevera");
const { Product } = require("../models/product");
let OFFurl = "https://world.openfoodfacts.org/api/v0/product/";
const barcodeRegEx = /^[0-9]{13}$/;

async function getImgByAPI(code) {
  // console.log("getImgByAPI");
  let url = OFFurl + code + ".json";
  // console.log(url);

  var fotos = fetch(url)
    .then(function (response) {
      return response.json();
    })
    .catch(function (error) {
      console.log("Hubo un problema con la petición Fetch:" + error.message);
      return undefined;
    });
  // console.log("fotos");
  //console.log(fotos);
  return fotos;
}

async function checkImgFromAPI(code) {
  // console.log("checkImgFromAPI");
  var fotos = await getImgByAPI(code);

  if (fotos)
    if (fotos.product.selected_images)
      if (fotos.product.selected_images.front)
        if (fotos.product.selected_images.front.display) {
          return [fotos.product.selected_images.front.display];
        }

  return [];
}

router.post("/deleteToNevera", async (req, res) => {
  console.log(req.body);

  console.log("DELETING NEVERA PROD: " + req.body);
  console.log(req.body);
  deleteArr = req.body.toDeleteArr;

  let nevera = await Nevera.findOne();

  let neveraContent = nevera.productos;

  delIndex = neveraContent.indexOf(deleteArr);

  neveraContent.splice(delIndex, 1);

  nevera.productos = neveraContent;
  nevera.save();

});

router.post("/getProd", async (req, res) => {
  console.log("GETTING PROD: " + req.body.barcode);

  var producto = await Product.findById(req.body.barcode);

  if (!producto)
    return res.status(404).send("El producto solicitado no existe");

  producto.imgs = await checkImgFromAPI(req.body.barcode);

  res.send(producto);
});

router.post("/getProdKeyWord", async (req, res) => {
  console.log("GETTING PROD WITH KEYWORD: " + req.body._keywords);
  /*TODO:
        - hacer dinamico el limite de resultados y que desde la request se pueda cambiar
        - tema de los tags de popularidad
        - busqueda con "LIKE" (keywords parciales)
    */
  var productos = await Product.find({ _keywords: req.body._keywords }).limit(
    10
  );

  if (!productos)
    return res.status(404).send("No hay productos con la keyword solicitada");

  for (producto of productos) {
    producto.imgs = await checkImgFromAPI(producto._id);
  }

  res.send(productos);
});

router.get("/getNevera", async (req, res) => {
  console.log("GETTING NEVERA");
  // let nevera = await Nevera.find( { usuario: req.body.user } )
  let nevera = await Nevera.findOne();

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  let prodArray = nevera.productos;
  let listedProds = await Product.find(
    { _id: { $in: prodArray } },
    {
      _keywords: 1,
      allergens_from_user: 1,
      product_name_es: 1,
      nutriscore_data: 1,
      nova_group: 1,
    }
  );

  for (let element of listedProds) {
    element.imgs = await checkImgFromAPI(element._id);
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

  console.log(prodArray);

  let listedProds = await Product.find(
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
router.post("/deleteNevera", async (req, res) => {
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
  let nevera = await Nevera.findOne();

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

router.post("/deleteNeveraSingle", async (req, res) => {
  console.log("DELETING NEVERA PROD: " + req.body);
  console.log(req.body);
  deleteArr = req.body.toDeleteArr;

  // if (!deleteArr)
  //   return res.status(400).send("Datos del body mal formateados (1)");

  // if (typeof deleteArr === "string")
  //   return res.status(400).send("Datos del body mal formateados (2)");

  let nevera = await Nevera.findOne();

  // if (!nevera)
  //   return res.status(404).send("No se encuentran los datos de la nevera");

  let neveraContent = nevera.productos;

  //x = deleteArr.toString();
  delIndex = neveraContent.indexOf(deleteArr);

  if (delIndex != -1) neveraContent.splice(delIndex, 1);

  nevera.productos = neveraContent;
  const result = nevera.save();

  if (result) res.send(nevera.productos);
});

router.post("/deleteNeveraInt", async (req, res) => {
  console.log("DELETING NEVERA CONTENT");
  deleteArr = req.body.toDeleteArr;
  console.log(deleteArr);

  if (!deleteArr)
    return res.status(400).send("Datos del body mal formateados (1)");

  if (
    !(
      typeof deleteArr[Symbol.iterator] === "function" &&
      !(typeof deleteArr === "string")
    )
  )
    return res.status(400).send("Datos del body mal formateados (2)");

  // let nevera = await Nevera.find( { usuario: req.body.user } )
  let nevera = await Nevera.findOne();

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  let neveraContent = nevera.productos;

  deleteArr.forEach(function (element) {
    x = element.toString();
    delIndex = neveraContent.indexOf(x);

    if (delIndex != -1) neveraContent.splice(delIndex, 1);
  });

  nevera.productos = neveraContent;
  const result = nevera.save();

  if (result) res.send(nevera.productos);
});

router.post("/deleteNeveraSplit", async (req, res) => {
  console.log("DELETING NEVERA CONTENT (SPLITTED VERSION)");
  console.log(req.body.toDeleteArr);

  deleteArr = req.body.toDeleteArr.split(",");

  console.log(deleteArr);

  if (!req.body.toDeleteArr)
    return res.status(400).send("Datos del body mal formateados (1)");

  if (
    !(
      typeof deleteArr[Symbol.iterator] === "function" &&
      !(typeof deleteArr === "string")
    )
  )
    return res.status(400).send("Datos del body mal formateados (2)");

  // let nevera = await Nevera.find( { usuario: req.body.user } )
  let nevera = await Nevera.findOne();

  if (!nevera)
    return res.status(404).send("No se encuentran los datos de la nevera");

  let neveraContent = nevera.productos;

  deleteArr.forEach(function (element) {
    if (barcodeRegEx.test(element)) {
      delIndex = neveraContent.indexOf(element);

      if (delIndex != -1) neveraContent.splice(delIndex, 1);
    }
  });

  nevera.productos = neveraContent;
  const result = nevera.save();

  if (result) res.send(nevera.productos);
});

router.delete("/clearNevera", async (req, res) => {
  console.log("CLEARING NEVERA CONTENT");
  let nevera = await Nevera.findOne();

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
router.put("/addToNevera", async (req, res) => {
  console.log("ADDING NEVERA CONTENT");
  console.log(req.body);
  let nevera = await Nevera.findOne();

  // if (!nevera)
  //   return res.status(404).send("No se encuentran los datos de la nevera");

  // if (!barcodeRegEx.test(req.body.barcode))
  //   return res.status(400).send("Datos del body mal formateados");

  var prod = await Product.findById(req.body.barcode);

  // if (!prod) return res.status(404).send("El producto a insertar no existe");

  let neveraContent = nevera.productos;
  delIndex = neveraContent.indexOf(req.body.barcode);

  if (delIndex == -1) {
    let prodArray = nevera.productos;

    prodArray.push(req.body.barcode);
    nevera.productos = prodArray;
    const result = nevera.save();
    ///if (result) res.send(nevera.productos);
  } //else return res.status(400).send("El Producto ya exsite en la nevera");
});

////////////////////////////////////////////////////////////////
/////                  RUTAS PARA PRUEBAS                  /////
////////////////////////////////////////////////////////////////

router.post("/apiImg", async (req, res) => {
  console.log("apiImg");
  var pics = await checkImgFromAPI(req.body.barcode);
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

// router.put("/testregex", async (req, res) => {

//     let nevera = await Nevera.findOne();

//     if (!nevera)
//         return res.status(404).send("No se encuentran los datos de la nevera");

//     a = req.body.toDeleteArr
//     console.log(typeof a[Symbol.iterator] === 'function' && typeof a === 'string');

//     res.send(typeof a[Symbol.iterator] === 'function' && !(typeof a === 'string'));

// });

module.exports = router;
