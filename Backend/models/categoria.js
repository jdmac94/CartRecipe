const config = require("config");
const mongoose = require("mongoose");
const Joi = require("joi");

const categoriaSchema = new mongoose.Schema({
  en: {
    type: String,
    required: true,
  },
  es: {
    type: String,
    required: true,
  }
});

const Categoria = mongoose.model("Categoria", categoriaSchema);

function validateCategoria(categoria) {
  const schema = {
    usuario: Joi.String().required(),
  };
  return Joi.validate(categoria, schema);
}

exports.Categoria = Categoria;
exports.Validate = validateCategoria;
