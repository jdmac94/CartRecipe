const express = require("express");
const router = express.Router();
const passport = require("passport");
const bcriptjs = require("bcryptjs");
const _ = require("lodash");
var crypto = require('crypto');

const { Usuario } = require("../models/usuario");
const { Nevera } = require("../models/nevera");
const { DeleteLog } = require("../models/deleteLog");
const { sendMailPassword } = require("../utils/mailing");
const auth = require("../middlewares/auth");
const path = require("path");
var bodyParser = require('body-parser');

require("../passport-setup");


const emailRegEx = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; //revisar si se puede optimizar
router.use(passport.initialize());
//router.use(passport.session())

/*  modificar nivel de cocina 
    modificar alergenos
    definicion del tipo de alimentación
    gustos en cuanto recetas
    alimentos "baneados"
*/

///     MODIFICACIONES DE PREFERENCIAS    ///

router.post("/fillPreferences", auth, async (req, res) => {

    console.log(req.body);
    let user = await Usuario.findOne({ correo: req.user.correo });

    // definir dietas

    if (typeof req.body.palm_oil_free === "boolean")
        user.palm_oil_free = req.body.palm_oil_free;

    if (typeof req.body.is_vegano === "boolean")
        user.vegano = req.body.is_vegano;

    if (typeof req.body.is_vegetariano === "boolean")
        user.vegetariano = req.body.is_vegetariano;

    // definir alergias
    if (typeof req.body.allergenArray[Symbol.iterator] === "function") {
        user.alergias = req.body.allergenArray;// lo hacemos de bools o directamente strings? lo ultimo requerirá revisar los campos
        //si hay que revisar, es obtener de la bd los alergenos y comparar el array con cada elemento del allergenArray
    }

    // definir trazas
    // if (typeof req.body.traceArray[Symbol.iterator] === "function") {
    //     user.trazas = req.body.traceArray;
    // }

    // definir tags favs
    if (typeof req.body.tagArray[Symbol.iterator] === "function") {
        user.tags = req.body.tagArray;
    }
    
    // definir alimentos no deseados
    // if (typeof req.body.banArray[Symbol.iterator] === "function") {
    //     user.trazas = req.body.banArray;
    // }

    // cocina level
    if (req.body.level && typeof req.body.level === 'int')
        user.nivel_cocina = req.body.level;

    // sistema de unidades
        // hablar el tema

});

// [en:gluten, en:oats, en:crustaceans, en:eggs, en:fish, en:peanuts,
// en:soybeans, en:milk, en:nuts, en:celery, en:mustard, en:sesame seeds,
// en:sulphur dioxide and sulphites, en:lupin, en:molluscs]

router.post("/modAlergias", auth, async (req, res) => {
    console.log(req.body);
    let  = await Usuario.findOne({ correo: req.user.correo });

    if (typeof listedProds[Symbol.iterator] === "function") {
        user.alergias = req.body.allergenArray;// lo hacemos de bools o directamente strings? lo ultimo requerirá revisar los campos
        //si hay que revisar, es obtener de la bd los alergenos y comparar el array con cada elemento del allergenArray
    }

    const result = user.save();
    if(!result)
        return res.status(400).send("Error al intentar actualizar los alérgenos");

    res.send(result);
});


// "en:palm-oil-content-unknown",
// "en:palm-oil-free",
// "en:may-contain-palm-oil",
// "en:palm-oil",

// "en:vegan-status-unknown",
// "en:vegan",
// "en:maybe-vegan",
// "en:non-vegan",

// "en:vegetarian-status-unknown"
// "en:vegetarian"
// "en:maybe-vegetarian"
// "en:non-vegetarian"

router.post("/modDieta", auth, async (req, res) => {
    console.log(req.body);
    let user = await Usuario.findOne({ correo: req.user.correo });

    if (typeof req.body.palm_oil_free === "boolean")
        user.palm_oil_free = req.body.palm_oil_free;
    if (typeof req.body.is_vegano === "boolean")
        user.vegano = req.body.is_vegano;
    if (typeof req.body.is_vegetariano === "boolean")
        user.vegetariano = req.body.is_vegetariano;

    const result = user.save();
    if(!result)
        return res.status(400).send("Error al intentar actualizar los alérgenos");

    res.send(result);
});


router.post("/modTrazas", auth, async (req, res) => {
    console.log(req.body);
    let user = await Usuario.findOne({ correo: req.user.correo });

    // definir trazas
    if (typeof req.body.traceArray[Symbol.iterator] === "function") {
        user.trazas = req.body.traceArray;
    }

    const result = user.save();
    if(!result)
        return res.status(400).send("Error al intentar actualizar los alérgenos");

    res.send(result);
});


router.get("/recetario", auth, async (req, res) => {

    let recetario = await Usuario.findOne({ correo: req.user.correo },
        {
            recetas_favs: 1,
        });

    res.send(recetario);
});

//si existe lo borra, si no lo añade
router.get("/toggleInRecetario/:id", auth, async (req, res) => {

    let recetario = await Usuario.findOne({ correo: req.user.correo },
        {
            recetas_favs: 1,
        });
    
    delIndex = recetario.recetas_favs.indexOf(req.params.id);
  
    if (delIndex == -1) {
    
        recetario.recetas_favs.push(req.params.id);
        const result = recetario.save();

        if (result)
            return res.send("receta añadida a favoritos correctamente");
        else
            return res.status(400).send("Error al intentar añadir receta a favoritos");

      }
      else
        recetario.recetas_favs.splice(delIndex, 1);

    res.send(recetario);
});


///     MODIFICACIONES DE CUENTA    ///

router.put("/modIdFields", auth, async (req, res) => {

    let user = await Usuario.findOne({ correo: req.user.correo });
    var mail = req.body.correo.toLowerCase();

    if (emailRegEx.test(mail)) {
        let userCheck = await Usuario.findOne({ correo: mail });
        if (!userCheck) user.correo = mail;
        else return res.status(400).send("El correo ya está asociado a otra cuenta.");
    }

    if (req.body.password && typeof req.body.password === 'string')
        user.password = req.body.password;

    if (req.body.nombre && typeof req.body.nombre === 'string')
        user.nombre = req.body.nombre;
        
    if (req.body.apellido && typeof req.body.apellido === 'string')
        user.apellido = req.body.apellido;

    if (req.body.level && typeof req.body.level === 'int')
        user.nivel_cocina = req.body.level;

});

  router.get("/restoreForm/:id", (_, res) => {
    res.sendFile("restorePass.html", { root: path.join(__dirname, "../views") });
  });

  router.get("/public/scripts.js", (_, res) => {
    res.sendFile("scripts.js", { root: path.join(__dirname, "../public") });
  });

  router.post("/restorePassword", async (req, res) => {

    let mail = req.body.correo;
    console.log("RESTORING PWD FOR ACCOUNT: " + mail)

    let user = await Usuario.findOne({ correo: mail });

    if (!user || sendMailPassword(mail, user._id) == -1)
        return res.status(500).send("Error al intentar reestablecer la contraseña");
    
    res.send("Mail de recuperación enviado correctamente");
    
  });

  router.post("/restorePasswordReception/:id", async (req, res) => {
    console.log("RESTORING PWD RECEIVED");
    console.log(req.body);

    var user = await Product.findById(req.body.id);
    if (!user) return res.status(400).send("ERROR al procesar la nueva contraseña");
    console.log(user.correo);
    
    user.password = crypto.createHash('sha256').update(req.body.password).digest('hex');

    const result = user.save();
    if(!result)
        return res.status(400).send("ERROR al guardar la nueva contraseña");

    console.log(result);
    res.send("OK");
  });
  

//podemos pedirle al user que meta su password para asegurarse (?)

// PENDIENTE DE TESTEAR
router.get("/deleteAccount", auth, async (req, res) => {

    let mail = req.user.correo.toLowerCase();
    console.log("DELETING ACCOUNT: " + mail)

    let userDel = await Usuario.findOne({ correo: mail },
        {
            _id: 1,
        });

    if (!userDel) return res.status(400).send("Error, no se encuentra el usuario");

    let neveraDel = await Nevera.findOneAndDelete({ usuario: userDel._id });
    userDel = await Nevera.findOneAndDelete({ correo: mail });

    if (!userDel) return res.status(400).send("Error al intentar eliminar el usuario");
    
    res.send("Cuenta eliminada correctamente");
  });

  router.get("/deleteAccountMotive", async (req, res) => {

    console.log("DELETING ACCOUNT MOTIVE");
    
    delLog = new DeleteLog();
    delLog.motivo = req.body.motivo;

    const result = delLog.save();

    if (result)
        res.send("OK");
    
    res.status(404).send("Fallo en el proceso de actualizar la receta");
    
    res.send("Cuenta eliminada correctamente");
  });

  

module.exports = router;
