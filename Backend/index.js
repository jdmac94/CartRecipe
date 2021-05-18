const express = require("express");
const config = require("config");
require("dotenv").config();
const helmet = require("helmet");
const compression = require("compression");
const cors = require("cors");

require("./database");

const home = require("./routes/home");
const error = require("./routes/error");

const auth = require("./routes/auth");
const nevera = require("./routes/nevera");
const product = require("./routes/product");
const receta = require("./routes/receta");
const ajustesCuenta = require("./routes/accountSettings");
const productV2 = require("./routes/productV2");
const buscador = require("./routes/search");

const app = express();
app.use(express.static("public"));
app.use('/resource', express.static('public'))
app.use(express.json());
app.use(express.urlencoded());
app.use(helmet());
app.use(compression());
app.use(cors());

if (!config.get("jwtPrivateKey")) {
  console.error("FATAL ERROR: Can not read jwtPrivateKey");
  process.exit(1);
}

app.use("/", home);
app.use("/api/v1/auth", auth);
app.use("/api/v1/nevera", nevera);
app.use("/api/v1/product", product);
app.use("/api/v1/receta", receta);
app.use("/api/v1/accSettings", ajustesCuenta);
app.use("/api/v2/product", productV2);
app.use("/api/v2/search", buscador);
app.use("*", error);

const port = process.env.PORT || 9009;

app.listen(port, function () {
  console.log(`Server started on port ${port}`);
});
