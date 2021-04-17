const express = require("express");
const router = express.Router();
const bcriptjs = require("bcryptjs");
const { Usuario } = require("../models/usuario");
const _ = require("lodash");

const authMiddle = require("../middlewares/auth");

router.post("/login", authMiddle, async (req, res) => {
  let user = await Usuario.findOne({ email: req.body.email });
  if (!user) return res.status(400).send("Email o contraseña incorrectos");
  console.log(req.user.correo);
  const validPassword = await bcriptjs.compare(
    req.body.password,
    user.password
  );
  if (!validPassword)
    return res.status(400).send("Email o contraseña incorrectos");

  const token = user.generateAuthToken();
  res.send(token);
});

router.post("/register", async (req, res) => {
  let user = await Usuario.findOne({ email: req.body.email });
  if (user)
    return res.status(400).send("El usuario ya se encuentra registrado.");
  user = new Usuario(
    _.pick(req.body, ["nombre", "apellido", "correo", "password"])
  );
  const salt = await bcriptjs.genSalt(10);
  user.password = await bcriptjs.hash(user.password, salt);
  const result = user.save();
  if (result) res.send(user.generateAuthToken());
});

module.exports = router;
