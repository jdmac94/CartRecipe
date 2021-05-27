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
  googleId: {
    type: String,
    default: null
  },
  alergias: {
    type: Array,
    default: [],
  },
  // trazas: {
  //   type: Array,
  //   default: [],
  // },
  palm_oil_free: {
    type: Boolean,
    default: false,
  },
  vegano: {
    type: Boolean,
    default: false,
  },
  vegetariano: {
    type: Boolean,
    default: false,
  },
  tags: {
    type: Array,
    default: [],
  },
  category_ban: {
    type: Array,
    default: [],
  },
  nivel_cocina: {
    type: Number,
    default: null,
  },
  sistema_internacional: {
    type: Boolean,
    default: true,
  },
  recetas_favs: {
    type: Array,
    default: [],
  },
});

usuarioSchema.methods.generateAuthToken = function () {
  const token = jwt.sign(
    {
      _id: this.id,
      correo: this.correo,
      nombre: this.nombre,
      alergias: this.alergias,
      dieta: this.dieta,
      tags: this.tags,
      nivel_cocina: this.nivel_cocina,
      sistema_internacional: this.sistema_internacional,
      recetas_favs: this.recetas_favs,
      vegano: this.vegano,
      vegetariano: this.vegetariano,
    },
    config.get("jwtPrivateKey")
  );
  return token;
};

const Usuario = mongoose.model("Usuario", usuarioSchema);

function validateUsuario(usuario) {
  const schema = {
    nombre: Joi.String().required(),
  };
  return Joi.validate(usuario, schema);
}

exports.Usuario = Usuario;
exports.Validate = validateUsuario;
