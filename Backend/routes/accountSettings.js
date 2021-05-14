const express = require("express");
const router = express.Router();
const passport = require("passport");
const bcriptjs = require("bcryptjs");
const _ = require("lodash");

const { Usuario } = require("../models/usuario");
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
// [palm-oil, vegetarian, vegan]

router.post("/modDieta", auth, async (req, res) => {
    console.log(req.body);
    let  = await Usuario.findOne({ correo: req.user.correo });
// [palm-oil, vegetarian, vegan], array de bools o bien los campos con el valor
    user.dieta = req.body.dietArray;
    // if (typeof req.body.palm_oil_free === "boolean")
        // user.dieta.palm_oil_free = req.body.palm_oil_free;
    // if (typeof req.body.is_vegano === "boolean")
        // user.dieta.vegano = req.body.is_vegano;
    // if (typeof req.body.is_vegetariano === "boolean")
        // user.dieta.vegetariano = req.body.is_vegetariano;

    const result = user.save();
    if(!result)
        return res.status(400).send("Error al intentar actualizar los alérgenos");

    res.send(result);
});

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

router.post("/fillPreferences", auth, async (req, res) => {
    console.log(req.body);

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

router.post("/restorePassword", async (req, res) => {

    let mail = req.body.correo;
    console.log("RESTORING PWD FOR ACCOUNT: " + mail)

    let user = await Usuario.findOne({ correo: mail });

    if (!user || sendMailPassword(mail) == -1)
        return res.status(500).send("Error al intentar reestablecer la contraseña");
    
    res.send("Mail de recuperación enviado correctamente");
    
  });

  router.get("/restoreForm", (_, res) => {
    res.sendFile("restorePass.html", { root: path.join(__dirname, "../views") });
  });

  router.post("/restorePasswordReception", async (req, res) => {
    console.log("RESTORING PWD RECEIVED");
    console.log(req);
    // res.send(req);
    res.status(400).send("mal");
  });

//podemos pedirle al user que meta su password para asegurarse (?)
router.get("/deleteAccount", auth, async (req, res) => {

    let mail = req.user.correo.toLowerCase();
    console.log("DELETING ACCOUNT: " + mail)

    let userDel = await Usuario.findOneAndDelete({ correo: mail });
    //TO-DO: eliminar la nevera de dicho usuario
    if (!userDel) return res.status(400).send("Error al intentar eliminar el usuario");
    
    res.send("Cuenta eliminada correctamente");
  });

  router.get("/deleteAccountMotive", async (req, res) => {

    console.log("DELETING ACCOUNT MOTIVE")
    
    delLog = new DeleteLog()
    delLog.motivo = req.body.motivo;

    const result = delLog.save();

    if (result)
        res.send("OK");
    
    res.status(404).send("Fallo en el proceso de actualizar la receta");
    
    res.send("Cuenta eliminada correctamente");
  });

  

module.exports = router;
