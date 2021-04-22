const config = require("config");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const Joi = require("joi");

const productSchema = new mongoose.Schema({
  _id: { 
    type: String 
  },
  id: {
    type: String,
    required: true,
  },
  code: {
    type: String,
    required: true,
  },
  _keywords: {
    type: Array,
    default: [],
  },
  ingredients: {
    type: Array,
    default: [],
  },
  imgs: {
    type: Array,
    default: [],
  }
});

const Product = mongoose.model("Product", productSchema);

function validateProduct(product) {
  const schema = {
    usuario: Joi.String().required(),
  };
  return Joi.validate(product, schema);
}

exports.Product = Product;
exports.Validate = validateProduct;
