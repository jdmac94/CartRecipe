const mongoose = require("mongoose");
mongoose.set('debug', true);

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  products: {
    type: Array,
    required: true,
  },
}, { collection: 'customProducts' });

const ProductV2 = mongoose.model("ProductV2", productSchema);

module.exports = { ProductV2 };
