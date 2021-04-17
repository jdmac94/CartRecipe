const mongoose = require("mongoose");
const config = require("config");

mongoose
  .connect(config.get("db"), {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Connected to mongo!"))
  .catch(() => console.log("Error"));
