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

    var fetchResult = await Receta.find({ tags: [re] }).limit(10);
    
    if (!fetchResult)
      return res.status(404).send("No ha resultados coincidentes");

    res.send(fetchResult);
  });

  router.get("/products/:search", async (req, res) => {

    console.log("regex test");
    var replace = ".*" + req.params.search.trim() + ".*";
    var re = new RegExp(replace, "i");

    var fetchResult = await Product.find({ $or: [{ product_name: re }, { product_name_es: re }] }).limit(10);//to test
    
    if (!fetchResult)
      return res.status(404).send("No ha resultados coincidentes");

    res.send(fetchResult);
  });


// router.get("/products/:search", auth, async (req, res) => {
    
//     console.log("GETTING NEVERA");
//     let fetching = await Receta.findOne({ titulo: {"name": "a"} });
    
//     var replace = "regex\\d";
//     var re = new RegExp(replace,"g");

//     if (!nevera)
//       return res.status(404).send("No se encuentran los datos de la nevera");
  
//     let prodArray = nevera.productos;
//     let listedProds = await Product.find(
//       { _id: { $in: prodArray } },
//       {
//         product_name: 1,
//         product_name_es: 1,
//         nutriments: 1,
//         ecoscore_grade: 1,
//         nova_groups: 1,
//         quantity: 1,
//         nutriscore_grade: 1,
//         // ingredients: 1,
//         ingredients_analysis_tags: 1,
//         allergens_tags: 1,
//         traces: 1,
//         traces_tags: 1,
//         ingredients_text_es: 1,
//       }
//     );
  
//     for (let element of listedProds) {
//       element.imgs = await checkImgFromAPI(element._id);
//     }
  
//     res.send(listedProds);
//   });

//   router.get("/recipes/:search", auth, async (req, res) => {
    
//     console.log("GETTING NEVERA");
//     let fetching = await Receta.find({ titulo: {"name": "a"} });
  
//     if (!nevera)
//       return res.status(404).send("No se encuentran los datos de la nevera");
  
//     let prodArray = nevera.productos;
//     let listedProds = await Product.find(
//       { _id: { $in: prodArray } },
//       {
//         product_name: 1,
//         product_name_es: 1,
//         nutriments: 1,
//         ecoscore_grade: 1,
//         nova_groups: 1,
//         quantity: 1,
//         nutriscore_grade: 1,
//         // ingredients: 1,
//         ingredients_analysis_tags: 1,
//         allergens_tags: 1,
//         traces: 1,
//         traces_tags: 1,
//         ingredients_text_es: 1,
//       }
//     );
  
//     for (let element of listedProds) {
//       element.imgs = await checkImgFromAPI(element._id);
//     }
  
//     res.send(listedProds);
//   });

module.exports = router;