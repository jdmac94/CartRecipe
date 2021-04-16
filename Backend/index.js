const express = require("express");
const config = require("config");
const helmet = require("helmet");
const compression = require("compression");
const cors = require("cors");

const home = require("./routes/home");
const error = require("./routes/error");

const app = express();
app.use(express.static("public"));
app.use(express.json());
app.use(helmet());
app.use(compression());
app.use(cors());

if (!config.get("jwtPrivateKey")) {
  console.error("FATAL ERROR: Can not read jwtPrivateKey");
  process.exit(1);
}

app.use("/", home);

app.use("*", error);

const port = process.env.PORT || 9009;

app.listen(port, function () {
  console.log(`Server started on port ${port}`);
});
