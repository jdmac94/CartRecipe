const express = require("express");
const https = require("https");
const router = express.Router();

const { Receta } = require("../models/receta");
const { Nevera } = require("../models/nevera");
const { ProductV2 } = require("../models/product_v2");
const auth = require("../middlewares/auth");

async function fillReceta(body, receta) {
  if (body.titulo) receta.titulo = body.titulo;
  else return res.status(400).send("No se ha enviado un título válido");

  if (body.dificultad) receta.dificultad = body.dificultad;
  else
    return res
      .status(400)
      .send("No se ha enviado un nivel de dificultad válido");

  if (body.tiempo) receta.tiempo = body.tiempo;
  else return res.status(400).send("No se ha insertado una duración válida");

  if (body.ingredientes) receta.ingredientes = body.ingredientes;
  else
    return res.status(400).send("La receta debe coneter ingredietes válidos");

  if (body.pasos.length) receta.pasos = body.pasos;
  else return res.status(400).send("La receta debe contener pasos a seguir");

  if (body.consejos) receta.consejos = req.body.consejos;

  if (body.tags) receta.tags = body.tags;

  //receta.allergenList = ["alergeno0","alergeno1","alergeno2","alergeno3","alergeno4","alergeno5"]
  // antes de guardar la receta debe haber una función para extraer los alergenos de todos los ingredientes de la receta

  //receta.rating_num = 4; por defecto que sea undefined al no tener valoraciones

  return receta;
}

router.get("/suggested", auth, async (req, res) => {
  const productos = await Nevera.find(
    { usuario: req.user._id },
    { productos: 1, _id: 0 }
  );
  if (productos) {
    const names = await ProductV2.find(
      { products: { $elemMatch: { id: { $in: productos } } } },
      { _id: 0, name: 1 }
    );
    console.log(names);
    if (names) {
      const recetas = await Receta.find({ ingredientes: { $in: names } });
      res.send(recetas);
    }
  }
  res.send("No hay nada");
});

router.get("/getAllergens", auth, async (req, res) => {
  // async function fetchAllergens(ingredients) {

  //formatear lista de ingredientes a array simple
  // var dict = [
  //   { 1: ["Aceite de Oliva Virgen Extra", "1"] },
  //   { 2: ["zanahoria", "3"] },
  // ];

  var test = "Nuez natural";
  const allergens = await ProductV2.find({ name: test });

  // const allergens = await ProductV2.aggregate([
  //   { $match: { name: test } },
  //   {
  //     $group:
  //       {
  //         _id: "a",
  //         allerg: { $push: "$products.allergens_tags" },
  //       }
  //   },
  //   { $project: { name: 1, allerg: 1} }
  // ]).exec();
  var a = allergens.productos[0].allergens_from_user;

  console.log(a);

  res.send(a);
  // }
});

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

router.get("/addRecetaFIXED", auth, async (req, res) => {
  let receta = new Receta();

  // var dict = {
  //     "manzana verde": "1",
  //     "rodajas de papaya madura": "3",
  //     "vaso de agua": "1.5",
  //     "cucharadita de miel": "1"
  // };

  var dict = [
    { 1: ["manzana verde", "1"] },
    { 2: ["rodajas de papaya", "3"] },
    { 3: ["vaso de agua", "1.5"] },
    { 4: ["cucharadita de miel", "1"] },
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
  receta.imagenes = [
    "https://www.laespanolaaceites.com/wp-content/uploads/2019/06/pizza-con-chorizo-jamon-y-queso-1080x671.jpg",
  ];
  receta.ingredientes = dict;

  receta.pasos = [
    "Trocea las frutas y agrégalas en el vaso de la licuadora junto al resto de los ingredientes.",
    "Mezcla hasta que no veas grumos.",
  ];
  receta.consejos = [
    "Si lo prefieres, puedes agregar naranja a la receta, siguiendo estas indicaciones de nuestra receta de jugo de papaya, manzana y naranja.",
    "La manzana es una de esas frutas cuya piel beneficia la regulación del tránsito intestinal, de manera que lávala muy bien y prepara el jugo sin quitarla.",
  ];

  receta.rating_num = 4;
  receta.tags = ["fruta", "batido", "zumo", "vegano", "vegetariano"];
  receta.allergenList = [
    "alergeno0",
    "alergeno1",
    "alergeno2",
    "alergeno3",
    "alergeno4",
    "alergeno5",
  ];
  const result = receta.save();
  //return res.status(404).send("No hay recetas");

  res.send(receta);
});

router.post("/addReceta", auth, async (req, res) => {
  let receta = new Receta();

  receta.usuario = "0";

  if (titulo) receta.titulo = req.body.titulo;
  else return res.status(400).send("No se ha enviado un título válido");

  if (req.body.dificultad) receta.dificultad = req.body.dificultad;
  else
    return res
      .status(400)
      .send("No se ha enviado un nivel de dificultad válido");

  if (req.body.tiempo) receta.tiempo = req.body.tiempo;
  else return res.status(400).send("No se ha insertado una duración válida");

  if (req.body.ingredientes) receta.ingredientes = req.body.ingredientes;
  else
    return res.status(400).send("La receta debe coneter ingredietes válidos");

  if (req.body.pasos.length) receta.pasos = req.body.pasos;
  else return res.status(400).send("La receta debe contener pasos a seguir");

  if (req.body.consejos) receta.consejos = req.body.consejos;

  //receta.rating_num = 4; por defecto que sea undefined al no tener valoraciones

  const result = receta.save();
  //if (result) res.send();

  res.send(receta);
});

router.get("/sugerida", auth, async (req, res) => {
  const recetas = [];
  const palabrasClaveNevera = [];
  const productos = await Nevera.find(
    { usuario: req.user._id },
    { _id: 0, productos: 1 }
  );

  productos.map(async (index) => {
    const palabrasClaveProducto = await Product.findOne(
      { _id: index },
      { generic_name: 1 }
    );
    palabrasClaveNevera.push(palabrasClaveProducto.split(""));
  });
  return palabrasClaveNevera.length !== 0
    ? await Receta.find({ ingredientes: { $regex: palabrasClaveNevera } })
    : [];
});

router.get("/getReceta/:id", auth, async (req, res) => {
  let receta = await Receta.findById(req.params.id);
  console.log("Buscando receta: " + req.params.id);
  if (!receta) return res.status(404).send("La receta solicitada no existe");
  res.send(receta);
});

router.get("/addRecetaFIXED1", auth, async (req, res) => {
  let receta = new Receta();
  //https://www.lagloriavegana.com/hummus-de-zanahoria/
  var dict = [
    { 1: ["garbanzos cocidos", "400", "gramos"] },
    { 2: ["diente de ajo", "1", ""] },
    { 3: ["zanahoria", "300", "gramos"] },
    { 4: ["aceite de oliva", "50", "gramos"] },
    { 5: ["zumo de limón", "1", "cucharada"] }, //1 cda de zumo limón
    { 6: ["aceite de oliva", "50", "gramos"] }, // 30 g de tahín tostado o 30 g de semillas de sésamo (triturar solas antes)
    { 7: ["Sal, comino y curry", "", "al gusto"] }, //Sal, comino y curry al gusto
  ];

  receta.usuario = "0";
  receta.titulo = "Hummus de zanahoria";
  receta.dificultad = 2;
  receta.descripcion =
    "¡Hola a tod@s! ¡¿Cuántas versiones de hummus os habré presentado hasta la fecha?! Desde luego, no me aburro de comerlo en sus distintas variedades, y mis invitad@s tampoco.\n\n Os traigo una opción para acompañar en cualquier pica-pica que se preste. ¡Y esta triunfa ¡seguro! A mi me gusta acompañarlo de sticks de zanahoria, pepino, tomate cherry, endibia…Pero los crackers, nachos y palitos también son una buena alternativa. Para gustos, colores. Y para hummus, ¡sabores!";

  receta.tiempo = "15:00";
  receta.imagenes = [
    "https://www.lagloriavegana.com/wp-content/uploads/2020/08/IMG_9275-1280x1280.jpg",
  ];
  receta.ingredientes = dict;

  receta.pasos = [
    "Lavamos y cortamos en rodajas las zanahorias.",
    "Las ponemos en un recipiente apto para microondas y cocinamos a máxima potencia durante 5 minutos (o hasta que estén tiernas). También se pueden hornear o hacer al vapor. Dejamos que se templen.",
    "Ponemos en el procesador todos los ingredientes y trituramos hasta conseguir una crema fina. ¡ESTÁ INCREÍBLE!",
  ];
  receta.consejos = [];

  receta.rating_num = 4;
  receta.tags = ["tag0", "tag1", "tag2", "tag3", "tag4"];
  receta.allergenList = [
    "alergeno0",
    "alergeno1",
    "alergeno2",
    "alergeno3",
    "alergeno4",
    "alergeno5",
  ];
  const result = receta.save();
  //return res.status(404).send("No hay recetas");

  res.send(receta);
});

router.get("/addRecetaFIXED2", auth, async (req, res) => {
  let receta = new Receta();
  //esta receta tiene dos secciones https://www.lagloriavegana.com/makis-vegetales/, podemos plantear el implenmetar eso como extra llegado el momento
  var dict = [
    { 1: ["arroz de sushi", "250", "mililitros"] },
    { 2: ["agua", "250", "mililitros"] },
    { 3: ["vinagre de arroz", "1", "cucharada"] },
    { 4: ["sal", "0.5", "cucharadita"] },
    { 5: ["azúcar", "1", "cucharadita"] },
    { 6: ["alga nori", "3", "láminas"] },
    { 7: ["mango", "0.5", ""] },
    { 8: ["aguacate", "0.5", ""] },
    { 9: ["mayonesa de wasabi casera", "3", "cucharada"] },
  ];

  receta.usuario = "0";
  receta.titulo = "Makis vegetales";
  receta.dificultad = 3;
  receta.descripcion =
    "¡Hola a tod@s! Hoy os traigo una receta más elaborada, pero que mola mucho hacer: makis caseros. Y es que desde Le Creuset me retaron a hacerlos usando su Cocotte Every. \n\n Para el interior, he usado mango y aguacate para que tuviera un sabor más refinado, combinados con la mayonesa de wasabi casera (el toque mágico). Para cortarlos, mejor hacerlo por mitades, como los japoneses.";

  receta.tiempo = "15:00";
  receta.imagenes = [
    "https://www.lagloriavegana.com/wp-content/uploads/2020/08/Makis-vegetales-1280x1280.jpg",
    "https://www.lagloriavegana.com/wp-content/uploads/2020/08/Makis-vegetales-2.jpg",
  ];
  receta.ingredientes = dict;

  receta.pasos = [
    "Ponemos en la Cocotte Every el agua y el arroz y encendemos el fuego. Cuando arranque a hervir tapamos la cacerola, bajamos el fuego al mínimo y cocemos durante 10 min. No levantamos la tapa en ningún momento.",
    "Pasados los 10 min apagamos el fuego y, sin levantar la tapa, dejamos reposar 15 min más.",
    "Mientras se hace este proceso, preparamos el aderezo mezclando el vinagre de arroz, la sal y el azúcar hasta que se diluya todo bien. Cortamos tb el mango y el aguacate en tiras.",
  ];
  receta.consejos = [];

  receta.rating_num = 4;
  receta.tags = ["tag0", "tag1", "tag2", "tag3", "tag4"];
  receta.allergenList = [
    "alergeno0",
    "alergeno1",
    "alergeno2",
    "alergeno3",
    "alergeno4",
    "alergeno5",
  ];
  const result = receta.save();
  //return res.status(404).send("No hay recetas");

  res.send(receta);
});

router.get("/addRecetaFIXED3", auth, async (req, res) => {
  let receta = new Receta();
  //https://www.lagloriavegana.com/one-pot-pasta-version-2-0/
  var dict = [
    { 1: ["Penne de Lentejas Rojas", "250", "gramos"] },
    { 2: ["cebolla", "1", ""] },
    { 3: ["calabacín pequeño", "1", ""] }, // maybe añadir campo de "artibutos", como "troceado", en dados,etc.
    { 4: ["champiñones", "150", "gramos"] },
    { 5: ["tomates cherry", "10", ""] },
    { 6: ["caldo de verduras", "750", "mililitros"] },
    {
      7: [
        "manteca de anacardos (o de nata vegetal o de tahini)",
        "2",
        "cucharada",
      ],
    },
    { 8: ["Sal, pimienta y aove", "", ""] },
  ];

  receta.usuario = "0";
  receta.titulo = "One Pot Pasta";
  receta.dificultad = 3;
  receta.descripcion =
    "¡Hola a tod@s!\n Hoy os comparto una receta de la que estoy muy orgullosa por dos motivos:\n - Me ha salido riquísima de la muerte.\n - Solo he encendido un fuego y ensuciado una olla para prepararla.\n El punto 2 es importante porque debemos ir haciendo pequeños gestos para ir fortaleciendo la sostenibilidad.\n\n Por mi parte, en esta receta:\n\n - He escogido verduras de temporada.\n - El caldo que he usado lo hago como ya sabéis aprovechando las peladuras de las verduras (troncos de brócoli, piel de las cebollas, hojas de apio…).\nSolo he ensuciado una olla y encendido un fuego.";

  receta.tiempo = "15:00";
  receta.imagenes = [
    "https://www.lagloriavegana.com/wp-content/uploads/2020/11/ONE-POT-pasta-foto-1280x1280.jpeg",
  ];
  receta.ingredientes = dict;

  receta.pasos = [
    "Pochamos la cebolla y el ajo.",
    "Incorporamos el resto de las verduras.",
    "Añadimos el caldo de verduras.",
    "Cuando arranque a hervir, echamos la pasta, removemos y dejamos cocer durante 9 minutos.",
    "Un minuto antes de apagar el fuego, le añadimos la manteca de anacardos (anacardos triturados hasta hacerlos crema) y removemos. Esto le va a aportar una cremosidad brutal.",
    "Apagamos el fuego y servimos con un poco de pimienta por encima.",
  ];
  receta.consejos = [];

  receta.rating_num = 4;
  receta.tags = ["tag0", "tag1", "tag2", "tag3", "tag4"];
  receta.allergenList = [
    "alergeno0",
    "alergeno1",
    "alergeno2",
    "alergeno3",
    "alergeno4",
    "alergeno5",
  ];
  const result = receta.save();
  //return res.status(404).send("No hay recetas");

  res.send(receta);
});

router.get("/addRecetaFIXED4", auth, async (req, res) => {
  let receta = new Receta();
  // https://www.lagloriavegana.com/bolitas-de-cacao-y-zanahoria/
  var dict = [
    { 1: ["nueces", "100", "gramos"] },
    { 2: ["dátiles", "100", "gramos"] },
    { 3: ["zanahoria", "80", "gramos"] },
    { 4: ["canela en polvo", "1", "cucharadita"] },
    { 5: ["cacao puro en polvo", "20", "gramos"] },
  ];

  /*
	100 g de nueces (o almendras, avellanas, pistachos, mezcla de varios…)
	100 g de dátiles
	80 g de zanahoria cruda pelada
	1 cucharadita de canela en polvo
	20 g de cacao puro en polvo
	
	*/

  receta.usuario = "0";
  receta.titulo = "Bolitas de cacao y Zanahoria";
  receta.dificultad = 3;
  receta.descripcion =
    "¡Hola a tod@s!  Feliz día de otoño familia. Os comparto la receta de las bolitas que tanto os gustaron cuando las compartí como idea de snack para Álvaro.\n\nSe las puse junto con fruta y al día siguiente me dijo: “mamá, ponme muchas bolitas”.\n\n¡Un triunfazo total!";

  receta.tiempo = "15:00";
  receta.imagenes = [
    "https://www.lagloriavegana.com/wp-content/uploads/2020/11/image00009-1280x1280.jpeg",
  ];
  receta.ingredientes = dict;

  receta.pasos = [
    "Si los dátiles están muy duros, los ponemos 10-15 min en remojo con agua caliente. Después colamos el agua y la desechamos. Otra opción sería meterlos 10 seg en el microondas para ablandarlos.",
    "Ponemos todos los ingredientes en el procesador o en la picadora y trituramos hasta conseguir una pasta. No hace falta que esté muy fina. ¡Ojo con pasarse triturando! que podría empezar a salir el aceite de los frutos secos y eso no es lo que queremos.",
    "Damos forma a las bolitas con las manos (del tamaño que queráis) y las rebozamos con semillas trituradas, con coco rallado, con cacao en polvo, con frutos secos picados… El rebozado nos ayudara a proteger el interior y a que queden más firmes.",
    "Las conservamos en el frigorífico. Aguantan 7-10 días aprox. Se pueden congelar.",
  ];
  receta.consejos = ["Podéis hacer las variaciones que queráis con esta base."];

  receta.rating_num = 4;
  receta.tags = ["tag0", "tag1", "tag2", "tag3", "tag4"];
  receta.allergenList = [
    "alergeno0",
    "alergeno1",
    "alergeno2",
    "alergeno3",
    "alergeno4",
    "alergeno5",
  ];
  const result = receta.save();
  //return res.status(404).send("No hay recetas");

  res.send(receta);
});

router.get("/addRecetaFIXED5", auth, async (req, res) => {
  let receta = new Receta();
  // https://www.lagloriavegana.com/fluffy-pancakes/
  var dict = [
    { 1: ["bebida de nuez de Borges", "125", "mililitros"] },
    { 2: ["Zumo de limón", "1", "cucharadita"] },
    { 3: ["aceite de oliva virgen extra", "1", "cucharadita"] }, // maybe añadir campo de "artibutos", como "troceado", en dados,etc.
    { 4: ["harina de trigo", "80", "gramos"] },
    { 5: ["lavadura", "10", "gramos"] },
    { 6: ["endulzante", "1", "cucharada"] },
    { 7: ["Sal", "", ""] },
    { 8: ["Canela en polvo", "", ""] },
  ];

  /*
	125 ml bebida de nuez de Borges
	1 cdta zumo de limón
	1 cdta de aceite de oliva virgen extra
	80 g harina de trigo (también sale con 40 trigo + 40 trigo sarraceno o con 80 trigo sarraceno)
	10 g levadura tipo Royal (1 cdta)
	1 cda del endulzante que quieras
	1 pizca de sal
	Canela en polvo
	
	*/

  receta.usuario = "0";
  receta.titulo = "Fluffy pancakes";
  receta.dificultad = 3;
  receta.descripcion =
    "¡Hola a tod@s! ¡Llegan las tortitas más esponjosas de la historia de la cocina vegana!\n\nHoy os comparto mi versión de los típicos fluffy pancakes americanos. Si los acompañáis de fruta, mermelada, chocolate o cualquier otro sirope, ¡vais a tocar el cielo!\n\nQuedan súper aireados y suaves, por lo que os recomiendo que probéis a hacerlos y me contéis si habéis notado la diferencia con los tradicionales.";

  receta.tiempo = "15:00";
  receta.imagenes = [
    "https://www.lagloriavegana.com/wp-content/uploads/2020/09/IMG_7722-1280x1280.jpg",
  ];

  receta.ingredientes = dict;

  receta.pasos = [
    "Mezclamos en un vaso la bebida de nuez con el zumo de limón. Removemos y dejamos reposar 5 minutos. Es normal que se corte; de hecho, lo que queremos conseguir es una burtermilk.",
    "Añadimos la cdta de aceite y removemos.",
    "En un bol mezclamos el resto de los ingredientes. Añadimos la buttermilk y removemos despacio (no queremos batir en exceso, sino lo justo para que quede integrado). Dejamos reposar la mezcla 5-10 min.",
    "Calentamos una sartén pequeña antiadherente y la engrasamos con un poco de aceite de oliva. Hacemos una a una las tortitas añadiendo un poco de masa a la sartén (lentamente para evitar que se extienda mucho). Dejamos que se haga 1 min y le damos la vuelta. Cocinamos 40 seg más aproximadamente. Hacemos la misma operación con el resto de la masa.",
    "Servimos con fruta, nueces y chocolate derretido por encima.",
  ];
  receta.consejos = [];

  receta.rating_num = 4;
  receta.tags = ["tag0", "tag1", "tag2", "tag3", "tag4"];
  receta.allergenList = [
    "alergeno0",
    "alergeno1",
    "alergeno2",
    "alergeno3",
    "alergeno4",
    "alergeno5",
  ];
  const result = receta.save();
  //return res.status(404).send("No hay recetas");

  res.send(receta);
});

router.get("/addRecetaFIXED6", auth, async (req, res) => {
  let receta = new Receta();
  // https://www.lagloriavegana.com/albondigas-veganas-al-estilo-de-mi-abuelo/
  var dict = [
    { 1: ["albóndigas Heura", "20", ""] },
    { 2: ["dientes de ajo", "4", ""] },
    { 3: ["pimentón dulce", "1", "cucharadita"] },
    { 4: ["tomate triturado", "700", "gramos"] },
    { 5: ["Sal", "", ""] },
    { 6: ["Aceite de oliva", "", ""] },
    { 7: ["Harina", "", ""] },
  ];

  /*
	450-500 g de hamburguesas tipo Beyond, Heura, Lidl… (las que se asemejan a carne) o 20 albóndigas Heura.
	4 dientes de ajo
	1 cdta de pimentón dulce
	700 g de tomate triturado de lata o de bote
	Sal
	Aceite de oliva
	Harina de cualquier uso
	
	*/

  receta.usuario = "0";
  receta.titulo = "Albóndigas veganas al estilo de mi abuelo";
  receta.dificultad = 3;
  receta.descripcion =
    "¡Hola a tod@s! ¡Llegan las tortitas más esponjosas de la historia de la cocina vegana!\n\nHoy os comparto mi versión de los típicos fluffy pancakes americanos. Si los acompañáis de fruta, mermelada, chocolate o cualquier otro sirope, ¡vais a tocar el cielo!\n\nQuedan súper aireados y suaves, por lo que os recomiendo que probéis a hacerlos y me contéis si habéis notado la diferencia con los tradicionales.";

  receta.tiempo = "15:00";
  receta.imagenes = [
    "https://www.lagloriavegana.com/wp-content/uploads/2020/09/IMG_9908-1280x1280.jpg",
  ];

  receta.ingredientes = dict;

  receta.pasos = [
    "Desmenuzamos las hamburguesas y les añadimos un ajo bien picado o trinchado. Mezclamos todo bien. Podemos echar también un poco de perejil picado. Si usamos las albóndigas de Heura este paso no es necesario.",
    "Les damos forma de albóndigas y las pasamos por harina (yo he usado de trigo, pero podéis usar cualquiera).",
    "En una cacerola honda ponemos un fondito de aceite de oliva y freímos los 3 ajos restantes. Los sacamos y los reservamos en el mortero.",
    "Freímos las albóndigas en el mismo aceite y las sacamos sobre papel absorbente.",
    "Bajamos el fuego y echamos una cucharadita de pimentón dulce sin dejar de remover. Incorporamos de inmediato las salsas de tomate, removemos y tapamos la cacerola.",
    "Machacamos, junto con un poco de sal, el ajo que teníamos reservado y lo echamos en la cacerola. Añadimos también las albóndigas.",
    "Dejamos que se cocine todo durante 25-30 minutos a fuego lento y con la tapa puesta. Removemos de vez en cuando y lo ajustamos de sal.",
    "Apartamos del fuego y servimos con unas patatas horneadas o con arroz hervido.",
  ];
  receta.consejos = [
    "Si las hacemos de un día para otro o, por lo menos, las dejamos reposar un par de horas antes de comerlas, estarán aún más ricas.",
  ];

  receta.rating_num = 4;
  receta.tags = ["tag0", "tag1", "tag2", "tag3", "tag4"];
  receta.allergenList = [
    "alergeno0",
    "alergeno1",
    "alergeno2",
    "alergeno3",
    "alergeno4",
    "alergeno5",
  ];
  const result = receta.save();
  //return res.status(404).send("No hay recetas");

  res.send(receta);
});

module.exports = router;
