const express = require("express");
const router = express.Router();
const path = require("path");

router.get("/", (_, res) => {
  res
    .status(404)
    .sendFile("error.html", { root: path.join(__dirname, "../views") });
});

module.exports = router;
