const express = require("express");
const router = express.Router();

const { Product } = require("../models/product");
const { checkImgFromAPI } = require("../utils/imageAPI");

const barcodeRegEx = /^[0-9]{13}$/;

router.get("/:id", async (req, res) => {
  console.log("getting producto (ruta product): " + req.params.id);
  const prodId = req.params.id;

  console.log(barcodeRegEx.test(prodId));

  let product;
  barcodeRegEx.test(prodId)
    ? (product = await Product.findById(prodId))
    : (product = await Product.find({ _keywords: prodId }).limit(10).exec(function(err, doc) { console.log(err); }));
  console.log("GETTING PROD: " + prodId);

  console.log(product);

  if (!product || (Array.isArray(product) && product.length == 0))
    return res.status(404).send("El producto solicitado no existe");

  product.imgs = await checkImgFromAPI(prodId);

  res.send(product);
});

module.exports = router;
