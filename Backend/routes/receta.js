const express = require("express");
const https = require("https");
const router = express.Router();

const { Receta } = require("../models/receta");
const { Nevera } = require("../models/nevera");
const auth = require("../middlewares/auth");


async function fillReceta(body, receta) {
    
    if (body.titulo)
        receta.titulo = body.titulo;
    else
        return res.status(400).send("No se ha enviado un título válido");

    if (body.dificultad)
        receta.dificultad = body.dificultad;
    else
        return res.status(400).send("No se ha enviado un nivel de dificultad válido");

    if (body.tiempo)
        receta.tiempo = body.tiempo;
    else
        return res.status(400).send("No se ha insertado una duración válida");

    if (body.ingredientes)
        receta.ingredientes = body.ingredientes;
    else
        return res.status(400).send("La receta debe coneter ingredietes válidos");

    if (body.pasos.length)
        receta.pasos = body.pasos;
    else
        return res.status(400).send("La receta debe contener pasos a seguir");

    if (body.consejos)
        receta.consejos = req.body.consejos;

    if (body.tags)
        receta.tags = body.tags;

    //receta.allergenList = ["alergeno0","alergeno1","alergeno2","alergeno3","alergeno4","alergeno5"]
    // antes de guardar la receta debe haber una función para extraer los alergenos de todos los ingredientes de la receta

    //receta.rating_num = 4; por defecto que sea undefined al no tener valoraciones

    return receta;
  }

router.get("/getAllRecetas", auth, async (req, res) => {

    let recetaList = await Receta.find().limit(10);

    // if (!recetaList) {
    //     let receta = new Receta();
    //     receta.usuario = "0";
    //     receta.titulo = "Jugo de aloe vera y miel";
    //     receta.dificultad = 1;
    //     receta.tiempo = "5:00";
    //     receta.ingredientes = [
    //         "6 cucharaditas de gel de aloe vera",
    //         "½ vaso de agua",
    //         "1 cucharadita de miel"
    //     ];
    //     receta.pasos = [
    //         "Saca la pulpa de aloe de vera con una cuchara y viértela dentro de la licuadora",
    //         "Incorpora los demás ingredientes y mézclalos muy bien.",
    //         "Consume este jugo en ayunas durante una semana completa, no más."
    //     ]
    //     receta.consejos = [
    //         "Para potenciar todavía más los efectos del jugo, puedes sustituir el agua por zumo de alguna de las mejores frutas para ir al baño, como la naranja, el limón o la piña."
    //     ];
    //     receta.rating_num = 3;
    //     const result = receta.save();    
    //     //return res.status(404).send("No hay recetas");
    //     recetaList = await Receta.find();
    //     res.send(recetaList);
    // }
    
    
    res.send(recetaList);    

});


router.get("/receta/:id", auth, async (req, res) => {

    let receta = await Receta.findOne({ _id: req.params.id });

    if (!receta)
      return res.status(404).send("La receta solicitada no existe");
    
    res.send(receta);    

});

router.post("/modReceta/:id", auth, async (req, res) => {

    let receta = await Receta.findOne({ _id: req.params.id });

    if (!receta)
      return res.status(404).send("La receta a modificar no existe");
    
    receta = fillReceta(req.body, receta);
    const result = receta.save();

    if (result)
        res.send(receta);
    
    res.status(404).send("Fallo en el proceso de actualizar la receta");

});

router.delete("/:id", auth, async (req, res) => {

    let receta = await Receta.findOne({ _id: req.params.id });

    if (!receta)
      return res.status(404).send("La receta a modificar no existe");
    
    
    const result = receta.save();

    if (result)
        res.send(receta);
    
    res.status(404).send("Fallo en el proceso de eliminar la receta");

});


router.get("/addRecetaFIXED", auth, async (req, res) => {

        let receta = new Receta();

        // var dict = {
        //     "manzana verde": "1", 
        //     "rodajas de papaya madura": "3",
        //     "vaso de agua": "1.5",
        //     "cucharadita de miel": "1"
        // };
        
        var dict = [
            { "1": ["manzana verde", "1"] }, 
            { "2": ["rodajas de papaya", "3"] },
            { "3": ["vaso de agua", "1.5"] },
            { "4": ["cucharadita de miel", "1"]}
        ];

        /*"ingredientes":[
        { "nombre": "manzana verde", "cantidad: "1" }, 
        { "nombre" : "rodajas de papaya", "cantidad" : "3"},
        ... ] */

        receta.usuario = "0";
        receta.titulo = "Jugo para el estreñimiento de manzana y papaya";
        receta.dificultad = 1;
        receta.descripcion = "Esto es una introducción";
        receta.tiempo = "5:00";
        receta.imagenes = [ 'https://www.laespanolaaceites.com/wp-content/uploads/2019/06/pizza-con-chorizo-jamon-y-queso-1080x671.jpg' ];
        receta.ingredientes = dict;

        receta.pasos = [
            "Trocea las frutas y agrégalas en el vaso de la licuadora junto al resto de los ingredientes.",
            "Mezcla hasta que no veas grumos."
        ]
        receta.consejos = [
            "Si lo prefieres, puedes agregar naranja a la receta, siguiendo estas indicaciones de nuestra receta de jugo de papaya, manzana y naranja.",
            "La manzana es una de esas frutas cuya piel beneficia la regulación del tránsito intestinal, de manera que lávala muy bien y prepara el jugo sin quitarla."
        ];

        receta.rating_num = 4;
        receta.tags = ["fruta", "batido", "zumo", "vegano", "vegetariano"];
        receta.allergenList = ["alergeno0","alergeno1","alergeno2","alergeno3","alergeno4","alergeno5"]
        const result = receta.save();
        //return res.status(404).send("No hay recetas");

        
        res.send(receta);

});


router.get("/addRecetaGalleta", auth, async (req, res) => {

    let receta = new Receta();

    // var dict = {
    //     "manzana verde": "1", 
    //     "rodajas de papaya madura": "3",
    //     "vaso de agua": "1.5",
    //     "cucharadita de miel": "1"
    // };

    // "Galletas de chocolate"
    // "Galletas maría"
    // "Panes"
    // "Pan rallado de trigo"
    // "Cereales y patatas"

    // var dict = [
    //     { "1": ["Galletas de chocolate", "1"] }, 
    //     { "2": ["Galletas maría", "1"] }, 
    //     { "3": ["Panes", "1"] }, 
    //     { "4": ["Pan rallado de trigo", "1"] }, 
    // ];


    var dict = ["Galletas de chocolate", "Galletas maría", "Panes", "Pan rallado de trigo", "unknown"];
    var qtty = [1,1,1,1];

    /*"ingredientes":[
    { "nombre": "manzana verde", "cantidad: "1" }, 
    { "nombre" : "rodajas de papaya", "cantidad" : "3"},
    ... ] */

    receta.usuario = "0";
    receta.titulo = "Comerse una galleta";
    receta.dificultad = 1;
    receta.descripcion = "veremos como se come una galleta";
    receta.tiempo = "1:00";
    receta.imagenes = [ 'https://st3.depositphotos.com/13184338/18422/i/1600/depositphotos_184221848-stock-photo-young-handsome-man-working-with.jpg' ];
    receta.ingredientes = dict;
    receta.ingre_Q = qtty;

    receta.pasos = [
        "abres el paquete",
        "te la comes",
        "fin, no tiene más."
    ]
    receta.consejos = [
        "No respires ni tragues a la vez que se lia",
    ];

    receta.rating_num = 5;
    receta.tags = ["fruta", "batido", "zumo", "vegano", "vegetariano"];
    receta.allergenList = ["alergeno0","alergeno1","alergeno2","alergeno3","alergeno4","alergeno5"]
    const result = receta.save();
    
    res.send(receta);

});

router.post("/addReceta", auth, async (req, res) => {

    let receta = new Receta();
    
    receta.usuario = "0";

    // receta.usuario = req.user._id;

    receta = fillReceta(req.body, receta);
    const result = receta.save();

    if (result)
        res.send(receta);

    res.status(404).send("Fallo en el proceso de añadir receta");

});


router.get("/getReceta/:id", auth, async (req, res) => {

    let receta = await Receta.findById(req.params.id)
    console.log("Buscando receta: " + req.params.id)
    if (!receta)
        return res.status(404).send("La receta solicitada no existe");
    res.send(receta)
});
module.exports = router;