var mongoose = require("mongoose");
const express = require("express");
const router = express.Router();
const path = require("path");

router.get("/", (_, res) => {
  res.sendFile("index.html", { root: path.join(__dirname, "../views") });
});

module.exports = router;
