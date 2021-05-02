const express = require("express");
const router = express.Router();

const { Product } = require("../models/product");
const { checkImgFromAPI } = require("../utils/imageAPI");

const barcodeRegEx = /^[0-9]{13}$/;

router.get("/:id", async (req, res) => {
  const prodId = req.params.id;
  let product;
  barcodeRegEx.test(prodId)
    ? (product = await Product.findById(prodId))
    : (product = await Product.find({ _keywords: prodId }).limit(10));
  console.log("GETTING PROD: " + prodId);

  if (!product)//revisar el tema del length
    return res.status(404).send("El producto solicitado no existe");

  product.imgs = await checkImgFromAPI(prodId);

  res.send(product);
});

module.exports = router;
