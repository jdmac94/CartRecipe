const mongoose = require("mongoose");

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  products: {
    type: Array,
    required: true,
  },
});

const ProductV2 = mongoose.model("ProductV2", productSchema);

module.exports = { ProductV2 };
