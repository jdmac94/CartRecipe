const config = require("config");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const Joi = require("joi");

const neveraSchema = new mongoose.Schema({
  usuario: {
    type: String,
    required: true,
  },
  productos: {
    type: Array,
    default: [],
  },
});

const Nevera = mongoose.model("Nevera", neveraSchema);

function validateNevera(nevera) {
  const schema = {
    usuario: Joi.String().required(),
  };
  return Joi.validate(nevera, schema);
}

exports.Nevera = Nevera;
exports.Validate = validateNevera;
