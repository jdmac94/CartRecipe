const express = require("express");
const router = express.Router();
const bcriptjs = require("bcryptjs");
const { Usuario } = require("../models/usuario");
const { Nevera } = require("../models/nevera");
const _ = require("lodash");
const passport = require("passport");
require("../passport-setup");

const emailRegEx = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; //revisar si se puede optimizar
router.use(passport.initialize());
//router.use(passport.session())

router.post("/login", async (req, res) => {
  let user = await Usuario.findOne({ correo: req.body.email });
  if (!user) return res.status(400).send("Email incorrectos");
  console.log(req.user.correo);
  // const validPassword = await bcriptjs.compare(
  //   req.body.password,
  //   user.password
  // );
  
  if (req.body.password != user.password)
    return res.status(400).send("Email o contraseña incorrectos");

  const token = user.generateAuthToken();
  res.send(token);
});

router.post("/register", async (req, res) => {

  if (!emailRegEx.test(req.body.correo))
    return res.status(400).send("El correo introducido no tiene un formato válido.");

  let user = await Usuario.findOne({ correo: req.body.correo });
  if (user)
    return res.status(400).send("El usuario ya se encuentra registrado.");
  user = new Usuario(
    _.pick(req.body, ["nombre", "apellido", "correo", "password"])
  );
  //const salt = await bcriptjs.genSalt(10);
  //user.password = await bcriptjs.hash(user.password, salt);
  const result = await user.save();
  
  if (result) {
    neveraUser = new Nevera();
    neveraUser.usuario = result._id;
    const resultNevera = neveraUser.save();
    if (!resultNevera)
      return res.status(500).send("Fallo al asignar la nevera al usuario");
    res.send(user.generateAuthToken());
  }
});

router.get(
  "/auth/google",
  passport.authenticate("google", { scope: ["profile"] })
);

router.get(
  "/auth/google/callback",
  passport.authenticate("google", {
    successRedirect: "/auth/google/success",
    failureRedirect: "/auth/google/failure",
  })
);

router.get("/auth/google/failure", async (req, res) => {
  res.send("test google auth FAILED");
});

router.get("/auth/google/success", async (req, res) => {
  res.send("test google auth SUCCEEDED");
});

module.exports = router;
