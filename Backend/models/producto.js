const config = require("config");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const Joi = require("joi");

const productoSchema = new mongoose.Schema({
  usuario: {
    type: String,
    required: true,
  },
  productos: {
    type: Array,
    default: [],
  },
});

const Producto = mongoose.model("Producto", productoSchema);

function validateProducto(producto) {
  const schema = {
    usuario: Joi.String().required(),
  };
  return Joi.validate(producto, schema);
}

exports.Producto = Producto;
exports.Validate = validateProducto;
