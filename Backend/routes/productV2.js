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
          id,
          name: data.product.product_name_es,
          allergens_from_user: data.product.allergens_from_user,
          nutriscore_data: data.product.nutriscore_data,
          nova_group: data.product.nova_group,
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
            name: data.product.product_name_es,
            allergens_from_user: data.product.allergens_from_user,
            nutriscore_data: data.product.nutriscore_data,
            nova_group: data.product.nova_group,
            imgs: data.product.selected_images.front.display,
          },
        },
      }
    );
    return res.send(result);
  } else {
    return res.send("Item already in DB");
  }
});

module.exports = router;
