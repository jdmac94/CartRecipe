const fetch = require("node-fetch");
const getImageAPI = (code) => {
  let OFFurl = "https://world.openfoodfacts.org/api/v0/product/";
  let url = OFFurl + code + ".json";
  var fotos = fetch(url)
    .then(function (response) {
      if (response)
        if (response.product.selected_images)
          if (response.product.selected_images.front)
            if (response.product.selected_images.front.display) {
              return [response.product.selected_images.front.display];
            }

      return [];
    })
    .catch(function (error) {
      console.log("Hubo un problema con la petición Fetch:" + error.message);
      return undefined;
    });
};

module.exports = { getImageAPI };
