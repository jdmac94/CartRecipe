const config = require("config");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const Joi = require("joi");

const recetaSchema = new mongoose.Schema({
  usuario: {
    type: String,
    required: true,
  },
  titulo: {
    type: String,
    required: true,
  },
  dificultad: {
    type: Number,
    required: true,
  },
  tiempo: {
    type: String,
    required: true,
  },
  imagenes: {
    type: Array,
    default: [],
  },
  ingredientes: {
    type: Array,
    required: true,
    default: [],
  },
  pasos: {
    type: Array,
    required: true,
    default: [],
  },
  consejos: {
    type: Array,
    default: [],
  },
  categorias: {
    type: Array,
    default: [],
  },
  /*rating: {
    type: Array,
    default: [],
  }, */
  rating_num : {
    type: Number
  }
});

const Receta = mongoose.model("Receta", recetaSchema);

function validateReceta(receta) {
  const schema = {
    usuario: Joi.String().required(),
    // titulo: Joi.String().required(),
    // dificultad: Joi.String().required(),
    // tiempo: Joi.String.required(),
    /*ingredientes: Joi.String().required(),
    pasos: this.pasos,
    consejos: this.consejos,
    categorias: this.categorias,*/
  };
  return Joi.validate(receta, schema);
}

exports.Receta = Receta;
exports.Validate = validateReceta;
