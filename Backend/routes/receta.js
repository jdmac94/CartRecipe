const express = require("express");
const https = require("https");
const router = express.Router();
const { Receta } = require("../models/receta");


router.get("/getAllRecetas", async (req, res) => {

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


router.get("/addRecetaFIXED", async (req, res) => {

        let receta = new Receta();
        receta.usuario = "0";
        receta.titulo = "Jugo para el estreñimiento de manzana y papaya";
        receta.dificultad = 1;
        receta.tiempo = "5:00";
        receta.ingredientes = [
            "1 manzana verde",
            "3 rodajas de papaya madura",
            "½ vaso de agua",
            "1 cucharadita de miel"
        ];
        receta.pasos = [
            "Trocea las frutas y agrégalas en el vaso de la licuadora junto al resto de los ingredientes.",
            "Mezcla hasta que no veas grumos."
        ]
        receta.consejos = [
            "Si lo prefieres, puedes agregar naranja a la receta, siguiendo estas indicaciones de nuestra receta de jugo de papaya, manzana y naranja.",
            "La manzana es una de esas frutas cuya piel beneficia la regulación del tránsito intestinal, de manera que lávala muy bien y prepara el jugo sin quitarla."
        ];
        receta.rating_num = 4;
        const result = receta.save();    
        //return res.status(404).send("No hay recetas");
        
        res.send(receta);

});


router.get("/addReceta", async (req, res) => {

    receta.usuario = "0";
    receta.titulo = res.body.titulo;
    let receta = new Receta();
    receta.usuario = "0";
    receta.titulo = res.body.titulo;
    receta.dificultad = res.body.dificultad;
    receta.tiempo = res.body.tiempo;
    receta.ingredientes = res.body.ingredientes;
    receta.pasos = res.body.pasos;
    receta.consejos = res.body.consejos;
    receta.rating_num = 4;

    const result = receta.save();    
    //if (result) res.send();

    res.send(receta);

});


router.get("/getReceta", async (req, res) => {

    let receta = await Receta.findById(req.body._id)
    if (!receta)
        return res.status(404).send("La receta solicitada no existe");
    res.send(receta)
});
module.exports = router;