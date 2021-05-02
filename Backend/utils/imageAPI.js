const fetch = require("node-fetch");
let OFFurl = "https://world.openfoodfacts.org/api/v0/product/";

const getImageAPI = (code) => {
  let OFFurl = "https://world.openfoodfacts.org/api/v0/product/";
  let url = OFFurl + code + ".json";
  var fotos = fetch(url)
    .then(function (response) {
      return response.json();
    })
    .catch(function (error) {
      console.log("Hubo un problema con la petición Fetch:" + error.message);
      return undefined;
    });

    console.log(fotos);
    if (fotos)
      if (fotos.product.selected_images)
        if (fotos.product.selected_images.front)
          if (fotos.product.selected_images.front.display) {
            return [fotos.product.selected_images.front.display];
          }

    return [];
};

async function getImgByAPI(code) {
  // console.log("getImgByAPI");
  let url = OFFurl + code + '.json';
  // console.log(url);

  var fotos = fetch(url)
  .then(function(response) {
      return response.json();
  })
  .catch(function(error) {
      console.log('Hubo un problema con la petición Fetch:' + error.message);
      return undefined;
  });
  // console.log("fotos");
  //console.log(fotos);
  return fotos;
}

async function checkImgFromAPI(code) {
  // console.log("checkImgFromAPI");
  var fotos = await getImgByAPI(code);
  
  if (fotos)
      if (fotos.product.selected_images)
          if (fotos.product.selected_images.front)
              if (fotos.product.selected_images.front.display) {
                  
                  return [ fotos.product.selected_images.front.display ];
              }

  return [];
}

module.exports = { checkImgFromAPI };
