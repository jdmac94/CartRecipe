const config = require("config");
const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
const Joi = require("joi");

const usuarioSchema = new mongoose.Schema({
  nombre: {
    type: String,
    required: true,
  },
  apellido: {
    type: String,
    required: true,
  },
  correo: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  alergias: {
    type: Array,
    default: [],
  },
  dieta: {
    type: Array,
    default: [],
  },
  tags: {
    type: Array,
    default: [],
  },
  nivel_cocina: {
    type: Number,
    default: null,
  },
  sistema_unidades: {
    type: String,
    default: "sist_int",
  },
  recetas_favs: {
    type: Array,
    default: [],
  },
});

usuarioSchema.methods.generateAuthToken = function () {
  const token = jwt.sign({
    _id: this.id,
    correo: this.correo,
    nombre: this.nombre,
    alergias: this.alergias,
    dieta: this.dieta,
    tags: this.tags,
    nivel_cocina: this.nivel_cocina,
    sistema_unidades: this.sistema_unidades,
    recetas_favs: this.recetas_favs,
  });
  return token;
};

const Usuario = mongoose.model("Usuario", userSchema);

function validateUsuario(usuario) {
  const schema = {
    nombre: Joi.String().required(),
  };
  return Joi.validate(usuario, schema);
}

exports.Usuario = Usuario;
exports.Validate = validateUsuario;
