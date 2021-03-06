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
  descripcion: {
    type: String,
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
  ingredientes_imp: {
    type: Array,
    default: [],
  },
  ingredientes_inter: {
    type: Array,
    default: [],
  },
  ingredientes_list: {
    type: Array,
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
  /*rating: {
    type: Array,
    default: [],
  }, */
  comensales : {
    type: Number
  },
  tags : {
    type: Array,
    default: [],
  },
  allergenList : {
    type: Array,
    default: [],
  },
  
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
