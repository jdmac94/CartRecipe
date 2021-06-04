const mongoose = require("mongoose");
mongoose.set("debug", true);

const productSchema = new mongoose.Schema(
  {
    id: {
      type: String,
    },
    product_name: {
      type: String,
    },
    product_name_es: {
      type: String,
    },
    nutriments: {},
    ecoscore_grade: {
      type: String,
    },
    nova_groups: {
      type: String,
    },
    quantity: {
      type: String,
    },
    nutriscore_grade: {
      type: String,
    },
    ingredients_analysis_tags: {},
    allergens_tags: {
      type: Array,
      default: [],
    },
    traces: {
      type: String,
    },
    traces_tags: {
      type: Array,
    },
    ingredients_text_es: {
      type: String,
    },
    inner_ingredient: {
      type: String,
    },
    inner_category: {
      type: String,
    },
    imgs: {
      type: Array,
      default: [],
    },
  },
  { collection: "customProducts" }
);

const ProductV2 = mongoose.model("ProductV2", productSchema);

module.exports = { ProductV2 };
