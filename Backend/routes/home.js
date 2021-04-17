var mongoose = require("mongoose");
const express = require("express");
const router = express.Router();
const path = require("path");

//////////////////////////////////////////
var Nevera = require('../models/nevera');

const MyModel = Nevera.Nevera;

mongoose.connect('mongodb://localhost:27017/CartRecipe', {useNewUrlParser: true});
//////////////////////////////////////////
router.get("/", (_, res) => {
  res.sendFile("index.html", { root: path.join(__dirname, "../views") });
});


//////////////////////////////////////////
router.get("/nevera/", (_, res) => {
  
  // var allNevera = MyModel.find();

  // console.log(allNevera);

  mongoose.connection.db.listCollections().toArray(
    function (err, names) {
      console.log(names); // [{ name: 'dbname.myCollection' }]
      module.exports.Collection = names;
    }
  );

  res.sendFile("test.html", { root: path.join(__dirname, "../views") });

});
//////////////////////////////////////////

module.exports = router;
