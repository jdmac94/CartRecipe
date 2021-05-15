const express = require("express");
const router = express.Router();
const { Usuario } = require("../models/usuario");
const { Nevera } = require("../models/nevera");
const _ = require("lodash");
const passport = require("passport");
require("../passport-setup");
const auth = require("../middlewares/auth");

const emailRegEx = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; //revisar si se puede optimizar
router.use(passport.initialize());
//router.use(passport.session())

router.post("/login", async (req, res) => {

  console.log("LOGGIN IN");
  console.log(req.body);
  let user = await Usuario.findOne({ correo: req.body.correo });
  if (!user) return res.status(400).send("Email incorrectos");
  console.log(user.correo);
  
  if (req.body.password != user.password)
    return res.status(400).send("Email o contraseña incorrectos");

  const token = user.generateAuthToken();
  res.send(token);
});

router.post("/register", async (req, res) => {

  console.log("REGISTER");
  console.log(req.body);
  
  var mail = req.body.correo.toLowerCase();

  if (!emailRegEx.test(mail))
    return res.status(400).send("El correo introducido no tiene un formato válido.");

  let user = await Usuario.findOne({ correo: mail });
  if (user)
    return res.status(400).send("El usuario ya se encuentra registrado.");
  user = new Usuario(
    _.pick(req.body, ["nombre", "apellido", "correo", "password"])
  );

  user.correo = mail;
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

//podemos pedirle al user que meta su password para asegurarse (?)
router.post("/deleteAccount", auth, async (req, res) => {

  let mail = req.user.correo.toLowerCase();
  console.log("DELETING ACCOUNT: " + mail)
  
  // let userGettin = await Usuario.findOne({ correo: req.user.correo });
  
  // if (!userGettin) return res.status(400).send("Email incorrectos");

  //let userDel = await Usuario.findByIdAndDelete(userGettin._id);
  let userDel = await Usuario.findOneAndDelete({ correo: mail });

  if (!userDel) return res.status(400).send("Error al intentar eliminar el usuario");

  // if (req.body.password != user.password)
  //   return res.status(400).send("Email o contraseña incorrectos");

  res.send("Cuenta eliminada correctamente");
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
