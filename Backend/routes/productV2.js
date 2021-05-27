const express = require("express");
const router = express.Router();
const fetch = require("node-fetch");

const { nowTimestamp } = require("../utils/localetime");
const { ProductV2 } = require("../models/product_v2");

router.post("/", async (req, res) => {
  if (!req.body.name) return res.send("Name required");
  if (!req.body.id) return res.send("Id required");
  if (!req.body.category) return res.send("Category required");
  const { name, id, category } = req.body;

  const data = await fetch(
    `https://world.openfoodfacts.org/api/v0/product/${id}.json`
  ).then((response) => response.json());

  if (data.status === 0) return res.send("Product not found");

  const result = await ProductV2.find({ product_name: `${name} generico` });
  if (!result) return res.send("There was an error, try later");
  if (result.length === 0) {
    const itemGen = new ProductV2({
      id: nowTimestamp().toString(),
      product_name: `${name} generico`,
      product_name_es: `${name} generico`,
      allergens_tags: null,
      nutriscore_grade: null,
      nova_groups: null,
      imgs: {
        es: "https://www.blackwallst.directory/images/NoImageAvailable.png",
      },
    });

    const resu = await itemGen.save();
    if (!resu) return res.status(500).send("Error al guardar el producto");

    const itemSpecific = new ProductV2({
      id,
      product_name: data.product.product_name,
      product_name_es: data.product.product_name_es,
      nutriments: data.product.nutriments,
      ecoscore_grade: data.product.ecoscore_grade,
      nova_groups: data.product.nova_groups,
      quantity: data.product.quantity,
      nutriscore_grade: data.product.nutriscore_grade,
      ingredients_analysis_tags: data.product.ingredients_analysis_tags,
      allergens_tags: data.product.allergens_tags,
      traces: data.product.traces,
      traces_tags: data.product.traces_tags,
      ingredients_text_es: data.product.ingredients_text_es,
      inner_ingredient: name,
      inner_category: category,
      imgs: data.product.selected_images.front.display,
    });

    const resu2 = await itemSpecific.save();
    if (!resu2) return res.status(500).send("Error al guardar el producto");

    return res.send(resu2);
  }

  const productsById = await ProductV2.find({ inner_ingredient: name, id: id });
  if (productsById.length === 0) {
    const result = new ProductV2({
      id,
      product_name: data.product.product_name,
      product_name_es: data.product.product_name_es,
      nutriments: data.product.nutriments,
      ecoscore_grade: data.product.ecoscore_grade,
      nova_groups: data.product.nova_groups,
      quantity: data.product.quantity,
      nutriscore_grade: data.product.nutriscore_grade,
      ingredients_analysis_tags: data.product.ingredients_analysis_tags,
      allergens_tags: data.product.allergens_tags,
      traces: data.product.traces,
      traces_tags: data.product.traces_tags,
      ingredients_text_es: data.product.ingredients_text_es,
      inner_ingredient: name,
      imgs: data.product.selected_images.front.display,
    });

    await result.save();
    return res.send(result);
  } else {
    return res.send("Item already in DB");
  }
});

//revisar en base al cambio de campos
async function fetchAllergens(product) {
  // var test = "Nuez natural";

  const allergens = await ProductV2.aggregate([
    //{ $match: { name: test } },
    { $match: { name: product } },
    {
      $group: {
        _id: "a",
        allerg: { $push: "$products.allergens_tags" },
      },
    },
    { $project: { name: 1, allerg: 1 } },
  ]).exec();

  x = allergens[0].allerg[0];
  console.log(allergens[0].allerg[0]);

  arr1 = x[0];

  for (let i = 1; i < x.length; i++) {
    arr1 = arr1.filter((value) => x[i].includes(value));
  }

  console.log(arr1);

  const genericProd = await ProductV2.find({ name: test });

  genericProd.allergens_from_user = arr1;

  genericProd.save();

  res.send(arr1);
}

async function fetchDiet(product) {
  // var test = "Nuez natural";

  // const allergens = await ProductV2.aggregate([
  //   { $match: { name: product } },
  //   {
  //     $group:
  //       {
  //         _id: "a",
  //         allerg: { $push: "$products.allergens_tags" },
  //       }
  //   },
  //   { $project: { name: 1, allerg: 1} }
  // ]).exec();

  const allergens = await ProductV2.aggregate([
    { $match: { name: product } },
    {
      $group: {
        _id: "a",
        allerg: { $push: "$products.ingredients_analysis_tags" },
      },
    },
    { $project: { name: 1, allerg: 1 } },
  ]);

  // x = allergens[0].allerg[0];
  // console.log(x);

  // arr1 = x[0];

  // for (let i = 1; i < x.length; i++) {
  //   arr1 = arr1.filter(value => x[i].includes(value));
  // }

  console.log(allergens);

  // const genericProd = await ProductV2.find({ name : test });

  // genericProd.allergens_from_user = arr1;

  // genericProd.save();

  res.send(allergens);
}

// router.post("/getCategories", async (req, res) => {
//   res.send(allergens);
// });

module.exports = router;
