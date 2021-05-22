const express = require("express");
const router = express.Router();
const fetch = require("node-fetch");

const { nowTimestamp } = require("../utils/localetime");
const { ProductV2 } = require("../models/product_v2");

router.post("/", async (req, res) => {
  if (!req.body.name) return res.send("Name required");
  if (!req.body.id) return res.send("Id required");
  const { name, id } = req.body;

  const data = await fetch(
    `https://world.openfoodfacts.org/api/v0/product/${id}.json`
  ).then((response) => response.json());

  if (data.status === 0) return res.send("Product not found");

  const result = await ProductV2.find({ name: name });
  if (!result) return res.send("There was an error, try later");
  if (result.length === 0) {
    const item = new ProductV2({
      name,
      products: [
        {
          id: nowTimestamp(),
          name: `${name} generico`,
          allergens_from_user: null,
          nutriscore_data: {},
          nova_group: null,
          imgs: "https://www.blackwallst.directory/images/NoImageAvailable.png",
        },
        {
          // id,
          // name: data.product.product_name_es,
          // allergens_tags: data.product.allergens_tags,
          // nutriscore_data: data.product.nutriscore_data,
          // nova_group: data.product.nova_group,
          // imgs: data.product.selected_images.front.display,
            id,
            product_name : data.product.product_name,
            product_name_es : data.product.product_name_es,
            nutriments : data.product.nutriments,
            ecoscore_grade : data.product.ecoscore_grade,
            nova_groups : data.product.nova_groups,
            quantity : data.product.quantity,
            nutriscore_grade : data.product.nutriscore_grade,
            ingredients_analysis_tags : data.product.ingredients_analysis_tags,
            allergens_tags : data.product.allergens_tags,
            traces : data.product.traces,
            traces_tags : data.product.traces_tags,
            ingredients_text_es : data.product.ingredients_text_es,

            imgs: data.product.selected_images.front.display,

        },
      ],
    });
    return res.send(await item.save());
  }
  const productsById = await ProductV2.find({ name, "products.id": id });
  if (productsById.length === 0) {
    const result = await ProductV2.findOneAndUpdate(
      { name },
      {
        $push: {
          products: {
            id,
            product_name : data.product.product_name,
            product_name_es : data.product.product_name_es,
            nutriments : data.product.nutriments,
            ecoscore_grade : data.product.ecoscore_grade,
            nova_groups : data.product.nova_groups,
            quantity : data.product.quantity,
            nutriscore_grade : data.product.nutriscore_grade,
            ingredients_analysis_tags : data.product.ingredients_analysis_tags,
            allergens_tags : data.product.allergens_tags,
            traces : data.product.traces,
            traces_tags : data.product.traces_tags,
            ingredients_text_es : data.product.ingredients_text_es,

            imgs: data.product.selected_images.front.display,

            /* 
            id,
            name: data.product.product_name_es,
            allergens_tags: data.product.allergens_tags,
            nutriscore_data: data.product.nutriscore_data,
            nova_group: data.product.nova_group,
            imgs: data.product.selected_images.front.display,
            */

            ////////////////////////////////////////////////////////
            // hablar con front para saber que campos usan 100% y evitar almacenar info innecesaria
            // ahora mismo rtabajan con estos datos, pero alguno sobra: 
          },
        },
      }
    );
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
        $group:
          {
            _id: "a",
            allerg: { $push: "$products.allergens_tags" },
          }
      },
      { $project: { name: 1, allerg: 1} }
    ]).exec();
  
  
    x = allergens[0].allerg[0];
    console.log(allergens[0].allerg[0]);

    arr1 = x[0];
  
    for (let i = 1; i < x.length; i++) {
      arr1 = arr1.filter(value => x[i].includes(value));
    }
  
    console.log(arr1);
  
    const genericProd = await ProductV2.find({ name : test });
  
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
      $group:
        {
          _id: "a",
          allerg: { $push: "$products.ingredients_analysis_tags" },
        }
    },
    { $project: { name: 1, allerg: 1} }
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


module.exports = router;
